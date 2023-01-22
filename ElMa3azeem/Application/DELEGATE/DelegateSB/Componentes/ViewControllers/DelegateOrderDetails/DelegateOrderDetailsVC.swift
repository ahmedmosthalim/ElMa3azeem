//
//  DelegateOrderDetailsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import UIKit

class DelegateOrderDetailsVC: BaseViewController {
    // MARK: - ViewsOutlets
    
    @IBOutlet weak var withDrawView: UIView!
    @IBOutlet weak var canWithdrawView: UIView!
    
    // MARK: - OrderData Outlets
    @IBOutlet weak var OrderStatusView      : StepperView!
    @IBOutlet weak var storeDetailsView     : OrderStoreDetailsView!
    @IBOutlet weak var orderDetailsView     : OrderProductDetailsView!
    @IBOutlet weak var orderDataView        : OrderDataView!
    @IBOutlet weak var orderNoteView        : OrderNotesView!
    @IBOutlet weak var userDataView         : UserContactView!
    
    @IBOutlet weak var paymentSuccessView   : UIView!
    @IBOutlet weak var invoiceDetailsView   : UIView!
    
    // MARK: - ActionsView
    @IBOutlet weak var acceptOrderView              : UIView!
    @IBOutlet weak var readyToDeliverOrderView      : UIView!
    @IBOutlet weak var deliveryInTransit            : UIView!
    @IBOutlet weak var deliveredView                : UIView!
    @IBOutlet weak var reachStoreLocationView       : UIView!
    @IBOutlet weak var cerateInvoiceView            : UIView!
    @IBOutlet weak var reachReceivingLocationView   : UIView!
    @IBOutlet weak var reachDeliveryLocationView    : UIView!


    // MARK: - outlets
    @IBOutlet weak var mainStackView                : UIStackView!
    @IBOutlet weak var invoiceCollectionView        : UICollectionView!
    @IBOutlet weak var complainteBtn                : UIButton!

    // step progress colors
    let refreshControl  = UIRefreshControl()
    var backgroundColor = UIColor(hexString: "#FFB72B")
    var progressColor   = UIColor(hexString: "#FFB72B")
    var textColorHere   = UIColor.black
    var orderID         = Int()

    var orderData: DelegateOrderDetailsModel?
    var productsArray = [Products]()
    var invoiveIMages = [Image]()
    var storeData: Store?
    var orderType: OrderType?
    var currentStateIndex = 0
    var canWithDrawTimer = 0
    var isFromFCM = false

