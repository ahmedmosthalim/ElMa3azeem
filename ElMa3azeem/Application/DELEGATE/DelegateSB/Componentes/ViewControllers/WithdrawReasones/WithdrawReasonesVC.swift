//
//  WithdrawReasonesVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/01/2022.
//

import UIKit
import NVActivityIndicatorView
import BottomPopup


class WithdrawReasonesVC: BottomPopupViewController {
    
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
    @IBOutlet weak var reasonsTableView: IntrinsicTableView!
    
    var reasonsArray = [ReasonsData]()
    var selectedReasonsIndex = 0
    var orderID = Int()
    
    var withDrawSuccess : (()->())?
    var cancelReason = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCancelReasones()
        setupView()
    }
    
    func setupView() {
        reasonsTableView.tableFooterView = UIView()
        reasonsTableView.delegate = self
        reasonsTableView.dataSource = self
        reasonsTableView.register(UINib(nibName: "CancelReasonsCell", bundle: nil), forCellReuseIdentifier: "CancelReasonsCell")
        self.reasonsTableView.reloadWithAnimation()
        
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        self.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            if self.reasonsTableView.contentSize.height + 150 + 80 < self.view.frame.height {
                self.backViewHight.constant = self.reasonsTableView.contentSize.height + 150 + 80
            }else{
                self.backViewHight.constant = self.view.frame.height * 0.70
            }
        }
    }
    
    @IBAction func confirmCancelAction(_ sender: Any) {
        cancelOrder(orderID: orderID, reasone: cancelReason)
    }
    
    @IBAction func CancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - TableView Extension -
extension WithdrawReasonesVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelReasonsCell", for: indexPath) as! CancelReasonsCell
        if indexPath.row < reasonsArray.count {
            if indexPath.row == selectedReasonsIndex {
                cell.configCell(item: reasonsArray[indexPath.row])
                cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.10)
                cell.selectImage.isHidden = false
            }else{
                cell.configCell(item: reasonsArray[indexPath.row])
                cell.cellBackGround.backgroundColor = .white
                cell.selectImage.isHidden = true
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == reasonsTableView {
            self.selectedReasonsIndex = indexPath.row
            self.cancelReason = reasonsArray[indexPath.row].reason
            self.reasonsTableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - API Extention
extension WithdrawReasonesVC {
    func getCancelReasones() {
        self.showLoader()
        DelegateNetworkRouter   .withdrawReasones.send(GeneralModel<ReasonsModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCancelReasones()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.reasonsArray.append(contentsOf: data.data?.reasons ?? [])
                    self.cancelReason = self.reasonsArray.first?.reason ?? ""
                    self.reasonsTableView.reloadData()
                    
                    DispatchQueue.main.async {
                        if self.reasonsTableView.contentSize.height + 150 + 80 < self.view.frame.height {
                            self.backViewHight.constant = self.reasonsTableView.contentSize.height + 150 + 80
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
    func cancelOrder(orderID : Int , reasone : String) {
        self.showLoader()
            DelegateNetworkRouter.withdrawFromOrder(orderID: String(orderID), reason: reasone).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.cancelOrder(orderID: orderID, reasone: reasone)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.dismiss(animated: true)
                    self.withDrawSuccess?()
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
