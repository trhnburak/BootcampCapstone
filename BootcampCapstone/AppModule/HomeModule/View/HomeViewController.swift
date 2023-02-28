//
//  HomeViewController.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 21.02.2023.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {


    @IBOutlet weak var foodListTableView: UITableView!

    var foodsArray = [Foods]()

    var homePresenterObject:ViewToPresenterHomeProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()

        //searchBar.delegate = self

        foodListTableView.delegate = self
        foodListTableView.dataSource = self

        homePresenterObject?.getAll()
        HomeRouter.createModule(ref: self)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAll()
        foodListTableView.reloadData()

    }

    private func getAll(){
        homePresenterObject?.getAll()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let food = sender as? Foods {
                let toVC = segue.destination as! DetailViewController
                toVC.food = food
            
            }
        }
    }
}

// MARK: - Presenter To View
extension HomeViewController : PresenterToViewHomeProtocol {
    func sendDataToView(foodsArray: [Foods]) {
        self.foodsArray = foodsArray
        self.foodListTableView.reloadData()

    }
}

// MARK: - Tableview Delegate, Tableview Datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodsArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "foodListCell") as! FoodListTableViewCell

        let food = foodsArray[indexPath.row]
      
        let url = URL(string: API_GET_FOOD_IMAGE + food.foodImageName)


        cell.foodImageView.kf.setImage(with: url) { result in
            switch result {
                case .success(let imageResult):
                    cell.foodImageView.image = imageResult.image
                    cell.foodNameLabel.text = food.foodName
                    cell.foodPriceLabel.text = food.foodPrice + "₺"
                case .failure(let error):
                    print("Error loading image: \(error)")
            }
        }



        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = foodsArray[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: food)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

