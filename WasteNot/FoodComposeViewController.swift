//
//  FoodComposeViewController.swift
//  WasteNot
//
//  Created by David Allen on 4/13/24.
//

import UIKit

protocol getFoodDelegateProtocol{
    func getFood(food: Food)
    func getFoodCompose() -> Food?
}
class FoodComposeViewController: UIViewController {
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        guard let food = FoodComposeViewController.delegate?.getFoodCompose()
        else {
            return
        }
        
        
        onComposeFood?(food)
        dismiss(animated: true)
    }
    
    var foodToEdit: Food?
    var onComposeFood: ((Food) -> Void)? = nil
    static var delegate: getFoodDelegateProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let food = foodToEdit {
            self.title = "Edit Food"
            FoodComposeViewController.delegate?.getFood(food: food)
        } else {
            self.title = "New Food"
        }
    }

}
