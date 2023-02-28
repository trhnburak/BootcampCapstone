//
//  CartViewController.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 26.02.2023.
//

import UIKit

import Kingfisher

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartCloseButton: UIButton!

    var cartPresenterObject:ViewToPresenterCartProtocol?
    var foodsCartArray = [CartFoods]()

    let parameters: [String: Any] = [
        "kullanici_adi": USERNAME_CONSTANT
    ]
    var parameters2: [String: Any] = [:]
    var selectedFoodName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CartRouter.createModule(ref: self)
       
        cartTableView.delegate = self
        cartTableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cartPresenterObject?.getFromFoodCart(parameters: parameters)
        cartTableView.reloadData()

    }

    @IBAction func cartCloseButtonTapped(_ sender: Any) {
        print("cartCloseButtonTapped")
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - Presenter To View
extension CartViewController : PresenterToViewCartProtocol {
    func sendDataToView(foodsCartArray: [CartFoods]) {
        self.foodsCartArray = foodsCartArray
        cartTableView.reloadData()
    }
}

// MARK: - Tableview Delegate, Tableview Datasource
extension CartViewController: UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate{


    func deleteButtonTapped(for cell: CartFoodListTableViewCell, at indexPath: IndexPath) {
        let foodToDelete = foodsCartArray[indexPath.row]

        parameters2 = [
            "sepet_yemek_id": foodToDelete.cartFoodID,
            "kullanici_adi": USERNAME_CONSTANT
        ]

        cartPresenterObject?.deleteFromFoodCart(parameters: parameters2) { success in
            if success {
                self.foodsCartArray.removeAll(where: { $0.cartFoodID == foodToDelete.cartFoodID })
                self.cartTableView.reloadData()
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodsCartArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cartFoodListCell") as! CartFoodListTableViewCell

        cell.delegate = self

        let food = foodsCartArray[indexPath.row]

        let url = URL(string: API_GET_FOOD_IMAGE + food.foodImageName)

        selectedFoodName = food.foodName
        


        cell.cartImageView.kf.setImage(with: url) { result in
            switch result {
                case .success(let imageResult):
                    cell.cartImageView.image = imageResult.image
                    cell.cartFoodNameLabel.text = food.foodName
                    cell.cartQuantityLabel.text = food.foodQuantity
                    cell.cartFoodPriceLabel.text = food.foodPrice + "₺"
                case .failure(let error):
                    print("Error loading image: \(error)")
            }
        }

        return cell

    }
}

