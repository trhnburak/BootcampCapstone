//
//  DetailViewController.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 24.02.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!

    @IBOutlet weak var detailFoodNameLabel: UILabel!

    @IBOutlet weak var detailFoodPriceLabel: UILabel!

    @IBOutlet weak var detailStepper: UIStepper!

    @IBOutlet weak var detailQuantityLabel: UILabel!

    @IBOutlet weak var detailAddToCartButton: UIButton!

    @IBOutlet weak var detailCloseButton: UIButton!
    @IBOutlet weak var detailBackView: UIView!
    
    @IBOutlet weak var detailQuantityBackView: UIView!
    var detailPresenterObject:ViewToPresenterDetailProtocol?

    var food:Foods?
    var stepperValue:Int? = 1

    var foodsCartArray = [CartFoods]()


    override func viewDidLoad() {
        super.viewDidLoad()

        
        DetailRouter.createModule(ref: self)



        let url = URL(string: API_GET_FOOD_IMAGE + (food?.foodImageName ?? ""))


        detailImageView.kf.setImage(with: url) { result in
            switch result {
                case .success(let imageResult):
                    self.detailImageView.image = imageResult.image
                    self.detailFoodNameLabel.text = (self.food?.foodName ?? "")
                    self.detailFoodPriceLabel.text = (self.food?.foodPrice ?? "") + "₺"
                case .failure(let error):
                    print("Error loading image: \(error)")
            }
        }

        //Back View
        detailBackView.layer.borderWidth = 1.0
        detailBackView.layer.borderColor = UIColor.clear.cgColor

        // Set corner radius
        detailBackView.layer.cornerRadius = 10.0

        detailQuantityBackView.layer.cornerRadius = min(detailQuantityBackView.bounds.width, detailQuantityBackView.bounds.height) / 2
        detailQuantityBackView.layer.masksToBounds = true


        // Set shadow properties
        let shadowLayer = CALayer()
        shadowLayer.frame = detailBackView.frame
        shadowLayer.cornerRadius = detailBackView.layer.cornerRadius
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 5
        detailBackView.superview?.layer.insertSublayer(shadowLayer, below: detailBackView.layer)

        // Set background color to clear
        detailBackView.backgroundColor = UIColor.clear

        detailImageView.layer.cornerRadius = 10.0

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let parameters: [String: Any] = [
            "kullanici_adi": USERNAME_CONSTANT
        ]

        detailPresenterObject?.getFromFoodCart(parameters: parameters)
    }

    func saveToCart() {
        var parameters3: [String: Any] = [
            "yemek_adi": food?.foodName ?? "",
            "yemek_resim_adi": food?.foodImageName ?? "",
            "yemek_fiyat": food?.foodPrice ?? 0,
            "yemek_siparis_adet": stepperValue ?? 0,
            "kullanici_adi": USERNAME_CONSTANT
        ]

        let parameters: [String: Any] = [
            "kullanici_adi": USERNAME_CONSTANT
        ]

        if foodsCartArray.isEmpty{

            detailPresenterObject?.saveToFoodCart(parameters: parameters3)
            detailPresenterObject?.getFromFoodCart(parameters: parameters)
            return

        }else{
            var itemFound = false

            for cartFood in foodsCartArray {
                if cartFood.foodName == food?.foodName {
                    let parameters2: [String: Any] = ["sepet_yemek_id": cartFood.cartFoodID, "kullanici_adi": USERNAME_CONSTANT]

                    parameters3["yemek_siparis_adet"] =  String(describing: (stepperValue ?? 0) + (Int(cartFood.foodQuantity) ?? 0))

                    detailPresenterObject?.deleteFromFoodCart(parameters: parameters2) { success in
                        if success {
                            self.detailPresenterObject?.saveToFoodCart(parameters: parameters3)
                            self.detailPresenterObject?.getFromFoodCart(parameters: parameters)
                        }
                    }

                    itemFound = true
                    break
                }
            }

            if !itemFound {
                detailPresenterObject?.saveToFoodCart(parameters: parameters3)
                detailPresenterObject?.getFromFoodCart(parameters: parameters)
            }

        }

}



    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperValue = Int(sender.value)
        if let unwrappedValue = stepperValue {
            detailQuantityLabel.text = (String(describing: unwrappedValue))
        }

    }
    
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        // Disable the button
        detailAddToCartButton.isEnabled = false

        saveToCart()

        let parameters: [String: Any] = [
            "kullanici_adi": USERNAME_CONSTANT
        ]
        detailPresenterObject?.getFromFoodCart(parameters: parameters)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "fromDetailToCartVC", sender: self)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.detailAddToCartButton.isEnabled = true
        }
    }

    @IBAction func detailCloseButtonTapped(_ sender: UIButton) {
        print("detailCloseButtonTapped")
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - Presenter To View
extension DetailViewController : PresenterToViewDetailProtocol {
    func sendDataToView(foodsCartArray: [CartFoods]) {
        self.foodsCartArray = foodsCartArray
    }
}
