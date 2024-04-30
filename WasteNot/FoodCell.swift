//
//  FoodCell.swift
//  WasteNot
//
//  Created by David Allen on 4/13/24.
//

import UIKit

class FoodCell: UITableViewCell {

    
    @IBOutlet weak var foodEmojiLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var expirationStatusView: UIImageView!
    
    var food: Food!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with food: Food) {
        self.food = food
        update(with: food)
    }

    
    private func update(with food: Food) {
        foodLabel.text = food.foodType.name
        foodEmojiLabel.text = food.foodType.emoji
        categoryLabel.text = food.foodType.category
        
        let now: Date = Date.now
        
        if let expirationDate = food.expirationDate {
            if food.expirationData != nil && !food.expirationData!.recommended {
                expirationLabel.text = "Selected storage not advised - Expected expiration:  \(expirationDate.formatted(date: .numeric, time: .omitted))"
                expirationStatusView.tintColor = UIColor.systemGray
            }
            else if expirationDate < now {
                expirationLabel.text = "Expired on \(expirationDate.formatted(date: .numeric, time: .omitted))"
                expirationStatusView.tintColor = UIColor.systemRed
            }
            else if expirationDate - now < 60*60*24 {
                expirationLabel.text = "Expires Today"
                expirationStatusView.tintColor = UIColor.systemYellow
            }
            else if expirationDate - now < 60*60*24*2 {
                expirationLabel.text = "Expires Tomorrow"
                expirationStatusView.tintColor = UIColor.systemYellow
            }
            else if food.checkDate != nil && food.checkDate! < now {
                expirationLabel.text = "Expires on \(expirationDate.formatted(date: .numeric, time: .omitted))"
                expirationStatusView.tintColor = UIColor.systemYellow
            }
            else {
                expirationLabel.text = "Expires on \(expirationDate.formatted(date: .numeric, time: .omitted))"
                expirationStatusView.tintColor = UIColor.systemGreen
            }
        }
        else {
            expirationLabel.text = ""
            expirationStatusView.tintColor = UIColor.systemGreen
        }
    }

}
