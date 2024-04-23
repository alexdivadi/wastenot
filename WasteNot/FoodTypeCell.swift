//
//  FoodTypeCell.swift
//  WasteNot
//
//  Created by David Allen on 4/20/24.
//

import UIKit

class FoodTypeCell: UITableViewCell {

    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var foodEmojiLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