    var stepsSpecialStores: [String] = [
        "Awaiting approval".localized,
        "In transit".localized,
        "Delivered".localized,
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotification), name: .reloadDelegateOrderDetails, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadDelegateOrderDetails, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getOrderDetails(orderID: orderID)
    }

    func setupView() {
        registerCollectionViewCell()
        registerTableViewCells()

        setupStepView()
        setupOrderDataActiosn()
        setupDelegateViewActiosn()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        mainStackView.addSubview(refreshControl)
        
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

        if dict["id"] as! String == "cancel" {
            tabBarController?.selectedIndex = 0
            navigationController?.popToRootViewController(animated: true)
        }

        if orderId == orderID {
            invoiveIMages.removeAll()
            currentStateIndex = 0
            hideViews()
            getOrderDetails(orderID: orderId)
        }
    }

    func hideViews() {
        complainteBtn.isHidden = true
        canWithdrawView.isHidden = true
        OrderStatusView.isHidden = true
//        storeDetailsView.isHidden = true
        orderDetailsView.isHidden = true
        paymentSuccessView.isHidden = true
        orderDataView.isHidden = true
        invoiceDetailsView.isHidden = true
        
        //actions view
        acceptOrderView.isHidden = true
        readyToDeliverOrderView.isHidden = true
        deliveryInTransit.isHidden = true
        deliveredView.isHidden = true
        reachStoreLocationView.isHidden = true
        cerateInvoiceView.isHidden = true
        reachReceivingLocationView.isHidden = true
        reachDeliveryLocationView.isHidden = true
    }

    func registerTableViewCells() {
        
    }

    func registerCollectionViewCell() {
        invoiceCollectionView.delegate = self
        invoiceCollectionView.dataSource = self
        invoiceCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
    }

    func handelOrder(type: OrderType, status: OrderStatus) {
        orderType = type
        switch type {
            
        case .specialStoreWithDelivery:
            if self.orderData?.order.needsDelivery == true {
                OrderStatusView.setStepperTitlesForItems(titles: stepsSpecialStores)
            }else{
                OrderStatusView.setStepperTitlesForItems(titles: stepsSpecialStoresNoDelivery)
            }
            OrderSpecialStore(with: status)
        case .googleStore:
            OrderStatusView.setStepperTitlesForItems(titles: stepsGoogleStore)
            OrderGoogleStore(with: status)
        case .parcelDelivery:
            OrderStatusView.setStepperTitlesForItems(titles: stepsParcelDelivery)
            OrderParcelParcelDeliveryDelivery(with: status)
        case .specialPackage:
            OrderStatusView.setStepperTitlesForItems(titles: stepsSpecialStores)
            OrderParcelSpecialPackageDelivery(with: status)
        case .defult:
            navigationController?.popViewController(animated: true)
        }

        mainStackView.reloadData(animationDirection: .down)
    }

    // MARK: - HandleView

    private func setupStepView() {
        OrderStatusView.setStepperLinesColor(activeColor: .appColor(.stepLineColor)!,
                                             notActiceColor: .lightGray)
        OrderStatusView.setStepperLabelsColor(activeColor: .appColor(.MainFontColor)!,
                                              notActiceColor: .appColor(.SecondFontColor)!)
        OrderStatusView.setStepperViewImages(nextStateImage: UIImage(named: "next-state-icon"),
                                             currentStateImage: UIImage(named: "current-state-icon"),
                                             finishedStateImage: UIImage(named: "finish-state-icon"))
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

    func isSpecialRequestWithInvoce() {
        if orderData?.order.haveInvoice == false {
            cerateInvoiceView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 1)
        } else {
            deliveryInTransit.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 2)
        }
    }

    func setupOrderData() {
        orderDataView.configView(orderData: orderData?.order)
        orderNoteView.configView(notes: orderData?.order.orderDescription, noteIamges: orderData?.order.images)
        orderDetailsView.configView(products: orderData?.order.products)
        userDataView.configView(delegateAvatar: orderData?.order.delegateAvatar, delegateName: orderData?.order.delegateName , orderState: orderData?.order.orderStatus)
        userDataView.configView(userAvatar: orderData?.order.userAvatar, userName: orderData?.order.userName, orderState: orderData?.order.orderStatus)
        storeDetailsView.configView(store: orderData?.order.store)
    }

    func isPaymentSucceeded(paymentState: Bool, paymentMethod: String) {
        do {
            if orderData?.order.paymentMethod?.key ?? "" == "cash" {
                fiinishOrder(orderID: orderID)
            } else {
                _ = try ValidationService.validate(paymentState: paymentState)
                fiinishOrder(orderID: orderID)
            }
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    func setupPaymentView() {
        if orderData?.order.paymentStatus == true {
            paymentSuccessView.isHidden = false
        } else {
            paymentSuccessView.isHidden = true
        }
    }

    func delegateCanWithDraw() {
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: false)

        if orderData?.order.canWithdraw == true {
            canWithdrawView.isHidden = false
        } else {
            canWithdrawView.isHidden = true
        }
    }

    @objc func update() {
        if canWithDrawTimer > 0 {
            canWithDrawTimer = canWithDrawTimer - 1
        } else {
//            canWithdrawView.isHidden = true
        }
    }

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

    func navigateToCreateInvoce(orderID: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoard.Delegate.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CreateInvoiceVC") as! CreateInvoiceVC
        vc.orderID = orderID
        vc.orderData = OrderPriceModel(deliveryPrice: orderData?.order.deliveryPrice ?? "", appPercentage: orderData?.order.appPercentage ?? "", addedValue: orderData?.order.addedValue ?? "", discount: orderData?.order.discount ?? "", totalPrice: orderData?.order.totalPrice ?? "")
        vc.createInvoiceSuccess = { [weak self] in
            guard let self = self else { return }
            self.hideViews()
            self.getOrderDetails(orderID: self.orderID)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToRateDelegatePopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RateDelegateVC") as! RateDelegateVC
        vc.userID = orderData?.order.userId ?? 0
        vc.delegateIconUrl = orderData?.order.userAvatar ?? ""
        vc.storename = orderData?.order.userName ?? ""
        vc.userType = .user
        vc.orderID = orderData?.order.id ?? 0
        vc.rateUserSucess = { [weak self] in
            guard let self = self else { return }
            self.navigateToRateSuccessfullyPopup()
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToRateSuccessfullyPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        vc.titleMessage = .successReview
        vc.automaticClose = false
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .reloadMyDeliveryTableView, object: nil)
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToMakeOfferPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Delegate.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SendOfferVC") as! SendOfferVC
        vc.orderID = orderID
        vc.sendOfferSuccess = { [weak self] in
            guard let self = self else { return }
            self.navigateToSendOfferSuccessfullyPopup()
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToWithDrewReasonePopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Delegate.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WithdrawReasonesVC") as! WithdrawReasonesVC
        vc.orderID = orderID
        vc.withDrawSuccess = { [weak self] in
            guard let self = self else { return }
            self.navigateToWithDrawSuccessfullyPopup()
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToWithDrawSuccessfullyPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        vc.titleMessage = .withdrawSuccess
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .reloadMyDeliveryTableView, object: nil)
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToSendOfferSuccessfullyPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        vc.titleMessage = .senfOfferSuccess
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .reloadMyDeliveryTableView, object: nil)
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)
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

    func phoneCallAction() {
        SocialMedia.shared.makeCallNumber(phoneNumber: orderData?.order.userPhone ?? "")
    }

    func openCahtAction() {
        if let roomId = orderData?.order.roomID,
           let reciverId = orderData?.order.userId,
           let senderId = orderData?.order.delegateID {
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
        if isFromFCM {
            isFromFCM = false
            tabBarController?.selectedIndex = 0
            navigationController?.popToRootViewController(animated: true)
        } else {
            if orderData?.order.orderStatus == .finished {
                tabBarController?.selectedIndex = 0
                navigationController?.popToRootViewController(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func AcceptOrderAction(_ sender: Any) {
        acceptOrder(orderID: orderID)
    }
    
    @IBAction func rejectOrderAction(_ sender: UIButton) {
        
    }

    @IBAction func makeOfferAction(_ sender: Any) {
        navigateToMakeOfferPopup()
    }

    @IBAction func reatchStoreLocationAction(_ sender: Any) {
        updateOrderIntransitState(orderID: orderID, state: "reached_store")
    }

    @IBAction func deliveryIntransitAction(_ sender: Any) {
        updateOrderIntransitState(orderID: orderID, state: "delivering")
    }

    @IBAction func withdrawFromOrderAction(_ sender: Any) {
        navigateToWithDrewReasonePopup()
    }

    @IBAction func reatchReciveLocationAction(_ sender: Any) {
        updateOrderIntransitState(orderID: orderID, state: "reached_receive_location")
    }

    @IBAction func createInvoiceAction(_ sender: Any) {
        navigateToCreateInvoce(orderID: orderID)
    }

    @IBAction func reatchDeliveryLocationAction(_ sender: Any) {
        updateOrderIntransitState(orderID: orderID, state: "reached_deliver_location")
    }

    @IBAction func delegateFinishOrderAction(_ sender: Any) {
        isPaymentSucceeded(paymentState: orderData?.order.paymentStatus ?? false, paymentMethod: orderData?.order.paymentMethod?.key ?? "")
    }

    @IBAction func complainteAction(_ sender: Any) {
        navigateTCreateComplainte()
    }

    @objc func PhoneTaped(_ sender: UITapGestureRecognizer? = nil) {
        SocialMedia.shared.makeCallNumber(phoneNumber: orderData?.order.userPhone ?? "")
    }

    @objc func openCahtAction(_ sender: UITapGestureRecognizer) {
        if let roomId = orderData?.order.roomID,
           let reciverId = orderData?.order.userId,
           let senderId = orderData?.order.delegateID {
            let storyboard = UIStoryboard(name: StoryBoard.Chat.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.roomID = roomId
            vc.recieverId = reciverId
            vc.senderId = senderId
            vc.orderState = orderData?.order.orderStatus ?? .finished
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
