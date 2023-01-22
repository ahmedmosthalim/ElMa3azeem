//
//  ProviderMyOrdersVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 14/11/2022.
//

import UIKit

class ProviderMyOrdersVC: BaseViewController {
    
    
    @IBOutlet weak var orderTableView       : UITableView!

    @IBOutlet weak var waitingApprovalBtn   : RoundedButton!
    @IBOutlet weak var currentOrdersBtn     : RoundedButton!
    @IBOutlet weak var finishedOrdersBrn    : RoundedButton!

    @IBOutlet weak var noDataImage  : UIImageView!
    @IBOutlet weak var noDataStack  : UIStackView!
    
    
    //    @IBOutlet weak var notificationView: UIView!
    let refreshControl      = UIRefreshControl()
    var ordersArray         = [Order]()
    var selectedOrderState  : ProviderOrderState?

    var isActive    = true
    var CurrentPage = 1
    var lastPage    = 1

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
//            self.notificationView.isHidden = true
        } else {
//            self.notificationView.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.showTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .reloadProviderTableView, object: nil)
        setupView()
        selectedOrderState = .pending
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.getMyOrders(status: self.selectedOrderState?.rawValue ?? "", page: self.CurrentPage)
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        orderTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        ordersArray.removeAll()
        CurrentPage = 1
        lastPage = 1
        getMyOrders(status: selectedOrderState?.rawValue ?? "",page: CurrentPage)
        refreshControl.endRefreshing()
    }

    @objc func reloadView(_ sender: AnyObject) {
        ordersArray.removeAll()
        CurrentPage = 1
        lastPage = 1
        getMyOrders(status: selectedOrderState?.rawValue ?? "", page: CurrentPage)
    }

    func didTapTabbar() {
        selectWaitingApproval()
        selectedOrderState = .pending
//        selectedOrderType = ""
        updateData()
    }

    @objc func updateNotification(_ sender: AnyObject) {
        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
//            self.notificationView.isHidden = true
        } else {
//            self.notificationView.isHidden = false
        }
    }

    func setupView() {
        waitingApprovalBtn.selectButton()
        currentOrdersBtn.notSelectButton()
        finishedOrdersBrn.notSelectButton()

        orderTableView.tableFooterView = UIView()
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        orderTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }

    func selectWaitingApproval() {
        waitingApprovalBtn.selectButton()
        currentOrdersBtn.notSelectButton()
        finishedOrdersBrn.notSelectButton()
        orderTableView.scrollToTop()
    }

    func updateData() {
        CurrentPage = 1
        lastPage = 1
        ordersArray.removeAll()
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.getMyOrders(status: self.selectedOrderState?.rawValue ?? "", page: self.CurrentPage)
        }
    }

    @IBAction func waitingApprovalAction(_ sender: Any) {
        waitingApprovalBtn.selectButton()
        currentOrdersBtn.notSelectButton()
        finishedOrdersBrn.notSelectButton()
        selectedOrderState = .pending
        updateData()
    }

    @IBAction func currentOrdersAction(_ sender: Any) {
        waitingApprovalBtn.notSelectButton()
        currentOrdersBtn.selectButton()
        finishedOrdersBrn.notSelectButton()
        selectedOrderState = .inprogress
        updateData()
    }

    @IBAction func finishedOrdersAction(_ sender: Any) {
        waitingApprovalBtn.notSelectButton()
        currentOrdersBtn.notSelectButton()
        finishedOrdersBrn.selectButton()
        selectedOrderState = .delivered
        updateData()
    }

    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - tabbar Extension

extension ProviderMyOrdersVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            if defult.shared.getData(forKey: .token) != "" && defult.shared.getData(forKey: .token) != nil {
                didTapTabbar()
            }
        }
    }
}

// MARK: - TableView Extension

extension ProviderMyOrdersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        if indexPath.row < ordersArray.count {
            cell.configeCell(order: ordersArray[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryBoard.ProviderOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderOrderDetailsVC") as! ProviderOrderDetailsVC
        vc.orderID = ordersArray[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let ContentHeight = scrollView.contentSize.height

        if isActive {
            if position > ContentHeight - orderTableView.frame.height {
                print("Done")
                isActive = false
                print(CurrentPage, lastPage)
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                    getMyOrders(status: selectedOrderState?.rawValue ?? "", page: CurrentPage)
                }
            }
        }
    }
}

// MARK: - API Extension

extension ProviderMyOrdersVC {
    func getMyOrders(status: String, page: Int) {
        showLoader()
        ProviderHomeNetworkRouter.myOrders(status: status, page: String(page)).send(GeneralModel<OrderModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getMyOrders(status: status, page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.orders.isEmpty == false {
                        self.orderTableView.isHidden = false
                        self.noDataImage.isHidden = true
                        self.noDataStack.isHidden = true
                        self.ordersArray.append(contentsOf: data.data?.orders ?? [])
                        self.lastPage = data.data?.pagination?.totalPages ?? 0
                        if self.isActive == false {
                            self.orderTableView.reloadData()
                        } else {
                            self.orderTableView.reloadWithAnimation()
                        }
                        self.isActive = true
                    } else {
                        self.orderTableView.isHidden = true
                        self.noDataImage.isHidden = false
                        self.noDataStack.isHidden = false
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
