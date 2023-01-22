//
//  ProviderOrderDetailsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 14/11/2022.
//

import BottomPopup
import CoreLocation
import UIKit

class ProviderOrderDetailsVC: BaseViewController {
    @IBOutlet weak var cancelReasonView         : CancelReasonView!
    @IBOutlet weak var OrderStatusView          : StepperView!
    @IBOutlet weak var orderDataView            : OrderDataView!
    @IBOutlet weak var orderNoteView            : OrderNotesView!
    @IBOutlet weak var orderDetailsView         : OrderProductDetailsView!
    @IBOutlet weak var userDataView             : UserContactView!
    @IBOutlet weak var orderOfferView           : OrderOfferesView!
    @IBOutlet weak var storeDetailsView         : OrderStoreDetailsView!

    @IBOutlet weak var paymentSuccessView   : UIView!
    @IBOutlet weak var invoiceDetailsView   : UIView!

    @IBOutlet weak var deliveryTitle    : UILabel!
    @IBOutlet weak var deliverToBtn     : MainButton!
    // MARK: - ActionsView

    @IBOutlet weak var acceptOrderOrderView     : UIView!
    @IBOutlet weak var orderProcessedView       : UIView!
    @IBOutlet weak var deleverToDelegateView    : UIView!

    // MARK: - outlets

    @IBOutlet weak var mainStackView            : UIStackView!
    @IBOutlet weak var invoiceCollectionView    : UICollectionView!
    
    @IBOutlet weak var complainteBtn            : UIButton!
    @IBOutlet weak var deliveryLocationBtn      : UIButton!

    // step progress colors
    let refreshControl = UIRefreshControl()

    var orderID = Int()
    var isFromOrder = false
    var orderData: UserOrderDetailsModel?
    var productsArray = [Products]()
    var invoiveIMages = [Image]()
    var storeData: Store?
    var orderType: OrderType?
    var currentStateIndex = 0
    var isFromFCM = false

    var stepsSpecialStores: [String] = [
        "Awaiting approval".localized,
        "In progress".localized,
        "Delivered to delivery".localized,
    ]

    var stepsSpecialStoresNoDelivery: [String] = [
        "Awaiting approval".localized,
        "In progress".localized,
        "Delivered".localized,
    ]

    var stepsParcelDelivery: [String] = [
        "Awaiting approval".localized,
        "Receiving".localized,
        "Delivery".localized,
        "Delivered".localized,
    ]

    var stepsSpecialDelivery: [String] = [
        "Receive offers".localized,
        "Issuing invoice".localized,
        "In transit".localized,
        "Delivered".localized,
    ]

