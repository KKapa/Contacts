//
//  MainTableViewCell.swift
//  AppContacts
//
//  Created by Павел Струков on 21.01.22.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var miniPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
