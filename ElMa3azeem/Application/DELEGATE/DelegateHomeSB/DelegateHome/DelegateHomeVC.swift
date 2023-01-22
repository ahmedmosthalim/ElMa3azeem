//
//  DelegateHomeVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import CoreLocation
import SwiftMessages
import UIKit

class DelegateHomeVC: BaseViewController {
    @IBOutlet weak var deliveryTableView: UITableView!

    @IBOutlet weak var emptyStack: UIStackView!
    @IBOutlet weak var emptyImage: UIImageView!

    var locationManager = CLLocationManager()
    let refreshControl = UIRefreshControl()
    var ordersArray = [DelegateOrder]()
    var selectedOrderState: orderState?
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
    }

    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.showTabbar()
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.updateData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupocationManger()
        tabBarController?.delegate = self
        LocationManager.shared.requestLocationAuthorization()
    }

    func setupocationManger() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:

                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.startUpdatingLocation()

            case .denied, .notDetermined, .restricted:
                let alert = UIAlertController(title: "Warning!".localized, message: "Please , enable location to detect your location".localized, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings".localized, style: UIAlertAction.Style.default, handler: { _ in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }))
                present(alert, animated: true, completion: nil)

            @unknown default:
                break
            }
        } else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }

    @objc func reloadView(_ sender: AnyObject) {
        updateData()
    }

    @objc func updateNotification(_ sender: AnyObject) {
        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
        } else {
        }
    }

    func setupView() {
//        selectedOrderState = .open
        tableViewConfigration()
        setupObserver()
        setupRefreshControl()

        emptyStack.isHidden = true
        emptyImage.isHidden = true
    }

    private func tableViewConfigration() {
        deliveryTableView.tableFooterView = UIView()
        deliveryTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        deliveryTableView.register(UINib(nibName: "MyDeliveryCell", bundle: nil), forCellReuseIdentifier: "MyDeliveryCell")
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotification), name: .reloadNotificationCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .reloadMyDeliveryTableView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disConnectSocket), name: .disConnectSocket, object: nil)
    }

    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        deliveryTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        CurrentPage = 1
        lastPage = 1
//        ordersArray.removeAll()

        getNearOrder(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage)

        refreshControl.endRefreshing()
    }

    func selectWaitingApproval() {
        deliveryTableView.scrollToTop()
    }

    func didTapTabbar() {
        selectWaitingApproval()
        selectedOrderState = .open
        getNearOrder(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage)
    }

    func updateData() {
        CurrentPage = 1
        lastPage = 1
//        ordersArray.removeAll()
        getNearOrder(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage)
    }

    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - tabbar Extension

extension DelegateHomeVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            if defult.shared.getData(forKey: .token) != "" && defult.shared.getData(forKey: .token) != nil {
                if defult.shared.user()?.user?.accType == AccountType.delegate.rawValue {
                    didTapTabbar()
                }
            }
        }
    }
}

// MARK: - TableView Extension

extension DelegateHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDeliveryCell", for: indexPath) as! MyDeliveryCell
        if indexPath.row < ordersArray.count {
            cell.configeCell(order: ordersArray[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryBoard.Delegate.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DelegateOrderDetailsVC") as! DelegateOrderDetailsVC
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

extension DelegateHomeVC {
    func getNearOrder(lat: String, long: String, page: Int) {
        showLoader()
        HomeNetworkRouter.delegateNearOrder(type: "", lat: lat, long: long, page: String(page)).send(GeneralModel<DelegateNearOrderModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getNearOrder(lat: lat, long: long, page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.orders.isEmpty == false {
                        self.emptyStack.isHidden = true
                        self.emptyImage.isHidden = true
                        self.deliveryTableView.isHidden = false
                        guard let orders = data.data?.orders else{ return }
                        self.ordersArray = orders
                        self.lastPage = data.data?.pagination?.totalPages ?? 0

                        if self.isActive == false {
                            self.deliveryTableView.reloadData()
                        } else {
                            self.deliveryTableView.reloadWithAnimation()
                        }

                        self.isActive = true
                    } else {
                        self.emptyStack.isHidden = false
                        self.emptyImage.isHidden = false
                        self.deliveryTableView.isHidden = true
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

extension DelegateHomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways, status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        } else {
//            locationManager.requestAlwaysAuthorization()
//        }

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        // get the user location
        case .notDetermined, .restricted, .denied:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }

        if defult.shared.getData(forKey: .token) == "" || defult.shared.getData(forKey: .token) == nil {
            manager.stopUpdatingLocation()
            disConnectSocket()
        } else {
            defult.shared.setData(data: false, forKey: .fromLogin)
            defult.shared.setData(data: "\(location.latitude)", forKey: .userLat)
            defult.shared.setData(data: "\(location.longitude)", forKey: .userLong)
            ConnectToSocket()
        }
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?

    public func requestLocationAuthorization() {
        locationManager.delegate = self
        let currentStatus = CLLocationManager.authorizationStatus()

        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }

        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }

    // MARK: - CLLocationManagerDelegate

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationAuthorizationCallback?(status)
    }
}
