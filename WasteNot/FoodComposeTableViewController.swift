//
//  FoodComposeTableViewController.swift
//  WasteNot
//
//  Created by David Allen on 4/20/24.
//

import UIKit


class FoodComposeTableViewController: UITableViewController, getFoodTypeDelegateProtocol, getFoodDelegateProtocol {

    @IBOutlet weak var foodEmojiLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var packageDateOptionalLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerPackage: UIDatePicker!
    @IBOutlet weak var openedSwitch: UISwitch!
    @IBOutlet weak var storageButton: UIButton!
    

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var openSwitchTableCell: UITableViewCell!
    @IBOutlet weak var tipsView: UITextView!
    
    @IBAction func didTapOpened(_ sender: UISwitch) {
        self.fromDateType = openedSwitch.isOn ? "opening" : "purchase"
        self.dateLabel.text = openedSwitch.isOn ? "Date Opened" : "Date Bought"
        self.togglePackageDateOptional()
        self.updateStorage(storage: self.storage)
    }
    
    @IBAction func didTapDatePicker(_ sender: UIDatePicker) {
    }
    @IBAction func didTapDatePickerPackage(_ sender: UIDatePicker) {
    }
    
    var id: String?
    var foodType: FoodType?
    var storage: String = "Select"
    var fromDateType: String = "purchase"
    
    static var delegate: getFoodDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FoodSelectTypeViewController.delegate = self
        FoodComposeViewController.delegate = self
        
        self.storageButton.showsMenuAsPrimaryAction = true
        self.storageButton.menu = storageButtonMenu()
        
        tipsView.translatesAutoresizingMaskIntoConstraints = true
        tipsView.isScrollEnabled = false
        tipsView.isHidden = foodType?.tips == nil
        
