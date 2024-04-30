//
//  FoodListViewController.swift
//  WasteNot
//
//  Created by David Allen on 4/13/24.
//

import UIKit

class FoodListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableHeader: UIView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        let key = sectionHeaders[indexPath.section]
        let food = mappedFoods[key]?[indexPath.row]
        if let food = food {
            cell.configure(with: food)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if sectionHeaders.count < 1 { return 0 }

            let key = sectionHeaders[section]
            return mappedFoods[key]?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
            return sectionHeaders.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sectionHeaders[section]
    }
    
    @IBAction func didTapNewFood(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ComposeSegue", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchFilter = searchText
            refreshFoods()
        }
    
    @IBAction func didTapStorage(_ sender: UIButton) {
        let index = storageButtons.firstIndex(of: sender)!
        
        activeStorageTypes[index] = sender.isSelected
        
        sender.layer.backgroundColor = sender.isSelected
        ? UIColor.greenButtonColor.cgColor
        : UIColor.systemGray6.cgColor
        
        sender.configuration?.baseForegroundColor = sender.isSelected ? .white : .label
        
        refreshFoods()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               for button in storageButtons {
                   button.layer.backgroundColor = button.isSelected
                   ? UIColor.greenButtonColor.cgColor
                   : UIColor.systemGray6.cgColor
               }
           }
       }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var storageButtons: [UIButton]!
    
    var mappedFoods = [String: [Food]]()
    var sectionHeaders = [String]()
    var searchFilter = String()
    var storageTypes: [String] = ["pantry", "fridge", "freezer"]
    var activeStorageTypes: [Bool] = [false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = tableHeader
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        for button in storageButtons {
            button.layer.cornerRadius = 12
            button.layer.backgroundColor = UIColor.systemGray6.cgColor
            button.configuration?.baseForegroundColor = .label
            button.isSelected = false
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        refreshFoods()
    }

    private func refreshFoods() {
        var foods = Food.getFoods()
        
        var storages: [String] = [String]()
        for (index, active) in activeStorageTypes.enumerated() {
            if active { storages.append(storageTypes[index]) }
        }
        
        foods = storages.isEmpty ? foods : foods.filter { (food: Food) -> Bool in
            return storages.contains(food.expirationData!.storage)
        }
        
        foods = searchFilter.isEmpty ? foods : foods.filter { (food: Food) -> Bool in
            return (food.foodType.name.range(of: searchFilter, options: .caseInsensitive, range: nil, locale: nil) != nil || food.foodType.category.range(of: searchFilter, options: .caseInsensitive, range: nil, locale: nil) != nil)
        }
        
        foods.sort { lhs, rhs in
            if lhs.expirationDate == nil {
                return false
            }
            if rhs.expirationDate == nil {
                return true
            }
            return lhs.expirationDate! < rhs.expirationDate!
        }
        
        sectionHeaders = []
        
        let mappedFoods = foods.reduce(into: [String: [Food]]()) { 
            (mappedFoods, food) in
            let now = Date.now
        
            if food.expirationDate != nil && food.expirationDate! < now {
                if mappedFoods["Expired"] == nil {
                    mappedFoods["Expired"] = [food]
                    self.sectionHeaders += ["Expired"]
                } else {
                    mappedFoods["Expired"]! += [food]
                }
            }
            else if food.checkDate != nil && food.checkDate! < now {
                if mappedFoods["Expiring Soon"] == nil {
                    mappedFoods["Expiring Soon"] = [food]
                    self.sectionHeaders += ["Expiring Soon"]
                } else {
                    mappedFoods["Expiring Soon"]! += [food]
                }
            }
            else {
                if mappedFoods["Safe"] == nil {
                    mappedFoods["Safe"] = [food]
                    self.sectionHeaders += ["Safe"]
                } else {
                    mappedFoods["Safe"]! += [food]
                }
            }
        }
        
        self.sectionHeaders.move("Expiring Soon", to: 0)
        
        self.mappedFoods = mappedFoods
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = sectionHeaders[indexPath.section]
            mappedFoods[key]?.remove(at: indexPath.row)
            let foods = Array(mappedFoods.values.joined())
            Food.save(foods)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let key = sectionHeaders[indexPath.section]
        let food = mappedFoods[key]?[indexPath.row]
        if let selectedFood = food {
            performSegue(withIdentifier: "ComposeSegue", sender: selectedFood)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComposeSegue" {
            if let composeNavController = segue.destination as? UINavigationController,
               let composeViewController = composeNavController.topViewController as? FoodComposeViewController {
                composeViewController.foodToEdit = sender as? Food

                composeViewController.onComposeFood = { [weak self] food in
                    food.save()
                    self?.refreshFoods()
                }
            }
        }
    }
    

}
