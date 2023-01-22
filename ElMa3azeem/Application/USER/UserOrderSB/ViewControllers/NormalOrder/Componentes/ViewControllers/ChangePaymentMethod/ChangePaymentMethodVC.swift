//
//  ChangePaymentMethodVC.swift
//  
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/01/2022.
//

import UIKit
import NVActivityIndicatorView
import BottomPopup

class ChangePaymentMethodVC: BottomPopupViewController {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.4 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @IBOutlet weak var backViewHight: NSLayoutConstraint!
    @IBOutlet weak var backGroungView: UIView!
    @IBOutlet weak var paymentTableView: IntrinsicTableView!
    
    var paymentWayArray = [PaymentMethod]()
    var selectedPaymentIndex = 0
    var paymentKey = String()
    var orderID = Int()
    var changePaymentSuccess : (()->())?
    var onlinePayment : (()->())?
    var screenReason : ScreenReason = .changePaymentWay
    
    enum ScreenReason {
        case onlinePay
        case changePaymentWay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentWay()
        setupView()
    }
    
    func setupView() {
        paymentTableView.tableFooterView = UIView()
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.register(UINib(nibName: "PaymentWayCell", bundle: nil), forCellReuseIdentifier: "PaymentWayCell")
        self.paymentTableView.reloadWithAnimation()
        
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        self.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            if self.paymentTableView.contentSize.height + 150 + 80 < self.view.frame.height {
                self.backViewHight.constant = self.paymentTableView.contentSize.height + 150 + 80
            }else{
                self.backViewHight.constant = self.view.frame.height * 0.70
            }
        }
    }
    
    @IBAction func changeAction(_ sender: Any) {
        do {
            let payment = try ValidationService.validate(paymentWay: paymentKey)
            switch screenReason {
            case .changePaymentWay:
                changePaymentApi(orderID: "\(orderID)", paymentType: payment)
            case .onlinePay:
                dismiss(animated: true)
                onlinePayment?()
            }
        } catch {
            showError(error: error.localizedDescription)
        }
    }
    
}

//MARK: - TableView Extension -
extension ChangePaymentMethodVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentWayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentWayCell", for: indexPath) as! PaymentWayCell
        
        if indexPath.row < paymentWayArray.count {
            if indexPath.row == selectedPaymentIndex {
                cell.configCell(item: paymentWayArray[indexPath.row])
                cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.40)
                cell.cellBackGround.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
                cell.cellBackGround.layer.borderWidth = 1
                cell.selectImage.isHidden = false
            } else {
                cell.configCell(item: paymentWayArray[indexPath.row])
                cell.cellBackGround.backgroundColor = .appColor(.SecondViewBackGround)
                cell.cellBackGround.layer.borderWidth = 0
                cell.selectImage.isHidden = true
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == paymentTableView {
            self.selectedPaymentIndex = indexPath.row
            self.paymentKey = paymentWayArray[indexPath.row].key
            self.paymentTableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - API Extention
extension ChangePaymentMethodVC {
    func getPaymentWay() {
        self.showLoader()
        CreateOrderNetworkRouter.paymentMethod.send(GeneralModel<PaymentModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getPaymentWay()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.paymentWayArray.append(contentsOf: data.data?.paymentMethods ?? [])
                    let index = self.paymentWayArray.firstIndex(where: {$0.key == self.paymentKey}) ?? 0
                    self.paymentKey = self.paymentWayArray[index].key
                    self.selectedPaymentIndex = index
                    self.paymentTableView.reloadData()
                    
                    DispatchQueue.main.async {
                        if self.paymentTableView.contentSize.height + 150 + 80 < self.view.frame.height {
                            self.backViewHight.constant = self.paymentTableView.contentSize.height + 150 + 80
                        }else{
                            self.backViewHight.constant = self.view.frame.height * 0.70
                        }
                    }
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func changePaymentApi(orderID : String , paymentType : String) {
        self.showLoader()
            CreateOrderNetworkRouter.changePaymentMethod(orderID: orderID, paymentType: paymentType).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.changePaymentApi(orderID: orderID, paymentType: paymentType)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.dismiss(animated: true)
                    self.changePaymentSuccess?()
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
