//
//  HousePositionsTableViewCell.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/26/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class HousePositionsTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
