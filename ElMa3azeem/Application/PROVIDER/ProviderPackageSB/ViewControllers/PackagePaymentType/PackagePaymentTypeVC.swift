//
//  PackagePaymentTypeVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 22/11/2022.
//

import BottomPopup
import NVActivityIndicatorView
import UIKit

class PackagePaymentTypeVC: BottomPopupViewController {
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
    var didSelectPaymentWay : ((PaymentMethod)->())?

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
        paymentTableView.reloadWithAnimation()

        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        viewDidLayoutSubviews()
        DispatchQueue.main.async {
            if self.paymentTableView.contentSize.height + 150 + 80 < self.view.frame.height {
                self.backViewHight.constant = self.paymentTableView.contentSize.height + 150 + 80
            } else {
                self.backViewHight.constant = self.view.frame.height * 0.70
            }
        }
    }

    // MARK: - ACTIONS

    @IBAction func changeAction(_ sender: Any) {
        guard let payment = paymentWayArray.first(where: { $0.isSelected == true }) else {
            showError(error: "".localized)
            return
        }
        
        dismiss(animated: true)
        didSelectPaymentWay?(payment)
    }
}

// MARK: - TableView Extension -

extension PackagePaymentTypeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentWayArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentWayCell", for: indexPath) as! PaymentWayCell

        if indexPath.row < paymentWayArray.count {
            cell.configCell(item: paymentWayArray[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymentWayArray.mapInPlace({ $0.isSelected = false })
        paymentWayArray[indexPath.row].isSelected = true
        paymentTableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - API Extention

extension PackagePaymentTypeVC {
    func getPaymentWay() {
        showLoader()
        ProviderPackagesRouter.getPaymentWay.send(GeneralModel<PaymentModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getPaymentWay()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.paymentWayArray.append(contentsOf: data.data?.paymentMethods ?? [])
                    !(data.data?.paymentMethods.isEmpty ?? false) ? (self.paymentWayArray[0].isSelected = true) : ()
                    self.paymentTableView.reloadData()

                    DispatchQueue.main.async {
                        if self.paymentTableView.contentSize.height + 150 + 80 < self.view.frame.height {
                            self.backViewHight.constant = self.paymentTableView.contentSize.height + 150 + 80
                        } else {
                            self.backViewHight.constant = self.view.frame.height * 0.70
                        }
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