    var stepsGoogleStore: [String] = [
        "Awaiting approval".localized,
        "Arrive store".localized,
        "Issuing invoice".localized,
        "Delivered".localized,
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getOrderDetails(orderID: orderID)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotification), name: .reloadProviderOrderDetails, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadProviderOrderDetails, object: nil)
    }

    func setupView() {
        registerCollectionViewCell()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        mainStackView.addSubview(refreshControl)

        hideViews()
        setupStepView()
        setupOrderDataActiosn()
        setupDelegateViewActiosn()
        
        deliveryTitle.addTapGesture { [weak self] in
            guard let self = self else {return}
            self.tabDileverTo()
        }
    }
    
    @objc func tabDileverTo(){
        orderIsDeliver(orderID: orderID)
    }

    private func setupStepView() {
        OrderStatusView.setStepperLinesColor(activeColor: .appColor(.stepLineColor)!,
                                             notActiceColor: .lightGray)
        OrderStatusView.setStepperLabelsColor(activeColor: .appColor(.MainFontColor)!,
                                              notActiceColor: .appColor(.SecondFontColor)!)
        OrderStatusView.setStepperViewImages(nextStateImage: UIImage(named: "next-state-icon"),
                                             currentStateImage: UIImage(named: "current-state-icon"),
                                             finishedStateImage: UIImage(named: "finish-state-icon"))
        OrderStatusView.setStepperTitlesForItems(titles: stepsSpecialStores)
        OrderStatusView.setStepperCurrentIndex(toIndex: 0)
    }

    @objc func refresh(_ sender: AnyObject) {
        invoiveIMages.removeAll()
        currentStateIndex = 0
        hideViews()
        getOrderDetails(orderID: orderID)
        refreshControl.endRefreshing()
    }

    @objc func refreshNotification(notification: NSNotification) {
        guard let dict = notification.userInfo else { return }
        guard let orderId = Int(dict["id"] as! String) else { return }

        if orderId == orderID {
            invoiveIMages.removeAll()
            currentStateIndex = 0
            hideViews()
            getOrderDetails(orderID: orderId)
        }
    }

    func hideViews() {
        
        orderOfferView          .isHidden = false
        
        complainteBtn           .isHidden = true
        cancelReasonView        .isHidden = true
        OrderStatusView         .isHidden = true
        paymentSuccessView      .isHidden = true
        orderDataView           .isHidden = true
        orderDetailsView        .isHidden = true
        storeDetailsView        .isHidden = true
        invoiceDetailsView      .isHidden = true
        acceptOrderOrderView    .isHidden = true
        deleverToDelegateView   .isHidden = true
        userDataView            .isHidden = true
        orderProcessedView      .isHidden = true
        complainteBtn           .isHidden = true
        deliveryLocationBtn     .isHidden = true
    }

    func registerCollectionViewCell() {
//        invoiceCollectionView.delegate = self
//        invoiceCollectionView.dataSource = self
//        invoiceCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
    }

    func handelOrder(type: OrderType, status: OrderStatus) {
        orderType = type
        switch type {
        case .specialStoreWithDelivery:
            if orderData?.order.needsDelivery == true {
                OrderStatusView.setStepperTitlesForItems(titles: stepsSpecialStores)
            } else {
                OrderStatusView.setStepperTitlesForItems(titles: stepsSpecialStoresNoDelivery)
            }
            OrderSpecialStore(with: status)
        case .googleStore:
//            OrderStatusView.setStepperTitlesForItems(titles: stepsGoogleStore)
//            OrderGoogleStore(with: status)
            navigationController?.popViewController(animated: true)
        case .parcelDelivery:
//            OrderStatusView.setStepperTitlesForItems(titles: stepsParcelDelivery)
//            OrderParcelParcelDeliveryDelivery(with: status)
            navigationController?.popViewController(animated: true)
        case .specialPackage:
//            OrderStatusView.setStepperTitlesForItems(titles: stepsSpecialStores)
//            OrderParcelSpecialPackageDelivery(with: status)
            navigationController?.popViewController(animated: true)
        case .defult:
            navigationController?.popViewController(animated: true)
        }

        mainStackView.reloadData(animationDirection: .down)
    }

    // MARK: - HandleView

    func isSpecialRequestWithInvoce() {
        if orderData?.order.haveInvoice == false {
            OrderStatusView.setStepperCurrentIndex(toIndex: 1)
        } else {
            OrderStatusView.setStepperCurrentIndex(toIndex: 2)
        }
    }

    func setupOrderData() {
        isOrderWithDelegate()
        cancelReasonView.configView(reason: orderData?.order.closeReason)
        orderDataView.configView(orderData: orderData?.order)
        orderNoteView.configView(notes: orderData?.order.orderDescription, noteIamges: orderData?.order.images)
        orderDetailsView.configView(products: orderData?.order.products)
        userDataView.configView(userAvatar: orderData?.order.userAvatar, userName: orderData?.order.userName, orderState: orderData?.order.orderStatus)
        orderOfferView.configView(deliveryOffers: orderData?.order.deliveryOffers)
        storeDetailsView.configView(store: orderData?.order.store)
    }

    func isHaveInvoce() {
        if orderData?.order.haveInvoice == true {
            invoiveIMages.append(Image(id: 0, url: orderData?.order.invoiceImage ?? ""))
            invoiceDetailsView.isHidden = false
            invoiceCollectionView.reloadData()
        } else {
            invoiceDetailsView.isHidden = true
        }
    }
    
    func isOrderWithDelegate() {
        if orderData?.order.needsDelivery == true{
            deliveryTitle.text = "Delivered to delivery".localized
        }else{
            deliveryTitle.text = "Delivered to customer".localized
        }
    }