        self.foodLabel.text = foodType?.name ?? "Select a food"
        self.foodEmojiLabel.text =  foodType?.emoji ?? "⚪️"
        self.storageButton.setTitle(self.storage, for: .normal)
        self.toggleOpenedSwitchVisible()
        self.togglePackageDateOptional()
        
    }
    
    func getFood(food: Food) {
        self.id = food.id
        self.updateFood(foodType: food.foodType)
        self.foodNameTextField.text = food.name
        self.fromDateType = food.expirationData?.fromDate ?? "purchase"
        
        self.datePicker.setDate(food.startDate ?? Date(), animated: true)
        self.datePickerPackage.setDate(food.packageDate ?? Date(), animated: true)
        self.toggleOpenedSwitchVisible()
        self.updateStorage(storage: food.expirationData?.storage ?? "Select")
        self.storageButton.menu = storageButtonMenu()
        self.togglePackageDateOptional()
    }
    
    func getFoodType(foodType: FoodType) {
        self.updateFood(foodType: foodType)
        self.foodNameTextField.text = foodType.name
        self.updateStorage(storage: self.storage)
        self.storageButton.menu = storageButtonMenu()
        self.toggleOpenedSwitchVisible()
        self.togglePackageDateOptional()
    }
    
    func updateFood(foodType: FoodType) {
        self.foodType = foodType
        self.foodLabel.text = foodType.name
        self.foodEmojiLabel.text = foodType.emoji
        
        if let tips = foodType.tips {
            self.tipsView.isHidden = false
            var text: String = ""
            if let pantry = tips.pantry { text += "\nPantry Tips:\n\(pantry)\n" }
            if let fridge = tips.fridge { text += "\nFridge Tips:\n\(fridge)\n" }
            if let freezer = tips.freezer { text += "\nFreezer Tips:\n\(freezer)\n" }
            self.tipsView.text = text
        }
        else {
            self.tipsView.isHidden = true
        }
    }
    
    func updateStorage(storage: String) {
        self.storage = storage
        self.storageButton.setTitle(storage.capitalized, for: .normal)
        self.togglePackageDateOptional()
    }
    
    func togglePackageDateOptional() {
        guard let expiration = foodType?.expiration else { return }
        
        if expiration.contains(where: { exp in
            exp.unit == "use-by" &&
            exp.storage == self.storage &&
            exp.fromDate == self.fromDateType
         }) {
            packageDateOptionalLabel.isHidden = true
        }
        else {
            packageDateOptionalLabel.isHidden = false
        }
    }
    
    func toggleOpenedSwitchVisible() {
        guard let expiration = foodType?.expiration else { return }
        
        if expiration.contains(where: { exp in
            exp.fromDate == "opening"
         }) {
            openSwitchTableCell.isHidden = false
            self.openedSwitch.setOn(self.fromDateType == "opening", animated: true)
            self.dateLabel.text = openedSwitch.isOn ? "Date Opened" : "Date Bought"
        }
        else {
            openSwitchTableCell.isHidden = true
            self.fromDateType = "purchase"
            self.dateLabel.text = "Date Bought"
        }
    }
    
    func getFoodCompose() -> Food? {
        guard let foodType = self.foodType else { return nil }
        guard storage != "Select" else { return nil }
        
        var composedFood: Food
        
        let foodName: String = (foodNameTextField.text == nil || foodNameTextField.text!.isEmpty) 
        ? foodType.name
        : foodNameTextField.text!
        
        if let id = self.id {
            composedFood = Food(
                foodType: foodType,
                name: foodName,
                id: id)
        }
        else {
            composedFood = Food(
                foodType: foodType,
                name: foodName,
                id: UUID().uuidString)
        }
        
        
        composedFood.startDate = datePicker.date
        composedFood.packageDate = datePickerPackage.date
        
        if let expiration = foodType.expiration.first(where: { exp in
            exp.storage == self.storage
            && exp.fromDate == self.fromDateType
            && exp.recommended
        }) {
            composedFood.expirationData = Expiration(
                storage: self.storage,
                recommended: true,
                unit: expiration.unit,
                duration: expiration.duration,
                fromDate: self.fromDateType
            )
        }
        else {
            switch storage {
                case "pantry":
                composedFood.expirationData = Expiration(
                    storage: self.storage,
                    recommended: false,
                    unit: "day",
                    duration: [Duration(length: 1)],
                    fromDate: self.fromDateType
                )
            case "fridge":
                composedFood.expirationData = Expiration(
                    storage: self.storage,
                    recommended: false,
                    unit: "day",
                    duration: [Duration(length: 3)],
                    fromDate: self.fromDateType
                )
            case "freezer":
                composedFood.expirationData = Expiration(
                    storage: self.storage,
                    recommended: false,
                    unit: "month",
                    duration: [Duration(length: 2)],
                    fromDate: self.fromDateType
                )
            default:
                    return nil
            }
        }
        
        return composedFood
        
    }
    
    func storageButtonMenu() -> UIMenu {
        var pantryActionTitle = "Pantry"
        var fridgeActionTitle = "Fridge"
        var freezerActionTitle = "Freezer"
        
        if let expiration = self.foodType?.expiration {
            for storageType in ["pantry", "fridge", "freezer"] {
                if !expiration.contains(where: { exp in
                    exp.storage == storageType && exp.recommended
                }) {
                    let recommended = !expiration.contains(where: { exp in
                        exp.storage == storageType && exp.fromDate == fromDateType
                    })
                    switch storageType {
                    case "pantry":
                        pantryActionTitle = recommended ? "Pantry - No info" : "Pantry - Not Advised"
                    case "fridge":
                        fridgeActionTitle = recommended ? "Fridge - No info" : "Fridge - Not Advised"
                    case "freezer":
                        freezerActionTitle = recommended ? "Freezer - No info" : "Freezer - Not Advised"
                    default:
                        continue
                    }
                }
            }
        }
        
        let PantryAction = UIAction(title: pantryActionTitle, image: nil) { (_) in
            self.updateStorage(storage: "pantry")
        }
        let FridgeAction = UIAction(title: fridgeActionTitle, image: nil) { (_) in
            self.updateStorage(storage: "fridge")
        }
        let FreezerAction = UIAction(title: freezerActionTitle, image: nil) { (_) in
            self.updateStorage(storage: "freezer")
        }
        
        return UIMenu(title: "", options: .displayInline,
                      children: [PantryAction, FridgeAction, FreezerAction])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
