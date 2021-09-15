//
//  FranchiseCell.swift
//  WhatTheSport
//
//  Created by Glucci on 8/5/21.
//

import UIKit

class FranchiseCell: UITableViewCell {
    var franchiseName: String?
    @IBOutlet weak var franchiseLogo: UIImageView!
    
    func configure(image: UIImage?, text: String) {
        franchiseName = text
        franchiseLogo.image = image
    }
}
