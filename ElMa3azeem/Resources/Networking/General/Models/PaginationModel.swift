//
//  PaginationModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 14/01/2022.
//

import Foundation

// MARK: - Pagination
struct Pagination: Codable {
    var total, count, perPage: Int
    var nextPageURL, pervPageURL: String
    var currentPage, totalPages: Int

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case nextPageURL = "next_page_url"
        case pervPageURL = "perv_page_url"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

