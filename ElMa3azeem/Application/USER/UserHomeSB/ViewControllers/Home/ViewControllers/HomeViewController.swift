//
//  HomeViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 26/11/2022.
//

import CoreLocation
import PageControls
import SwiftMessages
import TransitionButton
import UIKit

var notificationRoute: NotificationRoutes?

enum NotificationRoutes {
    case userOrderDetails(id: String)
    case delegateOrderSetails(id: String)
    case userReview
    case chat
}

final class HomeViewController: BaseViewController, UITabBarControllerDelegate {
    @IBOutlet weak var chatBootBtn      : TransitionButton!
    @IBOutlet weak var locationLbl      : UILabel!
    @IBOutlet weak var topView          : UIView!
    @IBOutlet weak var HomeTableView    : IntrinsicTableView!

    let refreshControl  = UIRefreshControl()
    var locationManager = CLLocationManager()
    var homeData        = [HomeModel]()

    // MARK: - UIViewController Events

    override func viewDidAppear(_ animated: Bool) {
        getAddressFromLatLon(
            withLatitude: defult.shared.getData(forKey: .userLat) ?? "",
            withLongitude: defult.shared.getData(forKey: .userLong) ?? "") { [weak self] address, _ in
            self?.locationLbl.text = address == "" ? "Choose your location".localized : address
        }
        removeStatusBarColor()
        tabBarController?.showTabbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        handleNotification()
        tabBarController?.showTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupocationManger()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNotification), name: .reloadNotificationFromFCM, object: nil)
        setupView()
        getHomeData(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "")
//        showWorkWithUsPopup()
    }

    func setupocationManger() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
        } else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }

    @objc func refresh(_ sender: AnyObject) {
        reloadData()
        refreshControl.endRefreshing()
    }

    @objc func reloadNotification(_ sender: AnyObject) {
        unSeenNotificationCountApi()
    }

    func handleNotification() {
        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
//            self.notificationView.isHidden = true
        } else {
//            self.notificationView.isHidden = false
        }

        guard let route = notificationRoute else { return }
        switch route {
        case let .userOrderDetails(id: id):
            let vc = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil).instantiateViewController(withIdentifier: "UserOrderDetailsVC") as! UserOrderDetailsVC
            vc.orderID = Int(id) ?? 0
            navigationController?.pushViewController(vc, animated: true)
        case let .delegateOrderSetails(id: id):
            let vc = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DelegateOrderDetailsVC") as! DelegateOrderDetailsVC
            vc.orderID = Int(id) ?? 0
            navigationController?.pushViewController(vc, animated: true)
        case .userReview:
            let vc = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil).instantiateViewController(withIdentifier: "UserCommentVC") as! UserCommentVC
            vc.isFromMore = true
            navigationController?.pushViewController(vc, animated: true)
        case .chat:
            break
        }
        notificationRoute = nil
    }

    func setupView() {
        topView.clipsToBounds       = true
        topView.layer.cornerRadius  = 13
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        HomeTableView.addSubview(refreshControl)

        HomeTableView.tableFooterView   = UIView()
        HomeTableView.delegate          = self
        HomeTableView.dataSource        = self
        HomeTableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        HomeTableView.register(UINib(nibName: "MostPopularStoreCell", bundle: nil), forCellReuseIdentifier: "MostPopularStoreCell")
        HomeTableView.register(UINib(nibName: "HomeCategoryCell", bundle: nil), forCellReuseIdentifier: "HomeCategoryCell")
        HomeTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        HomeTableView.layoutSubviews()
        HomeTableView.layoutIfNeeded()
    }

    func reloadData() {
        homeData.removeAll()
        getHomeData(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "")
    }

    func removeTab(at index: Int) {
        guard var viewControllers = tabBarController?.viewControllers else { return }
        viewControllers.remove(at: index)
        tabBarController?.viewControllers = viewControllers
        tabBarController?.delegate = self
    }

    // MARK: - Navigation

    func showWorkWithUsPopup() {
        let vc = UIStoryboard(name: StoryBoard.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "WorkWithUsPopupVC") as! WorkWithUsPopupVC
        vc.modalPresentationStyle   = .overFullScreen
        vc.modalTransitionStyle     = .crossDissolve
        present(vc, animated: true)
    }

    // MARK: - Action

    @IBAction func ChooseLocationAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoard.Home.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func searchInStoresAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
        vc.categoryid   = ""
        vc.viewTitle    = "Stores".localized
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func chatBootAction(_ sender: UIButton) {
        chatBootBtn.startAnimation()

        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                guard let self = self else { return }
                self.chatBootBtn.stopAnimation(animationStyle: .expand, completion: {
                    let vc = UIStoryboard(name: StoryBoard.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ChatBootVC") as! ChatBootVC
                    vc.homeCategory = self.homeData.first(where: { $0.category == HomeData.categories.rawValue })?.categories ?? []
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            })
        })
    }
}

// MARK: - Location Delegate

extension HomeViewController: didPickLocationDelegate {
    func finishPickingLocationWith(location: CLLocationCoordinate2D, address: String) {
        defult.shared.setData(data: "\(location.latitude)", forKey: .userLat)
        defult.shared.setData(data: "\(location.longitude)", forKey: .userLong)
        defult.shared.setData(data: address, forKey: .userAddress)
        locationLbl.text = address
        getHomeData(lat: "\(location.latitude)", long: "\(location.longitude)")
    }

    func failPickingLocation() {
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways, status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }

        if defult.shared.getDataBool(forKey: .fromLogin) == true {
            defult.shared.setData(data: false, forKey: .fromLogin)
            defult.shared.setData(data: "\(location.latitude)", forKey: .userLat)
            defult.shared.setData(data: "\(location.longitude)", forKey: .userLong)
        }else
        {
            defult.shared.setData(data: true, forKey: .fromLogin)
            defult.shared.setData(data: "\(location.latitude)", forKey: .userLat)
            defult.shared.setData(data: "\(location.longitude)", forKey: .userLong)
        }
        
        getAddressFromLatLon(
            withLatitude: defult.shared.getData(forKey: .userLat) ?? "",
            withLongitude: defult.shared.getData(forKey: .userLong) ?? "") { [weak self] address, _ in
            self?.locationLbl.text = address == "" ? "Choose your location".localized : address
        }
        
        locationManager.stopUpdatingLocation()
    }
}

