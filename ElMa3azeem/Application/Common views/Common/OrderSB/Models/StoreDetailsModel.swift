//
//  StoreDetailsModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1311/2022.
//

import Foundation

// MARK: - DataClass

struct StoreDetailsModel: Codable, CodableInit {
    var store: StoreDetailsData
}

// MARK: - Store

struct StoreDetailsData: Codable {
    var id: Int
    var categoryName: String?
    var deliveryPrice: String?
    var name: String?
    var nameAr, nameEn: String?
    var icon, cover: String?
    var lat, long, address: String?
    var numRating: Int
    var rate, category, offerImage: String
    var offerAmount, offerType, offerMax: String
    var available, hasContract, isOpen: Bool
    var distance            : String
    var offer               : Bool
    var openingHours        : [OpeningHour]
    var memu                : [Memu]?
    var ibanNumber, bankNumber: String?
    var commercialImage     : String?
    var bankName            : String?
    var commercialId        : String?
    var branchPhone         : String?
    var branchEmail         : String?
    var viewPackages        : Bool?
    var countryCode         : String?
    var isSubscribe         : Bool = false
    var hasDelivery         : Bool?
    var categoryID          : Int?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryName   = "category_name"
        case isOpen         = "is_open"
        case deliveryPrice  = "delivery_price"
        case name, icon, cover, lat, long, address
        case numRating      = "num_rating"
        case rate, category, offer
        case offerImage     = "offer_image"
        case offerAmount    = "offer_amount"
        case offerType      = "offer_type"
        case offerMax       = "offer_max"
        case available
        case hasContract    = "has_contract"
        case distance
        case openingHours = "opening_hours"
        case memu
        case ibanNumber = "iban_number"
        case bankNumber = "bank_number"
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case commercialImage = "commercial_image"
        case bankName = "bank_name"
        case commercialId = "commercial_id"
        case branchPhone = "branch_phone"
        case branchEmail = "branch_email"
        case countryCode = "branch_country_key"
        case viewPackages = "view_in_ui_only"
        case hasDelivery = "have_delivery"
        case categoryID = "category_id"
    }
}

// MARK: - Memu

struct Memu: Codable {
    var id: Int
    var name: String
    var products: [Product]
}

// MARK: - DataClass

struct ProductModel: Codable {
    let product: Product
}

struct Product: Codable {
    var id: Int?
    var image: String?
    var storeId: Int?
    var name, displayPrice: String?
    var type: String?
    var isFavourite: Bool?
    var features: [Feature]?
    var group: Group?
    var productAdditiveCategories: [ProductAdditiveCategory]?
    var quantity: Int? = 0
    var desc: String?
    var productType: ProductType? {
        switch type {
        case ProductType.simple.rawValue:
            return .simple
        case ProductType.multiple.rawValue:
            return .multiple
        default:
            return .unknown
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, image, name, type
        case displayPrice = "display_price"
        case features, group
        case desc
        case isFavourite = "is_favourite"
        case storeId = "store_id"
        case productAdditiveCategories = "product_additive_categories"
    }
}

// MARK: - Feature

struct Feature: Codable, Equatable {
    static func == (lhs: Feature, rhs: Feature) -> Bool {
        if lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.properities == rhs.properities {
            return true
        }
        return false
    }

    var id: Int?
    var name: String?
    var properities: [Properity]?
    var isSelected: Bool? = false
    var selectedProperity: Properity?
}

// MARK: - Properity

struct Properity: GeneralPickerModel, Codable, Equatable {
    let id: Int?
    let name: String?
    let featureID: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case featureID = "feature_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    var isSelected: Bool? = false

    var pickerId: Int {
        return id ?? 0
    }

    var pickerTitle: String {
        return name ?? ""
    }

    var pickerKey: String {
        return ""
    }
}

struct GroupProperity: GeneralPickerModel, Codable, Equatable {
    let id: Int?
    let name: Name?
    let featureID: Int?
    let createdAt, updatedAt: String?
    var normalProperity: Properity? {
        return Properity(id: id ?? 0, name: name?.name ?? "", featureID: featureID ?? 0, createdAt: createdAt ?? "", updatedAt: updatedAt ?? "")
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case featureID = "feature_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    var isSelected: Bool? = false

    var pickerId: Int {
        return id ?? 0
    }

    var pickerTitle: String {
        return name?.name ?? ""
    }

    var pickerKey: String {
        return ""
    }
}

// MARK: - Group

struct Group: Codable, FeatureItem {
    var id: Int
    var discountFrom, discountTo, displayPrice: String?
    var inStockQty: Int?
    var qty: Int?
    var inStockSku, inStockType, price, priceAfterDiscount: String?
    var propreties: [GroupProperity]?

