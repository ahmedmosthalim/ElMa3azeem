//
//  MyDeliveryVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import UIKit

class MyDeliveryVC: BaseViewController {
    @IBOutlet weak var deliveryTableView: UITableView!

    @IBOutlet weak var waitingApprovalBtn: RoundedButton!
    @IBOutlet weak var currentOrdersBtn: RoundedButton!
    @IBOutlet weak var finishedOrdersBrn: RoundedButton!

    let refreshControl = UIRefreshControl()

    var ordersArray = [DelegateOrder]()
    var selectedOrderState: orderState?
    var selectedOrderType = ""

    var isActive = true
    var CurrentPage = 1
    var lastPage = 1

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
//            notificationView.isHidden = true
        } else {
//            notificationView.isHidden = false
        }

        setupStatusBar(color: .appColor(.viewBackGround)!)
    }

    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.showTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotification), name: .reloadNotificationCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .reloadMyDeliveryTableView, object: nil)
        
        if defult.shared.user()?.user?.accType == AccountType.user.rawValue ||  defult.shared.user()?.user?.accType == nil{

        } else {
            
            loginAsVisitor { [weak self] in
                guard let self = self else { return }
                self.getNearOrder(type: self.selectedOrderType, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: self.CurrentPage)
            }
        }

        setupView()
        selectedOrderState = .open
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        deliveryTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        CurrentPage = 1
        lastPage = 1
        ordersArray.removeAll()

        if selectedOrderState == .open {
            getNearOrder(type: selectedOrderType, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage)
        } else {
            getDelegateOrders(status: selectedOrderState?.rawValue ?? "", type: selectedOrderType, page: CurrentPage)
        }
        refreshControl.endRefreshing()
    }

    @objc func reloadView(_ sender: AnyObject) {
        CurrentPage = 1
        lastPage = 1
        ordersArray.removeAll()

        if selectedOrderState == .open {
            getNearOrder(type: selectedOrderType, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage)
        } else {
            getDelegateOrders(status: selectedOrderState?.rawValue ?? "", type: selectedOrderType, page: CurrentPage)
        }
    }

    @objc func updateNotification(_ sender: AnyObject) {
        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
            
        } else {

        }
    }

    func setupView() {
        tabBarController?.delegate = self
        waitingApprovalBtn.selectButton()
        currentOrdersBtn.notSelectButton()
        finishedOrdersBrn.notSelectButton()

        deliveryTableView.tableFooterView = UIView()
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        deliveryTableView.register(UINib(nibName: "MyDeliveryCell", bundle: nil), forCellReuseIdentifier: "MyDeliveryCell")
        deliveryTableView.register(UINib(nibName: "MyDeliverySpecislCell", bundle: nil), forCellReuseIdentifier: "MyDeliverySpecislCell")

        deliveryTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }

    func selectWaitingApproval() {
        waitingApprovalBtn.selectButton()
        currentOrdersBtn.notSelectButton()
        finishedOrdersBrn.notSelectButton()
        deliveryTableView.scrollToTop()
    }

    func didTapTabbar() {
        selectWaitingApproval()
        selectedOrderState = .open
        selectedOrderType = ""
        getNearOrder(type: selectedOrderType, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage)
    }

    func updateData() {
        CurrentPage = 1
        lastPage = 1
        ordersArray.removeAll()
        if selectedOrderState == .open {
            getNearOrder(type: selectedOrderType, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage)
        } else {
            getDelegateOrders(status: selectedOrderState?.rawValue ?? "", type: selectedOrderType, page: CurrentPage)
        }
    }

    @IBAction func waitingApprovalAction(_ sender: Any) {
        waitingApprovalBtn.selectButton()
        currentOrdersBtn.notSelectButton()
        finishedOrdersBrn.notSelectButton()
        selectedOrderState = .open
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
        selectedOrderState = .finished
        updateData()
    }

    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func registerAsDelegateAction(_ sender: Any) {
        SocialMedia.shared.openUrl(url: URLs.delegateJoinRequestUrl)
    }
}

// MARK: - tabbar Extension

extension MyDeliveryVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            if defult.shared.getData(forKey: .token) != "" && defult.shared.getData(forKey: .token) != nil {
                if defult.shared.user()?.user?.accType == AccountType.delegate.rawValue {
                    didTapTabbar()
                }
            }
        }
    }
}

// MARK: - TableView Extension

extension MyDeliveryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < ordersArray.count {
            if selectedOrderType == "special_request" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyDeliverySpecislCell", for: indexPath) as! MyDeliverySpecislCell
                cell.configeCell(order: ordersArray[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyDeliveryCell", for: indexPath) as! MyDeliveryCell
                cell.configeCell(order: ordersArray[indexPath.row])
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryBoard.Delegate.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DelegateOrderDetailsVC") as! DelegateOrderDetailsVC
        vc.orderID = ordersArray[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedOrderType == "special_request" {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let ContentHeight = scrollView.contentSize.height

        if isActive {
            if position > ContentHeight - deliveryTableView.frame.height {
                print("Done")
                isActive = false
                print(CurrentPage, lastPage)
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                }
            }
        }
    }
}

// MARK: - API extention

extension MyDeliveryVC {
    func getNearOrder(type: String, lat: String, long: String, page: Int) {
        showLoader()
        HomeNetworkRouter.delegateNearOrder(type: type, lat: lat, long: long, page: String(page)).send(GeneralModel<DelegateNearOrderModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getNearOrder(type: type, lat: lat, long: long, page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.orders.isEmpty == false {
                        self.deliveryTableView.isHidden = false
                        self.ordersArray.append(contentsOf: data.data?.orders ?? [])
                        self.lastPage = data.data?.pagination?.totalPages ?? 0

                        if self.isActive == false {
                            self.deliveryTableView.reloadData()
                        } else {
                            self.deliveryTableView.reloadWithAnimation()
                        }

                        self.isActive = true
                    } else {
                        self.deliveryTableView.isHidden = true
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func getDelegateOrders(status: String, type: String, page: Int) {
        showLoader()
        HomeNetworkRouter.delegateDeliveryOrders(status: status, type: type, page: String(page)).send(GeneralModel<DelegateNearOrderModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getDelegateOrders(status: status, type: type, page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.orders.isEmpty == false {
                        self.deliveryTableView.isHidden = false
                        self.ordersArray.append(contentsOf: data.data?.orders ?? [])
                        self.lastPage = data.data?.pagination?.totalPages ?? 0
                        if self.isActive == false {
                            self.deliveryTableView.reloadData()
                        } else {
                            self.deliveryTableView.reloadWithAnimation()
                        }
                        self.isActive = true
                    } else {
                        self.deliveryTableView.isHidden = true
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
