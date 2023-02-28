//
//  FoodCart.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 24.02.2023.
//

import Foundation

// MARK: - FoodCart
struct FoodCart: Codable {
    let cartFoodsList: [CartFoods]
    let success: Int

    enum CodingKeys: String, CodingKey {
        case cartFoodsList = "sepet_yemekler"
        case success
    }
}

// MARK: - SepetYemekler
struct CartFoods: Codable {
    let cartFoodID, foodName, foodImageName: String
    let foodPrice, username: String
    var foodQuantity:String

    enum CodingKeys: String, CodingKey {
        case cartFoodID = "sepet_yemek_id"
        case foodName = "yemek_adi"
        case foodImageName = "yemek_resim_adi"
        case foodPrice = "yemek_fiyat"
        case foodQuantity = "yemek_siparis_adet"
        case username = "kullanici_adi"
    }
}
