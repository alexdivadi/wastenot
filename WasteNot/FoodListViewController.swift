//
//  FoodListViewController.swift
//  WasteNot
//
//  Created by David Allen on 4/13/24.
//

import UIKit

class FoodListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var mappedFoods = [String: [Food]]()
    var sectionHeaders = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = tableHeader
        tableView.dataSource = self
        tableView.delegate = self
        
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
        foods.sort { lhs, rhs in
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
        print(foods.count)
        print(mappedFoods.count)
        print(sectionHeaders.count)
        
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
