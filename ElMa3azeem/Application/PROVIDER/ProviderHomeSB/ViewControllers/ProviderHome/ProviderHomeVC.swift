//
//  ProviderHomeVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

class ProviderHomeVC: BaseViewController {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var incomingOrderesView: HomeProviderItem!
    @IBOutlet weak var currentOrdersView: HomeProviderItem!
    @IBOutlet weak var completedOrdersView: HomeProviderItem!
    @IBOutlet weak var addedProductsView: HomeProviderItem!

    private var homeData: Statistics? {
        didSet {
            incomingOrderesView.updateNumber(number: homeData?.newOrders)
            currentOrdersView.updateNumber(number: homeData?.activeOrders)
            completedOrdersView.updateNumber(number: homeData?.finishOrders)
            addedProductsView.updateNumber(number: homeData?.products)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.showTabbar()
        getHomeData(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "")
        removeStatusBarColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    // MARK: - CONFIGRATION

    private func configUI() {
        incomingOrderesView.configView(number: 0, title: "Incoming orderes".localized, image: "new-order")
        currentOrdersView.configView(number: 0, title: "Current orders".localized, image: "current-order")
        completedOrdersView.configView(number: 0, title: "Completed orders".localized, image: "complete-order")
        addedProductsView.configView(number: 0, title: "Added products".localized, image: "myproducts")
    }

   

    // MARK: - LOGIC

    // MARK: - NAVIGATION

    private func showWorkWithUsPopup() {
        let vc = UIStoryboard(name: StoryBoard.ProviderHome.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProviderPackageVC") as! ProviderPackageVC
        vc.modalPresentationStyle = .fullScreen
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    // MARK: - Actions

    @IBAction func notificationAction(_ sender: Any) {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProviderHomeVC {
    func getHomeData(lat : String ,long : String) {
        showLoader()
        ProviderHomeNetworkRouter.home(lat: lat, long: long).send(GeneralModel<ProviderHomeModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getHomeData(lat:lat , long: long)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.homeData = response.data?.statistics
                    self.mainStackView.reloadData(animationDirection: .down)
                    if response.data?.isSubscribe == false {
                        self.showWorkWithUsPopup()
                    }

                    if defult.shared.getData(forKey: .token) == "" || defult.shared.getData(forKey: .token) == nil {
                    } else {
//                        self.unSeenNotificationCountApi()
                    }
                } else {
                    
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

