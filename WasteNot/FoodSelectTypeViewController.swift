//
//  FoodSelectTypeViewController.swift
//  WasteNot
//
//  Created by David Allen on 4/20/24.
//

import UIKit

protocol getFoodTypeDelegateProtocol{
    func getFoodType(foodType: FoodType)
}
class FoodSelectTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTypeCell", for: indexPath) as! FoodTypeCell
        let food = filteredFoods[indexPath.row]
        cell.categoryLabel.text = food.category
        cell.foodLabel.text = food.name
        cell.foodEmojiLabel.text = food.emoji
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredFoods = searchText.isEmpty ? foodTypes : foodTypes.filter { (item: FoodType) -> Bool in
                return (item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || item.category.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
            }
            
            tableView.reloadData()
        }
    
    static var delegate: getFoodTypeDelegateProtocol?
    
    var filteredFoods: [FoodType]!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filteredFoods = foodTypes
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFood = filteredFoods[indexPath.row]
        FoodSelectTypeViewController.delegate?.getFoodType(foodType: selectedFood)
        
        self.navigationController?.popViewController(animated: true)
    }

}
