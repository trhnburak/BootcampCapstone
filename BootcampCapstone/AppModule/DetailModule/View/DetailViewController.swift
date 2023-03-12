//
//  DetailViewController.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 24.02.2023.
//

import UIKit
import Kingfisher
import Lottie

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!

    @IBOutlet weak var detailFoodNameLabel: UILabel!

    @IBOutlet weak var detailFoodPriceLabel: UILabel!

    @IBOutlet weak var detailStepper: UIStepper!

    @IBOutlet weak var detailQuantityLabel: UILabel!

    @IBOutlet weak var detailAddToCartButton: UIButton!

    @IBOutlet weak var detailCloseButton: UIButton!
    @IBOutlet weak var goToCartButton: UIButton!
    @IBOutlet weak var imageBackView: UIView!
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

        // detailCloseButton
        detailCloseButton.layer.cornerRadius = min(detailCloseButton.bounds.width, detailCloseButton.bounds.height) / 2
        detailCloseButton.layer.masksToBounds = true

        // goToCartButton
        goToCartButton.layer.cornerRadius = min(goToCartButton.bounds.width, goToCartButton.bounds.height) / 2
        goToCartButton.layer.masksToBounds = true

        // detailAddToCartButton
        detailAddToCartButton.layer.borderWidth = 2.0
        detailAddToCartButton.layer.borderColor = UIColor(named: "red-1")?.cgColor
        detailAddToCartButton.layer.cornerRadius = 0
        detailAddToCartButton.layer.masksToBounds = true

        // detailStepper
        detailStepper.layer.cornerRadius = 8
        detailStepper.layer.borderWidth = 1
        detailStepper.layer.borderColor = UIColor.clear.cgColor
        detailStepper.backgroundColor = UIColor.clear
        detailStepper.tintColor = UIColor(named: "black-1")

        let shadowLayer2 = CALayer()
        shadowLayer2.frame = detailStepper.frame
        shadowLayer2.cornerRadius = detailStepper.layer.cornerRadius
        shadowLayer2.backgroundColor = UIColor.white.cgColor
        shadowLayer2.shadowColor = UIColor.black.cgColor
        shadowLayer2.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer2.shadowOpacity = 0.5
        shadowLayer2.shadowRadius = 3

        detailStepper.superview?.layer.insertSublayer(shadowLayer2, below: detailStepper.layer)

        // detailQuantityBackView
        detailQuantityBackView.layer.cornerRadius = min(detailQuantityBackView.bounds.width, detailQuantityBackView.bounds.height) / 2
        detailQuantityBackView.layer.masksToBounds = true

        let shadowLayer3 = CALayer()
        shadowLayer3.frame = detailQuantityBackView.frame
        shadowLayer3.cornerRadius = detailQuantityBackView.layer.cornerRadius
        shadowLayer3.backgroundColor = UIColor.white.cgColor
        shadowLayer3.shadowColor = UIColor.black.cgColor
        shadowLayer3.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer3.shadowOpacity = 0.5
        shadowLayer3.shadowRadius = 3

        detailQuantityBackView.superview?.layer.insertSublayer(shadowLayer3, below: detailQuantityBackView.layer)

        // imageBackView
        imageBackView.layer.cornerRadius = 70
        imageBackView.layer.maskedCorners = [.layerMinXMaxYCorner]

        let shadowLayer = CALayer()
        shadowLayer.frame = imageBackView.frame
        shadowLayer.cornerRadius = imageBackView.layer.cornerRadius
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 50, height: 0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 5
        shadowLayer.shadowPath = UIBezierPath(roundedRect: shadowLayer.bounds.insetBy(dx: -50, dy: 0), cornerRadius: imageBackView.layer.cornerRadius).cgPath

        imageBackView.superview?.layer.insertSublayer(shadowLayer, below: imageBackView.layer)

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


        let alertController = UIAlertController(title: "Ürün Sepetinize Eklendi!", message: "", preferredStyle: .alert)

        // Accessing alert view backgroundColor :
        alertController.view.backgroundColor = UIColor.white
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white

        // Accessing buttons tintcolor :
        alertController.view.tintColor = UIColor(named: "red-1")

        alertController.view.layer.cornerRadius = 10

        // Increase the alert height
        let heightConstraint = NSLayoutConstraint(item: alertController.view!,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 300)

        alertController.view.addConstraint(heightConstraint)

        // width constraint
        let widthtConstraint = NSLayoutConstraint(
            item: alertController.view!,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute:
                NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: self.view.frame.width * 0.9)
        alertController.view.addConstraint(widthtConstraint)


        // Create the Lottie animation view
        let animationView = LottieAnimationView(name: "121871-add-to-cart-red-version")
        animationView.loopMode = .loop
        animationView.play()

        // Add the animation view as a subview of the alert controller's view
        alertController.view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: alertController.view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8),
            animationView.heightAnchor.constraint(equalToConstant: 150),
            
        ])

        // Set the title font and color
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor(named: "black-1")]

        let titleAttrString = NSMutableAttributedString(string: "Ürün Sepetinize Eklendi!", attributes: titleFont as [NSAttributedString.Key : Any])
        alertController.setValue(titleAttrString, forKey: "attributedTitle")

        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            // handle OK button tapped
            self.performSegue(withIdentifier: "fromDetailToCartVC", sender: self)
        }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)


        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //    self.performSegue(withIdentifier: "fromDetailToCartVC", sender: self)
        //}

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