    enum CodingKeys: String, CodingKey {
        case discountFrom = "discount_from"
        case discountTo = "discount_to"
        case displayPrice = "display_price"
        case id
        case inStockQty = "in_stock_qty"
        case inStockSku = "in_stock_sku"
        case inStockType = "in_stock_type"
        case price
        case qty
        case priceAfterDiscount = "price_after_discount"
        case propreties
    }

    var featureTitle: String {
        var title = ""
        for names in propreties ?? [] {
            title = title.isEmpty ? (names.name?.name ?? "") : title + " - " + (names.name?.name ?? "")
        }
        return title
    }

    var featureSubTitle: String {
        return "Quantity:".localized + "\(inStockQty ?? 0)"
    }

    var featurePrice: String {
        return displayPrice ?? ""
    }
}

// MARK: - Name

struct Name: Codable, Equatable {
    let ar, en: String
    var name: String {
        return Language.isArabic() ? ar : en
    }
}

// MARK: - ProductAdditiveCategory

struct ProductAdditiveCategory: Codable, Equatable {
    static func == (lhs: ProductAdditiveCategory, rhs: ProductAdditiveCategory) -> Bool {
        if lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.productAdditives == rhs.productAdditives {
            return true
        }
        return false
    }

    let id: Int
    let name: String
    let nameAr: String?
    let nameEn: String?
    var productAdditives: [ProductAdditive]

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case productAdditives = "product_additives"
    }
}

// MARK: - ProductAdditive

struct ProductAdditive: FeatureItem, Codable, Equatable {
    var featureTitle: String {
        return name ?? ""
    }

    var featureSubTitle: String {
        return ""
    }

    var featurePrice: String {
        return price ?? ""
    }

    let id: Int?
    let name, price: String?
    let nameAr: String?
    let nameEn: String?
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}

// MARK: - OpeningHour

struct OpeningHour: Codable {
    var id: Int?
    var key: String?
    var day, time: String?

    var from: String?
    var to: String?

    var fromTime: Date? {
        get {
            return from?.timeStringToDate
        }
        set {
            from = newValue?.timeToString()
        }
    }

    var toTime: Date? {
        get {
            return to?.timeStringToDate
        }
        set {
            to = newValue?.timeToString()
        }
    }

    var apiFrom: String {
        return fromTime?.apiTime() ?? ""
    }

    var apiTo: String {
        return toTime?.apiTime() ?? ""
    }

    init(id: Int, key: String, day: String, from: Date, to: Date) {
        self.id = id
        self.key = key
        self.day = day
        time = ""
        fromTime = from
        toTime = to
    }
}

// MARK: - DataClass

struct GroupModel: Codable {
    let group: Group?
}

// MARK: - SelectedProduct

struct SelectedProductModel: Codable, Equatable {
    static func == (lhs: SelectedProductModel, rhs: SelectedProductModel) -> Bool {
        if lhs.menuID == rhs.menuID &&
            lhs.productID == rhs.productID &&
            lhs.productName == rhs.productName &&
            lhs.productIamge == rhs.productIamge &&
            lhs.productPrice == rhs.productPrice &&
            lhs.groupID == rhs.groupID &&
            lhs.totalPrice == rhs.totalPrice &&
            lhs.feature == rhs.feature &&
            lhs.addition == rhs.addition {
            return true
        }
        return false
    }

    var menuID: Int
    var productID: Int
    var productName: String
    var productIamge: String
    var productPrice: Double
    var groupID: Int
    var quantity: Int
    var totalPrice: Double
    var feature: [Feature]
    var addition: [ProductAdditiveCategory]
}

struct weekDayes: Codable, GeneralPickerModel {
    let id: Int
    let dayAr: String
    let dayEn: String
    let slug: String
    var day: String {
        return Language.isArabic() == true ? dayAr : dayEn
    }

    var pickerId: Int {
        return id
    }

    var pickerTitle: String {
        return day
    }

    var pickerKey: String {
        return slug
    }
}

// MARK: - DataClass

struct FavoriteModel: Codable {
    let favorite: Bool
}
