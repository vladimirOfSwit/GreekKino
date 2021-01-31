//
//  DrawTableViewCell.swift
//  GreekKino
//
//  Created by Vladimir Savic on 1/29/21.
//

import UIKit

class DrawTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()

        
         

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
