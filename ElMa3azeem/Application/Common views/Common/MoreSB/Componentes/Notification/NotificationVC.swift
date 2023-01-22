//
//  NotificationVC.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 111/22.
//

import UIKit

class NotificationVC: BaseViewController {
    // MARK: - IBOutLets

    @IBOutlet weak var notificationTableView: UITableView!

    @IBOutlet weak var emptyStack: UIStackView!
    @IBOutlet weak var emptyImage: UIImageView!

    private var notificationArray: [NotificationData] = []
    private var isActive = true
    private var CurrentPage = 1
    private var lastPage = 1

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setupStatusBar
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.showTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotificationCell()
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.getNotification(page: self.CurrentPage)
        }
    }

    func registerNotificationCell() {
        notificationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
        notificationTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    // MARK: - Actions
    
    
//    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    

    // MARK: - Navigations

    func navigateToDelegateOrderDetailsView(orderID: Int) {
        let vc = AppStoryboards.Delegate.instantiate(DelegateOrderDetailsVC.self)
        vc.orderID = orderID
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToUserOrderDetails(orderID: Int) {
        let vc = AppStoryboards.Order.instantiate(UserOrderDetailsVC.self)
        vc.orderID = orderID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToProviderOrderDetails(orderID: Int) {
        let vc = AppStoryboards.ProviderOrder.instantiate(ProviderOrderDetailsVC.self)
        vc.orderID = orderID
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToChat(roomeID: Int, reciverID: Int, senderID: Int) {
        let vc = AppStoryboards.Chat.instantiate(ChatVC.self)
        vc.roomID = roomeID
        vc.recieverId = reciverID
        vc.senderId = senderID
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToReview() {
        let vc = AppStoryboards.More.instantiate(UserCommentVC.self)
        vc.isFromMore = true
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - actions

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Extension

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.configCell(notify: notificationArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = notificationArray[indexPath.row].notificationType
        guard let accountType = defult.shared.user()?.user?.accountType else { return }

        switch type {
        case notificationType.withdrawOrder.rawValue,
             notificationType.delegateFinishedOrder.rawValue,
             notificationType.delegateMadeOffer.rawValue,
             notificationType.orderIntransit.rawValue,
             notificationType.delegateCreatedInvoice.rawValue,
             notificationType.storeAcceptOrder.rawValue,
             notificationType.delegateAcceptedOffer.rawValue,
             notificationType.userRejectedOffer.rawValue,
             notificationType.payWithWallet.rawValue,
             notificationType.userAcceptedOffer.rawValue,
             notificationType.orderIntransit.rawValue,
             notificationType.newOrde.rawValue,
             notificationType.orderIsPaid.rawValue,
             notificationType.changePaymentMethod.rawValue,
             notificationType.storeRefuseOrder.rawValue,
             notificationType.storeAcceptOrder.rawValue,
             notificationType.userCancelOrder.rawValue,
             notificationType.orderIsReady.rawValue:

            switch accountType {
            case .user:
                navigateToUserOrderDetails(orderID: notificationArray[indexPath.row].orderID ?? 0)
            case .delegate:
                navigateToDelegateOrderDetailsView(orderID: notificationArray[indexPath.row].orderID ?? 0)
            case .provider:
                navigateToProviderOrderDetails(orderID: notificationArray[indexPath.row].orderID ?? 0)
            case .unknown:
                print("case not found ❌")
            }

        case notificationType.newMessage.rawValue:
            break

        case notificationType.newReview.rawValue:
            navigateToReview()

        case notificationType.deleteNotify.rawValue,
             notificationType.deleteNotify.rawValue,
             notificationType.acceptJoinRequest.rawValue:

            let language = Language.currentLanguage()
            SocketConnection.sharedInstance.socket.disconnect()

            Language.setAppLanguage(lang: language)
            defult.shared.setData(data: false, forKey: .isFiristLuanch)

            let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
            let nav = CustomNavigationController(rootViewController: vc)
            MGHelper.changeWindowRoot(vc: nav)
            
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let ContentHeight = scrollView.contentSize.height

        if isActive {
            if position > ContentHeight - notificationTableView.frame.height {
                print("Done")
                isActive = false
                print(CurrentPage, lastPage)
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                    getNotification(page: CurrentPage)
                }
            }
        }
    }
}

extension NotificationVC {
    func getNotification(page: Int) {
        showLoader()
        MoreNetworkRouter.notification(page: page).send(GeneralModel<NotificationModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getNotification(page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.notifications.isEmpty == true {
                        self.notificationTableView.isHidden = true
                        self.emptyStack.isHidden = false
                        self.emptyImage.isHidden = false
                    } else {
                        self.emptyStack.isHidden = true
                        self.emptyImage.isHidden = true
                        self.notificationArray.append(contentsOf: data.data?.notifications ?? [])
                        self.notificationTableView.isHidden = false
                        self.lastPage = data.data?.pagination?.totalPages ?? 0
                        defult.shared.setData(data: 0, forKey: .unSeenNorificationCount)
                        if self.isActive == false {
                            self.notificationTableView.reloadData()
                        } else {
                            self.notificationTableView.reloadWithAnimation()
                        }
                        self.isActive = true
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
