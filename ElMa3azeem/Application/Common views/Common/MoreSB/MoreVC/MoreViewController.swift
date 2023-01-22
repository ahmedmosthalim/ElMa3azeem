//
//  MoreViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import Cosmos
import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

final class MoreViewController: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var AboutAccountTableView        : IntrinsicTableView!
    @IBOutlet weak var generalTableView             : IntrinsicTableView!
    @IBOutlet weak var generalInformationTableview  : IntrinsicTableView!

    // MARK: - OutLets

    var presenter: MorePresenter?
    let configer = MoreConfiguratorImplementation()

    // MARK: - LifeCycle Events

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateNotification), name: .reloadNotificationCount, object: nil)
        configer.configure(MoreViewController: self)
        setupView()
        presenter?.viewDidLoad()
        tabBarController?.showTabbar()
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let account = defult.shared.user()?.user?.accountType else { return }
        loginAsVisitor { [weak self] in
            guard let self = self else { return }

            switch defult.shared.user()?.user?.accountType {
            case .user:
                self.presenter?.getProfile()
            case .delegate:
                self.presenter?.getProfile()
            case .provider:
                self.presenter?.getProfile()
                self.presenter?.getProviderProfile()
            case .unknown:
                self.presenter?.viewDidLoad()
            case .none:
                self.presenter?.viewDidLoad()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.showTabbar()
    }

    @objc func updateNotification(_ sender: AnyObject) {
        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
//            self.notificationView.isHidden = true
        } else {
//            self.notificationView.isHidden = false
        }
    }

    // MARK: - Logic

    func setupView() {
        // setupStatusBar
        AboutAccountTableView.delegate = self
        AboutAccountTableView.dataSource = self
        AboutAccountTableView.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: "MoreCell")

        generalTableView.delegate = self
        generalTableView.dataSource = self
        generalTableView.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: "MoreCell")

        generalInformationTableview.tableFooterView = UIView()
        generalInformationTableview.delegate = self
        generalInformationTableview.dataSource = self
        generalInformationTableview.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: "MoreCell")
    }

    func logOut() {
        let language = Language.currentLanguage()
        
        SocketConnection.sharedInstance.socket.off("unsubscribe")
        SocketConnection.sharedInstance.socket.disconnect()
        NotificationCenter.default.post(name: .disConnectSocket, object: nil)
        UserDefaults.standard.removeObject(forKey: "token")
        defult.shared.removeAll()
        let mangare = LoginManager()
        mangare.logOut()

        Language.setAppLanguage(lang: language)
        defult.shared.setData(data: false, forKey: .isFiristLuanch)

        let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
        let nav = CustomNavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }

    // MARK: - Networking

    func logOutApi() {
        showLoader()
        HomeNetworkRouter.logOut.send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.logOutApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.logOut()
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    // MARK: - Actions

    @objc func logOutAction(sender: UITapGestureRecognizer) {
        let vc = AppStoryboards.More.instantiate(LogoutVC.self)
        vc.logOut = { [weak self] in
            guard let self = self else { return }
            self.logOutApi()
        }
        present(vc, animated: true)
    }

    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        presenter?.navigateToNotification()
    }
}

extension MoreViewController: MoreView {
    func fitchDataSuccess(user: UserModel?) {
        defult.shared.saveUser(user: user)
    }

    func fitchDataSuccess(provider: StoreDetailsData?) {
        defult.shared.saveProvider(provider: provider)
    }

    func updateView() {
        AboutAccountTableView.reloadData()
        generalTableView.reloadData()
        generalInformationTableview.reloadData()
    }

    func openAppStore() {
        if let url = URL(string: "itms-apps://apple.com/app/1488246406") {
            UIApplication.shared.open(url)
        }
    }

    func logOutAction() {
        let vc = AppStoryboards.More.instantiate(LogoutVC.self)
        vc.logOut = { [weak self] in
            guard let self = self else { return }
            self.logOutApi()
        }
        present(vc, animated: true)
    }
}

// MARK: - TableView Extension -

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == AboutAccountTableView {
            return presenter?.AccountInformationArrayCount() ?? 0
        } else if tableView == generalTableView {
            return presenter?.GeneralSettingArrayCount() ?? 0
        } else {
            return presenter?.generalInformationArrayCount() ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell

        if tableView == AboutAccountTableView {
            presenter?.configureAccountInfo(cell: cell, forRow: indexPath.row)
        } else if tableView == generalTableView {
            presenter?.configureGeneralSetting(cell: cell, forRow: indexPath.row)
        } else {
            presenter?.configureGeneralInformation(cell: cell, forRow: indexPath.row)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == AboutAccountTableView {
            loginAsVisitor {
                self.presenter?.selectItem(index: indexPath.row, section: "AboutAccount")
            }

        } else if tableView == generalTableView {
            presenter?.selectItem(index: indexPath.row, section: "generalSetting")
        } else {
            presenter?.selectItem(index: indexPath.row, section: "GeneralInformation")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
