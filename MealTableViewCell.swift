//
//  MealTableViewCell.swift
//  Rumble
//
//  Created by Yanbo Li on 3/27/17.
//  Copyright © 2017 Yanbo Li. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    //Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.masksToBounds = false
        photoImageView.layer.borderColor = UIColor.white.cgColor
        photoImageView.layer.cornerRadius = photoImageView.frame.height/2
        photoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
