//
//  Enums.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation
import UIKit

enum StoryBoard: String {
    case Auth
    case Home
    case Order
    case Delegate
    case NormalOrder

    case DelegateHome
    case More
    case Chat

    case ProviderHome
    case ProviderOrder
    case ProviderProduct
    case ProviderPackage
    case ProviderMore
}

enum SuccessfullyViewPopupMessage: String {
    case successReview = "Congratulations! Your review has been submitted successfully."
    case cancelOrderSuccess = "Congratulations! Your order canceled successfully."
    case senfOfferSuccess = "Congratulations! Your offer has been submitted successfully"
    case withdrawSuccess = "Congratulations! Your are withdraw from order successfully"
    case CreateCopmlaintSuccess = "Your complaint has been sent successfully"
    case rejectOrderSuccess = "Reason for rejection has been sent successfully."
    case deleteProductSuccessfuly = "Congratulations! \n You deleted successfully!"
    case packageSubscribeSuccessfully = "Successfully subscribed to the package"
    case addMenuSuccessfully = "Congratulations! Your menu added successfully."
    case updateMenuSuccessfully = "Congratulations! Your menu updated successfully."
    case deleteMenuSuccessfully = "Congratulations!\n Your menu deleted successfully."
    case addAdditionSuccessfully = "Congratulations!\n Your addition added successfully."
    case updateAdditionSuccessfully = "Congratulations!\n Your addition updated successfully."
    case deleteAdditionSuccessfully = "Congratulations!\n Your addition deleted successfully."
    case addProductSuccessfullyWithFeautures = "Congratulations!\n Product added successfully ,\n please add product feautures."
    case addBranchSuccessfully = "Congratulations!\n Branch added successfully."
    case updateBranchSuccessfully = "Congratulations!\n Branch updated successfully."
    case addProductSuccessfully = "Congratulations!\n Product added successfully."
    case updateProductSuccessfullyWithFeautures = "Congratulations!\n Product updated successfully ,\n please update product feautures."
    case updateProductSuccessfully = "Congratulations!\n Product updated successfully."
    case addProductFeauturesSuccessfully = "Congratulations!\n Product feautures added successfully ,\n please add groups."
    case updateProductFeauturesSuccessfully = "Congratulations!\n Product feautures updated successfully ,\n please add groups."
    case addProductGroupesSuccessfully = "Congratulations!\n Product groups added successfully ,\n please add groups."
    case orderDeliverdSuccessfully = "Congratulations!\n Order delivered successfully."
    
}

enum SuccessfullyViewPopupSubMessage: String {
    case packageSubscribeSuccessfully = "You have subscribed to the monthly package, you can now add your products and receive orders"
}

enum SuccessfullyViewPopupButtom: String {
    case backToHome = "back to home"
    case back = "Back"
    case continu = "continue"
}

var topVC: UIViewController? {
    return UIApplication.shared.keyWindow?.visibleViewController
}

enum HomeData: String {
    case ads
    case stores
    case categories
}

enum ScreenReason {
    case addNew
    case edit
}

enum orderState: String {
    case open
    case inprogress
    case finished
}

enum ProviderOrderState: String {
    case pending
    case inprogress
    case delivered
}

enum appLanguage: String {
    case english = "en"
    case arabic = "ar"
}

enum AccountType: String {
    case user
    case delegate
    case provider = "store"
    case unknown
}

enum userGender: String {
    case man
    case women
}

enum ResponceStatus: String {
    case success
    case fail
    case tokenFail
    case needActive
}

enum UserState: String {
    case active
    case pending
    case block
}

enum ProductType: String, Codable {
    case simple
    case multiple
    case unknown
}

let weekDaysArray = [
    weekDayes(id: 0, dayAr: "السبت"     , dayEn: "Saturday" , slug: "saturday"),
    weekDayes(id: 1, dayAr: "الاحد"      , dayEn: "Sunday"   , slug: "sunday"),
    weekDayes(id: 2, dayAr: "الاثنين"    , dayEn: "Monday"   , slug: "monday"),
    weekDayes(id: 3, dayAr: "الثلاثاء"   , dayEn: "Tuesday"  , slug: "tuesday"),
    weekDayes(id: 4, dayAr: "الاربعاء"   , dayEn: "Wednesday", slug: "wednesday"),
    weekDayes(id: 5, dayAr: "الخميس"    , dayEn: "Thursday" , slug: "thursday"),
    weekDayes(id: 6, dayAr: "الجمعة"    , dayEn: "Friday"   , slug: "friday"),
]
