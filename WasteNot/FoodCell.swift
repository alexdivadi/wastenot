//
//  FoodCell.swift
//  WasteNot
//
//  Created by David Allen on 4/13/24.
//

import UIKit

class FoodCell: UITableViewCell {

    
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var expirationStatusView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
