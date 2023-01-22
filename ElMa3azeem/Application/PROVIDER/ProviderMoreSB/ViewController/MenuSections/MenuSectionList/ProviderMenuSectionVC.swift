//
//  ProviderMenuSectionVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import UIKit

class ProviderMenuSectionVC: BaseViewController {
    @IBOutlet weak var sectionsTableView: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var emptyStack: UIStackView!
    @IBOutlet weak var headerView: UIView!

    private var menuArray = [MenuModel]()
    private let refreshControl = UIRefreshControl()
    private var isFirstResponse = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMenu()
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        setupHeaderViewStyle()
        tableViewConfigration()
        setupRefreshControl()
    }

    private func tableViewConfigration() {
        sectionsTableView.delegate = self
        sectionsTableView.dataSource = self
        sectionsTableView.registerCell(type: ProviderMenuSectionCell.self)
    }

    private func getApiData() {
        menuArray.removeAll()
        getMenu()
    }

    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        sectionsTableView.addSubview(refreshControl)
    }

    private func setupHeaderViewStyle() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 5
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @objc func refresh(_ sender: AnyObject) {
        isFirstResponse = true
        getApiData()
        refreshControl.endRefreshing()
    }

    // MARK: - LOGIC

    // MARK: - NAVIGATIONS

    private func navigateToMenuSetting(reason: ScreenReason, menu: MenuModel? = nil) {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderAddMenuVC.self)
        vc.screenReason = reason
        vc.menuData = menu
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToDeletePopup(menuID : Int) {
        let vc = AppStoryboards.ProviderMore.instantiate(DeleteMeenuVC.self)
        vc.delete = { [weak self] in
            guard let self = self else { return }
            self.deleteMenu(menuID: menuID)
        }
        present(vc, animated: true)
    }

    private func naviagteToSuccessDelete() {
        let vc = AppStoryboards.Order.instantiate(SuccessfullyViewPopupVC.self)
        vc.titleMessage = .deleteMenuSuccessfully
        vc.backButtonTitle = .back
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.getMenu()
        }
        present(vc, animated: true)
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addNewSectionAction(_ sender: Any) {
        navigateToMenuSetting(reason: .addNew)
    }
}

// MARK: - TableView Extension

extension ProviderMenuSectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ProviderMenuSectionCell.self, for: indexPath) as! ProviderMenuSectionCell
        cell.configCell(title: menuArray[indexPath.row].name, time: menuArray[indexPath.row].createdAt)

        cell.editMenuTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToMenuSetting(reason: .edit, menu: self.menuArray[indexPath.row])
        }

        cell.deleteMenuTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToDeletePopup(menuID: self.menuArray[indexPath.row].id)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ProviderMenuSectionVC {
    func getMenu() {
        showLoader()
        ProviderProductRouter.getStoreMenu.send(GeneralModel<[MenuModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getMenu()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.data?.isEmpty == true {
                        self.emptyImage.isHidden = false
                        self.emptyStack.isHidden = false
                        self.sectionsTableView.isHidden = true
                    } else {
                        self.emptyImage.isHidden = true
                        self.emptyStack.isHidden = true
                        self.sectionsTableView.isHidden = false

                        self.menuArray = response.data ?? []
                        self.isFirstResponse ? self.sectionsTableView.reloadWithAnimation() : self.sectionsTableView.reloadData()
                        self.isFirstResponse = false
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func deleteMenu(menuID: Int) {
        showLoader()
        ProviderMoreRouter.deleteMenu(menuID: menuID).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.deleteMenu(menuID: menuID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.naviagteToSuccessDelete()
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}
