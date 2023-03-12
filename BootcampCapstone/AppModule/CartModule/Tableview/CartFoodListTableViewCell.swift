//
//  CartFoodListTableViewCell.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 26.02.2023.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func deleteButtonTapped(for cell: CartFoodListTableViewCell, at indexPath: IndexPath)
}


class CartFoodListTableViewCell: UITableViewCell {

    static let nibName = "CartFoodListTableViewCell"
    static let reuseName = "CartFoodListTableViewCell"

    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var cartFoodNameLabel: UILabel!
    @IBOutlet weak var cartQuantityLabel: UILabel!
    @IBOutlet weak var cartFoodPriceLabel: UILabel!
    @IBOutlet weak var cartStepper: UIStepper!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cartFoodCellBackView: UIView!
    @IBOutlet weak var cartQuantityBackView: UIView!
    
    @IBOutlet weak var deleteButtonBackView: UIView!
    weak var delegate: CartTableViewCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Set border properties
        cartFoodCellBackView.layer.borderWidth = 1.0
        cartFoodCellBackView.layer.borderColor = UIColor.clear.cgColor

        // Set corner radius
        cartFoodCellBackView.layer.cornerRadius = 10.0

        // Set shadow properties
        let shadowLayer = CALayer()
        shadowLayer.frame = cartFoodCellBackView.frame
        shadowLayer.cornerRadius = cartFoodCellBackView.layer.cornerRadius
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 5
        cartFoodCellBackView.superview?.layer.insertSublayer(shadowLayer, below: cartFoodCellBackView.layer)

        // Set background color to clear
        cartFoodCellBackView.backgroundColor = UIColor.clear

        cartImageView.layer.cornerRadius = 10.0

        //Cart Quantity Back View
        cartQuantityBackView.layer.cornerRadius = min(cartQuantityBackView.bounds.width, cartQuantityBackView.bounds.height) / 2
        cartQuantityBackView.layer.masksToBounds = true

        let shadowLayer3 = CALayer()
        shadowLayer3.frame = cartQuantityBackView.frame
        shadowLayer3.cornerRadius = cartQuantityBackView.layer.cornerRadius
        shadowLayer3.backgroundColor = UIColor.white.cgColor
        shadowLayer3.shadowColor = UIColor.black.cgColor
        shadowLayer3.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer3.shadowOpacity = 0.5
        shadowLayer3.shadowRadius = 5
        cartQuantityBackView.superview?.layer.insertSublayer(shadowLayer3, below: cartQuantityBackView.layer)

        //Delete Button Back View

        deleteButtonBackView.layer.cornerRadius = min(deleteButtonBackView.bounds.width, deleteButtonBackView.bounds.height) / 2
        deleteButtonBackView.layer.masksToBounds = true

        let shadowLayer2 = CALayer()
        shadowLayer2.frame = deleteButtonBackView.frame
        shadowLayer2.cornerRadius = deleteButtonBackView.layer.cornerRadius
        shadowLayer2.backgroundColor = UIColor.white.cgColor
        shadowLayer2.shadowColor = UIColor.black.cgColor
        shadowLayer2.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer2.shadowOpacity = 0.5
        shadowLayer2.shadowRadius = 5
        deleteButtonBackView.superview?.layer.insertSublayer(shadowLayer2, below: deleteButtonBackView.layer)

        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func deleteButtonTapped(_ sender: UIButton) {

        if let indexPath = getIndexPath() {
            delegate?.deleteButtonTapped(for: self, at: indexPath)
        }

    }

    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            return nil
        }
        let point = self.convert(self.bounds.origin, to: superView)
        guard let indexPath = superView.indexPathForRow(at: point) else {
            return nil
        }
        return indexPath
    }

}