//    func handleDelegateDataView(with status: OrderStatus?) {
//        if orderData?.order.needsDelivery == true && orderData?.order.delegateID != nil && orderData?.order.delegateID != 0 {
//            if status == .finished {
//                navigateToRateStoreWithDelegatePopup()
//            }
//        } else {
//            if status == .finished {
//                navigateToRateStorePopup()
//            }
//        }
//    }

    // MARK: - Navigation

    func showFullScreen(url: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FullImageVC") as! FullImageVC
        vc.imageUrl = url
        present(vc, animated: true, completion: nil)
    }

    func navigateTCreateComplainte() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReportComplaintVC") as! ReportComplaintVC
        vc.orderID = orderID
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateTChangePaymentMethod() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePaymentMethodVC") as! ChangePaymentMethodVC
        vc.orderID = orderData?.order.id ?? 0
        vc.paymentKey = orderData?.order.paymentMethod?.key ?? ""
        vc.changePaymentSuccess = { [weak self] in
            guard let self = self else { return }
            self.hideViews()
            self.getOrderDetails(orderID: self.orderID)
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToRejectReasonePopup() {
        let vc = AppStoryboards.ProviderOrder.instantiate(ProviderRejectReasonVC.self)
        vc.orderID = orderID
        vc.cancelSuccess = { [weak self] in
            guard let self = self else { return }
            self.navigateToRejectSuccessfullyPopup()
        }
        present(vc, animated: true, completion: nil)
    }

//    func navigateToRateStorePopup() {
//        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RateStoreVC") as! RateStoreVC
//        vc.storeID = orderData?.order.store?.id ?? 0
//        vc.storename = orderData?.order.store?.name ?? ""
//        vc.orderID = orderData?.order.id ?? 0
//        vc.storeIconUrl = orderData?.order.store?.icon ?? ""
//        vc.rateStoreSucess = { [weak self] in
//            guard let self = self else { return }
//            self.navigateToRateSuccessfullyPopup()
//        }
//        present(vc, animated: true, completion: nil)
//    }
//
//    func navigateToRateStoreWithDelegatePopup() {
//        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RateStoreVC") as! RateStoreVC
//        vc.storeID = orderData?.order.store?.id ?? 0
//        vc.storename = orderData?.order.store?.name ?? ""
//        vc.orderID = orderData?.order.id ?? 0
//        vc.storeIconUrl = orderData?.order.store?.icon ?? ""
//        vc.rateStoreSucess = { [weak self] in
//            guard let self = self else { return }
//            self.navigateToRateDelegatePopup()
//        }
//        present(vc, animated: true, completion: nil)
//    }
//
//    func navigateToRateDelegatePopup() {
//        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RateDelegateVC") as! RateDelegateVC
//        vc.userID = orderData?.order.delegateID ?? 0
//        vc.delegateIconUrl = orderData?.order.delegateAvatar ?? ""
//        vc.storename = orderData?.order.delegateName ?? ""
//        vc.userType = .delegate
//        vc.orderID = orderData?.order.id ?? 0
//        vc.rateUserSucess = { [weak self] in
//            guard let self = self else { return }
//            self.navigateToRateSuccessfullyPopup()
//        }
//        present(vc, animated: true, completion: nil)
//    }

    func navigateToDeliverdSuccessfullyPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        vc.titleMessage = .orderDeliverdSuccessfully
        vc.automaticClose = false
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .reloadMyOrderTableView, object: nil)
//            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToTrackOrder(store: Store?, deliveryLat: String, deliveryLong: String) {
        let vc = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil).instantiateViewController(withIdentifier: "OrderTrackingVC") as! OrderTrackingVC
        vc.delegateID = orderData?.order.delegateID ?? 0
        vc.delegateLocation = CLLocationCoordinate2D(latitude: Double(orderData?.order.delegateLat ?? "") ?? 0.0, longitude: Double(orderData?.order.delegateLong ?? "") ?? 0.0)
        vc.storeLocation = CLLocationCoordinate2D(latitude: Double(orderData?.order.receiveLat ?? "") ?? 0.0, longitude: Double(orderData?.order.receiveLong ?? "") ?? 0.0)
        vc.clientLoation = CLLocationCoordinate2D(latitude: Double(orderData?.order.deliverLat ?? "") ?? 0.0, longitude: Double(orderData?.order.deliverLong ?? "") ?? 0.0)
        vc.orderType = orderData?.order.orderType
        vc.orderState = orderData?.order.orderStatus
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToRejectSuccessfullyPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        vc.titleMessage = .rejectOrderSuccess
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .reloadMyOrderTableView, object: nil)
//            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    // MARK: - Actions

    private func setupOrderDataActiosn() {
        orderDataView.recevingAddressViewTapped = { [weak self] in
            guard let self = self else { return }
            self.openMapToRecivingLocation()
        }

        orderDataView.deliveryAddressViewTapped = { [weak self] in
            guard let self = self else { return }
            self.openMapToDeliveryLocation()
        }
    }

    private func openMapToRecivingLocation() {
        UIDevice.vibrate()
        openMaps(latitude: Double(orderData?.order.receiveLat ?? "") ?? 0.0, longitude: Double(orderData?.order.receiveLong ?? "") ?? 0.0, title: orderData?.order.receiveAddress ?? "")
    }

    private func openMapToDeliveryLocation() {
        UIDevice.vibrate()
        openMaps(latitude: Double(orderData?.order.deliverLat ?? "") ?? 0.0, longitude: Double(orderData?.order.deliverLong ?? "") ?? 0.0, title: orderData?.order.deliverAddress ?? "")
    }

    private func setupDelegateViewActiosn() {
        userDataView.phoneTapped = { [weak self] in
            guard let self = self else { return }
            self.phoneCallAction()
        }

        userDataView.chatTapped = { [weak self] in
            guard let self = self else { return }
            self.openCahtAction()
        }
    }

