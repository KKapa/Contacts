//
//  MainTableViewCell.swift
//  AppContacts
//
//  Created by Павел Струков on 21.01.22.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    struct Model {
        let name: String
        let photo: UIImage?
        let phoneString: String?
    }
    
    @IBOutlet weak var miniPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    func configure(with model: Model?) {
        miniPhoto.image = model?.photo
        nameLabel.text = model?.name
        phoneLabel.text = model?.phoneString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
}
