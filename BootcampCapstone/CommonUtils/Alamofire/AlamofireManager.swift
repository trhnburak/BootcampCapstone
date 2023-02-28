//
//  AlamofireManager.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 22.02.2023.
//

import Foundation
import Alamofire

struct Response: Decodable {
    let success: Int
}

class AlamofireManager {

    var foods = [Foods]()

    static let sharedManager = AlamofireManager()

    //Get All Foods
    static func getAll(completion: @escaping ([Foods]) -> Void) {
        AF.request(API_GET_ALL_FOODS, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FoodList.self) { response in
                switch response.result {
                    case .success(let foodList):
                        print("Fetch Successful")

                        completion(foodList.foods)

                    case .failure(let error):
                        debugPrint(error)
                }
            }
    }
    
    //Save to Food Cart
    static func saveToFoodCart(parameters: [String: Any]) {
        AF.request(API_SAVE_TO_CART, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response.self) { response in
                switch response.result {
                    case .success(let data):
                        print("Success: \(data)")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                }
            }
    }

    //Get All Foods For Food Cart
    static func getAllForFoodCart(parameters: [String: Any],
                                  completion: @escaping ([CartFoods]) -> Void) {
        AF.request(API_GET_FOOD_FROM_CART, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FoodCart.self) { response in
                switch response.result {
                    case .success(let foodCart):
                        print("Fetch From Food Cart Successful")
                        completion(foodCart.cartFoodsList)
                    case .failure(let error):
                        debugPrint(error)
                }
            }
    }

    //Delete From the Food Cart
    static func deleteFromTheFoodCart(parameters: [String: Any], completion: @escaping (Bool) -> Void) {
        AF.request(API_DELETE_FOOD_FROM_CART, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response.self) { response in
                switch response.result {
                    case .success(let data):
                        print("Success: \(data)")
                        completion(true)
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        completion(false)
                }
            }
    }


}


