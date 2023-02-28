//
//  FoodList.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 22.02.2023.
//

import Foundation

/// MARK: - FoodList
struct FoodList: Codable {
    let foods: [Foods]
    let success: Int

    enum CodingKeys: String, CodingKey {
        case foods = "yemekler"
        case success
    }
}

// MARK: - Foods
struct Foods: Codable {
    let foodID, foodName, foodImageName, foodPrice: String

    enum CodingKeys: String, CodingKey {
        case foodID = "yemek_id"
        case foodName = "yemek_adi"
        case foodImageName = "yemek_resim_adi"
        case foodPrice = "yemek_fiyat"
    }
}
