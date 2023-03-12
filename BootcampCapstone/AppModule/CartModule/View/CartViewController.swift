//
//  CartViewController.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 26.02.2023.
//

import UIKit
import Kingfisher
import Lottie

class CartViewController: UIViewController{
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartCloseButton: UIButton!

    @IBOutlet weak var priceDetailBackView: UIView!
    @IBOutlet weak var priceDetailViewPriceLabel: UILabel!
    @IBOutlet weak var priceDetailViewDeliveryLabel: UILabel!
    @IBOutlet weak var priceDetailViewPriceTotalLabel: UILabel!
    @IBOutlet weak var pricePerItemLabel: UILabel!
    @IBOutlet weak var priceDetailViewTotalPrice2Label: UILabel!

    @IBOutlet weak var buyCompletedButton: UIButton!

    let footer = UIView()
    let animationView = LottieAnimationView(name: "94436-cooking-animation")
    let overlay = UIView()
    
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

        // Register the XIB file for the custom cell
        let nib = UINib(nibName: CartFoodListTableViewCell.nibName, bundle: nil)
        cartTableView.register(nib, forCellReuseIdentifier: CartFoodListTableViewCell.reuseName)

        // Set border properties
        priceDetailBackView.layer.borderWidth = 1.0
        priceDetailBackView.layer.borderColor = UIColor.clear.cgColor

        // Set corner radius
        priceDetailBackView.layer.cornerRadius = 10.0

        // Set shadow properties
        let shadowLayer = CALayer()
        shadowLayer.frame = priceDetailBackView.frame
        shadowLayer.cornerRadius = priceDetailBackView.layer.cornerRadius
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 5
        priceDetailBackView.superview?.layer.insertSublayer(shadowLayer, below: priceDetailBackView.layer)

        buyCompletedButton.layer.borderWidth = 2.0
        buyCompletedButton.layer.borderColor = UIColor(named: "red-1")?.cgColor
        buyCompletedButton.layer.cornerRadius = 0
        buyCompletedButton.layer.masksToBounds = true

        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissFooter))
        swipeDownGesture.direction = .down
        footer.addGestureRecognizer(swipeDownGesture)


    }

    @objc func dismissFooter() {
        UIView.animate(withDuration: 0.2, animations: {
            self.footer.alpha = 0
            self.animationView.alpha = 0
            self.overlay.alpha = 0
        }) { _ in
            self.footer.removeFromSuperview()

        }
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

    @IBAction func buyCompletedButtonTapped(_ sender: Any) {

        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isUserInteractionEnabled = true
        view.addSubview(overlay)

        footer.backgroundColor = UIColor.white
        footer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footer)

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        footer.addSubview(animationView)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Siparişiniz Hazırlanıyor!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(named: "black-1")
        footer.addSubview(label)

        footer.alpha = 0
        animationView.alpha = 0
        overlay.alpha = 0

        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: footer.topAnchor),

            footer.heightAnchor.constraint(equalToConstant: (self.view.frame.height / 2)),
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            animationView.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 300),

            label.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: animationView.topAnchor, constant: -20)
        ])

        UIView.animate(withDuration: 0.3) {
            self.footer.alpha = 1
            self.animationView.alpha = 1
            self.overlay.alpha = 1
        }


        animationView.play()

    }

    
}

// MARK: - Presenter To View
extension CartViewController : PresenterToViewCartProtocol {
    func sendDataToView(foodsCartArray: [CartFoods]) {
        self.foodsCartArray = foodsCartArray
        cartTableView.reloadData()

        var price:Int = 0
        let delivery:Int = 30

        print(foodsCartArray.count)
        for foodCart in foodsCartArray {
            print("Food Price:\(foodCart.foodPrice)")
            price = price + (Int(foodCart.foodPrice) ?? 0)
        }

        let totalPrice:Int = price + delivery

        priceDetailViewPriceLabel.text = String(describing: price) + "₺"
        priceDetailViewDeliveryLabel.text = String(describing: delivery) + "₺"
        priceDetailViewPriceTotalLabel.text = String(describing: totalPrice) + "₺"
        priceDetailViewTotalPrice2Label.text = String(describing: totalPrice) + "₺"
        pricePerItemLabel.text = "Fiyat( \(foodsCartArray.count) parça )"
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

        let cell = tableView.dequeueReusableCell(withIdentifier: CartFoodListTableViewCell.reuseName) as! CartFoodListTableViewCell

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
                    cell.cartFoodPriceLabel.text = String(describing: (Int(food.foodPrice) ?? 0) * (Int(food.foodQuantity) ?? 0)) + "₺"
                case .failure(let error):
                    print("Error loading image: \(error)")
            }
        }

        return cell

    }
}

