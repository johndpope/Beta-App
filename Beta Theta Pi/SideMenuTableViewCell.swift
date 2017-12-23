//
//  SideMenuTableViewCell.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/22/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var viewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
