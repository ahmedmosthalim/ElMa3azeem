//
//  NotificationSettingVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 12/11/2022.
//

import UIKit

class NotificationSettingVC: BaseViewController {
    @IBOutlet weak var adsSwitch: UISwitch!
    @IBOutlet weak var newOrderSwitch: UISwitch!
    @IBOutlet weak var nearlySwitch: UISwitch!

    @IBOutlet weak var newOrderView: UIView!

    // MARK: - Properties -

    var adsSwitchValue = defult.shared.user()?.user?.offerNotify
    var newOrderSwitchValue = defult.shared.user()?.user?.newOrderNotify

    // MARK: - LifeCycle Events

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkingOnNotification()
    }

    func checkingOnNotification() {
        if adsSwitchValue == true {
            adsSwitch.isOn = true
        } else {
            adsSwitch.isOn = false
        }

        if newOrderSwitchValue == true {
            newOrderSwitch.isOn = true
        } else {
            newOrderSwitch.isOn = false
        }
    }

    // MARK: - Logic

    func setupView() {
        tabBarController?.hideTabbar()

        if defult.shared.user()?.user?.accType == AccountType.user.rawValue {
            newOrderView.isHidden = true
        }

        adsSwitch.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        newOrderSwitch.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        nearlySwitch.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
    }

    func adsToggleSwitch(status: Bool) {
        adsSwitch.setOn(status, animated: true)
    }

    func newOrderToggleSwitch(status: Bool) {
        newOrderSwitch.setOn(status, animated: true)
    }

    // MARK: - Actions

    @IBAction func backActionl(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addsToggleSwitch(_ sender: UISwitch) {
        adsSwitchValue = !(adsSwitchValue ?? false)
        adsToggleSwitch(status: adsSwitchValue ?? false)
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.notificationControllAPi(notify: String(self.adsSwitchValue ?? false), newOrder: String(self.newOrderSwitchValue ?? false))
        }
    }

    @IBAction func orderToggleSwitch(_ sender: UISwitch) {
        newOrderSwitchValue = !(newOrderSwitchValue ?? false)
        newOrderToggleSwitch(status: newOrderSwitchValue ?? false)
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.notificationControllAPi(notify: String(self.adsSwitchValue ?? false), newOrder: String(self.newOrderSwitchValue ?? false))
        }
    }

    // MARK: - Networking

    func notificationControllAPi(notify: String, newOrder: String) {
        showLoader()
        MoreNetworkRouter.notificationControll(offerNotify: notify, newOrder: newOrder).send(GeneralModel<HomeModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection {
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
