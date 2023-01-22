//
//  ProviderStoreReviewsModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import Foundation

struct ProviderStoreReviewsModel: Codable {
    let rate, numRating: String
    let reviews: [Review]

    enum CodingKeys: String, CodingKey {
        case rate
        case numRating = "num_rating"
        case reviews
    }
}
