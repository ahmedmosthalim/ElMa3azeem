//
//  URLR.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation
import SwiftUI

struct URLs {
//    curl --location --request GET 'https://home-cooking.co/api/get-features'
    // Base URL
    static let BASE         = "https://mazeemapp.com"
    
    static let BASE_API     = BASE + "/api/"
    static let SocketPort   = "https://mazeemapp.com:4655"

    static let Google_GeoCoding = "https://maps.googleapis.com/maps/api/geocode/json?latlng="

    static let delegateJoinRequestUrl = BASE + "/delegate_join_request/login"
    static let providerJoinRequestUrl = BASE + "/stores_dashboard/register"
}

enum ServiceURL: String {
    // MARK: - Common

    // Auth
    case intro
    case countries
    case userLogin      = "mobile/login"
    case storeLogin     = "store/mobile/login"
    case delegateLogin  = "delegate/mobile/login"
    case activeCode     = "account/activation"
    case resendCode     = "code/resend"
    case completeData   = "info/complete"
    case socialLogin    = "social/login"

    // MARK: - Home

    case home
    case myOrder        = "user-orders"
    case notifyCount    = "unseen-notifications-count"
    case logOut         = "logout"
    case categories

    // MARK: - Address

    case addressBook    = "address-book"
    case addAddress     = "add-address"
    case deleteAddress  = "delete-address"
    case editAddress    = "edit-address"

    // MARK: - Stores

    case nearstores
    case storeDetails   = "single-store"
    case storeReviews   = "store-reviews"
    case storeBranches  = "store-branches"
    case storeProduct   = "single-product"
    case selectGroup    = "select-group"
    case offerStores
    case subCategory    = "subcategories"
    
    // MARK: - Order

    case createOrder        = "create-order"
    case orderEnquiry       = "order-enquiry"
    case paymentMethods     = "payment-methods"
    case userSingleOrder    = "user-single-order"
    case cancelReasones     = "cancel-reasons"
    case reviewStore        = "review-store"
    case reviewUser         = "review-user"
    case changePaymenMethod = "change-payment-method"
    case userAcceptDeliveryOffer = "user-accept-delivery-offer"
    case userRejectDeliveryOffer = "user-reject-delivery-offer"
    case cancelOrder        = "cancel-order"
    case payOrderWithWallet = "pay-order-with-wallet"
    case createTicket       = "create-ticket"
    case reportReasons      = "report-reasons"
    case favourite          = "favourite"
    case payWebView         = "pay-invoice"
    case payInvoiceIndex    = "pay-invoice-index"
    case payInvoiceResult   = "pay-invoice-result"
    case hyperpayBrands     = "hyperpay-brands"
    case payPackageIndex    = "pay-plan-index"
    case payPackageResult   = "pay-plan-result"
    
    // MARK: - Delegate

    case delegateNearWaitingOrders  = "delegate-near-waiting-orders"
    case delegateOrders             = "delegate-orders"
    case delegateSingleOrder        = "delegate-single-order"
    case delegateAcceptOrder        = "delegate-accept-order"
    case delegateIntransitOrder     = "delegate-intransit-order"
    case delegateFinishOrder        = "delegate-finish-order"
    case delegatemakeDeliveryOffer  = "make-delivery-offer"
    case delegateCreateOrderInvoice = "delegate-create-order-invoice"
    case withdrawReasons            = "withdraw-reasons"
    case delegateWithdrawOrder      = "delegate-withdraw-order"
    case cartypes                   = "cartypes"
    // MARK: - More

    case profileShow            = "profile/show"
    case profileUpdate          = "profile/update"
    case changePhone            = "profile/changed-phone-activation"
    case getTicket              = "get-tickets"
    case singleTicket           = "single-ticket"
    case wallet
    case cities
    case regions
    case userReviews            = "user-reviews"
    case policy
    case terms
    case contactUs              = "contact-us"
    case notification           = "notifications"
    case notificationControll   = "control-notification"
    case DeleteProfile          = "profile/delete-profile"
    case getFavourites          = "get-favourites"
    case nationalities          = "nationalities"
    case about

    // MARK: - webViews

    case registerAsDelegate = "delagate_join_request/login"

    // MARK: - Chat

    case room       = "single-room"
    case uploadFile = "upload-file"

    // MARK: - USER

    // MARK: - DELEGATE
    case delegateProfileUpdate = "profile/update-delegate"

    // MARK: - PROVIDER

    /// Auth

    /// Home
    case providerMyProduct      = "get-products"

    /// Packages
    case getPlans               = "get-plans"
    case getPlanPaymentMethods  = "get-plan-payment-methods"
    case subscribePlan          = "subscribe-plan"
    case payPlanWithWallet      = "pay-plan-with-wallet"
    case storeRejectOrder       = "store-reject-order"
    case removeSubscription     = "remove-subscription"
    
    /// Products
    case getSingleProduct           = "get-single-product"
    case controlProductState        = "control-product"
    case getStoreMenuCategories     = "get-store-menu-categories"
    case ProviderAddProduct         = "add-product"
    case providerDeleteProducr      = "delete-product"
    case getAppFeatures             = "get-features"
    case providerAddProductFeatures = "post-product-feature-properities"
    case providerAddProductGroup    = "post-groups"
    case providerUpdateProductGroup = "update-group"
    case providerUpdateProduct      = "update-product"

    /// Orders
    case storeOrders                = "store-orders"
    case storeSingleOrder           = "store-single-order"
    case storeAcceptOrder           = "store-accept-order"
    case storePrepareOrder          = "store-prepare-order"
    case storeDeliverOrder          = "store-deliver-order"

    /// More
    case profileStoreShow           = "profile/store-show"
    case profileUpdateStore         = "profile/update-store"
    case providerGetStoreFinance    = "get-store-finance"
    case providerGetStoreReviews    = "store-all-reviews"

    ////branches
    case providerGetBranches        = "get-branches"
    case providerSimgleBranch       = "get-edit-branch"
    case providerAddBranches        = "post-branch"
    case providerDeleteBranch       = "delete-branch"
    case providerUpdateBranch       = "update-branch"

    ////  menu
    case providerAddMenuSection         = "add-store-menu-category"
    case providerUpdateMenuSection      = "update-store-menu-category"
    case providerDeleteMenuSetion       = "delete-menu-category"

    ////Addiitives
    case providerAddAdditionSection     = "add-addtive-category"
    case providerUpdateAdditionSection  = "update-addtive-category"
    case providerDeleteAdditionSetion   = "delete-addtive-category"
    case providerGetAdditions           = "get-additives-categories"
    
    
    // MARK: - Payment -
    
    ///Charge
    case chargeWalletIndex  = "charge-wallet-index"
    case chargeWalletResult = "charge-wallet-result"
}
