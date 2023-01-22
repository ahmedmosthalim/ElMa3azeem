//
//  ProviderProductDetailsModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//
import Foundation

// MARK: - ProviderProductModel

struct ProviderProductDetailsModel: Codable {
    let id: Int
    let image, nameAr, nameEn, descAr: String
    let descEn, name, desc, type: String
    let available: Bool
    let price, priceAfterDiscount: String?
    let inStockQty: Int
    let displayPrice, inStockSku: String
    let inStockType, discountFrom, discountTo: String
    let storeMenuCategoryID: Int
    let features: [Feature]?
    let group: [Group]?
    let productAdditiveCategories: [ProductAdditiveCategory]?

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

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        image = try values.decode(String.self, forKey: .image)
        nameAr = try values.decode(String.self, forKey: .nameAr)
        nameEn = try values.decode(String.self, forKey: .nameEn)
        descAr = try values.decode(String.self, forKey: .descAr)
        descEn = try values.decode(String.self, forKey: .descEn)
        name = try values.decode(String.self, forKey: .name)
        desc = try values.decode(String.self, forKey: .desc)
        type = try values.decode(String.self, forKey: .type)
        available = try values.decode(Bool.self, forKey: .available)
        inStockQty = try values.decode(Int.self, forKey: .inStockQty)
        displayPrice = try values.decode(String.self, forKey: .displayPrice)
        inStockSku = try values.decode(String.self, forKey: .inStockSku)
        inStockType = try values.decode(String.self, forKey: .inStockType)
        discountFrom = try values.decode(String.self, forKey: .discountFrom)
        discountTo = try values.decode(String.self, forKey: .discountTo)
        storeMenuCategoryID = try values.decode(Int.self, forKey: .storeMenuCategoryID)
        features = try values.decode([Feature].self, forKey: .features)
        group = try values.decode([Group].self, forKey: .group)
        productAdditiveCategories = try values.decode([ProductAdditiveCategory].self, forKey: .productAdditiveCategories)

        do {
            price = try values.decodeIfPresent(String.self, forKey: .price)
        } catch {
            price = String(try (values.decodeIfPresent(Double.self, forKey: .price) ?? 0))
        }
        
        do {
            priceAfterDiscount = try values.decodeIfPresent(String.self, forKey: .priceAfterDiscount)
        } catch {
            priceAfterDiscount = String(try (values.decodeIfPresent(Double.self, forKey: .priceAfterDiscount) ?? 0))
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, image
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descAr = "desc_ar"
        case descEn = "desc_en"
        case name, desc, type, available
        case displayPrice = "display_price"
        case price
        case inStockSku = "in_stock_sku"
        case inStockQty = "in_stock_qty"
        case inStockType = "in_stock_type"
        case priceAfterDiscount = "price_after_discount"
        case discountFrom = "discount_from"
        case discountTo = "discount_to"
        case storeMenuCategoryID = "store_menu_category_id"
        case features, group
        case productAdditiveCategories = "product_additive_categories"
    }
}

//
// let id: Int
// let name, image,  type, displayPrice: String?
// let available: Bool?
// let features: [Feature]?
// let group: [Group]?
// let productAdditiveCategories: [ProductAdditiveCategory]?
//
// var productType: ProductType? {
//    switch type {
//    case ProductType.simple.rawValue:
//        return .simple
//    case ProductType.multiple.rawValue:
//        return .multiple
//    default:
//        return .unknown
//    }
// }
//
// enum CodingKeys: String, CodingKey {
//    case id, name, desc, type, available
//    case displayPrice = "display_price"
//    case features, group, image
//    case productAdditiveCategories = "product_additive_categories"
// }
