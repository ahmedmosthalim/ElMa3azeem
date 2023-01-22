//
//  OnBoardingModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation

struct OnBoardingModel: Codable {
    let intros: [Intro]
}

// MARK: - Intro
struct Intro: Codable {
    let id: Int
    let title, desc: String
    let image: String
}
