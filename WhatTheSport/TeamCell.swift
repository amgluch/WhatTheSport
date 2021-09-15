//
//  TeamCell.swift
//  WhatTheSport
//
//  Created by Glucci on 8/5/21.
//

import UIKit

class TeamCell: UITableViewCell {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    
    func configure(logo: UIImage?, name: String) {
        teamName.text = name
        teamLogo.image = logo
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = UIColor(rgb: Constants.Colors.orange)
            teamLogo.backgroundColor = UIColor(rgb: Constants.Colors.orange)
            teamName.backgroundColor = UIColor(rgb: Constants.Colors.orange)
        } else {
            contentView.backgroundColor = .white
            teamLogo.backgroundColor = .white
            teamName.backgroundColor = .white
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.teamLogo.image = nil
//        self.teamName.text = nil
//    }
}