//    private func setupOfferViewAction() {
//        orderOfferView.userAcceiptOfferTapped = { [weak self] offerID in
//            guard let self = self else { return }
//            self.providerAcceiptOrder(offerID: offerID)
//        }
//
//        orderOfferView.userRejectOfferTapped = { [weak self] id, index in
//            guard let self = self else { return }
    ////            self.providerRejectOrder(offerID: id, index: index)
//        }
//    }

    func phoneCallAction() {
        SocialMedia.shared.makeCallNumber(phoneNumber: orderData?.order.userPhone ?? "")
    }

    func openCahtAction() {
        if let roomId = orderData?.order.roomID,
           let reciverId = orderData?.order.delegateID,
           let senderId = orderData?.order.userId {
            let storyboard = UIStoryboard(name: StoryBoard.Chat.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.roomID = roomId
            vc.recieverId = reciverId
            vc.senderId = senderId
            vc.orderState = orderData?.order.orderStatus ?? .finished
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func backAction(_ sender: Any) {
        if isFromOrder == true {
//            tabBarController?.selectedIndex = 0
            navigationController?.popViewController(animated: true)
        } else {
            if isFromFCM {
                isFromFCM = false
                tabBarController?.selectedIndex = 0
                navigationController?.popViewController(animated: true)
                navigationController?.popViewController(animated: true)
            } else {
                if orderData?.order.orderStatus == .finished {
//                    tabBarController?.selectedIndex = 0
                    navigationController?.popViewController(animated: true)
                } else {
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @IBAction func trackOrderAction(_ sender: Any) {
        navigateToTrackOrder(store: orderData?.order.store, deliveryLat: orderData?.order.deliverLat ?? "", deliveryLong: orderData?.order.deliverLong ?? "")
    }

    @IBAction func complainteAction(_ sender: Any) {
        navigateTCreateComplainte()
    }

    @IBAction func rejectOrderAction(_ sender: Any) {
        navigateToRejectReasonePopup()
    }

    @IBAction func acceptOrderAction(_ sender: Any) {
        providerAcceiptOrder(orderID: orderID)
    }

    @IBAction func orderProcessed(_ sender: Any) {
        orderIsReady(orderID: orderID)
    }

    @IBAction func deliveredToDelegate(_ sender: Any) {
        
    }
}
