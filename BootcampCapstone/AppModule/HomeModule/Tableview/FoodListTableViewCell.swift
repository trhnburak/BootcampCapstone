//
//  FoodListTableViewCell.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 22.02.2023.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!

    @IBOutlet weak var foodPriceLabel: UILabel!

    @IBOutlet weak var foodCellBackView: UIView!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        // Set border properties
        foodCellBackView.layer.borderWidth = 1.0
        foodCellBackView.layer.borderColor = UIColor.clear.cgColor

        // Set corner radius
        foodCellBackView.layer.cornerRadius = 10.0

        // Set shadow properties
        let shadowLayer = CALayer()
        shadowLayer.frame = foodCellBackView.frame
        shadowLayer.cornerRadius = foodCellBackView.layer.cornerRadius
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 5
        foodCellBackView.superview?.layer.insertSublayer(shadowLayer, below: foodCellBackView.layer)

        // Set background color to clear
        foodCellBackView.backgroundColor = UIColor.clear

        foodImageView.layer.cornerRadius = 10.0



    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


