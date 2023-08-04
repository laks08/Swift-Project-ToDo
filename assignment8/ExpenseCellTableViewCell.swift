//
//  ExpenseCellTableViewCell.swift
//  assignment8
//
//  Created by Lakshya Gupta on 4/29/23.
//

import UIKit

class ExpenseCellTableViewCell: UITableViewCell {
//
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var expenseCategory: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        expenseAmount.layer.cornerRadius = 8
        expenseAmount.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
