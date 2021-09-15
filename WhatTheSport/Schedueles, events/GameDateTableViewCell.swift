//
//  GameDateTableViewCell.swift
//  GameList
//
//  Created by John Wang on 8/4/21.
//

import UIKit

class GameDateTableViewCell: UITableViewCell {
    
    static let identifier = "GameDateCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        self.textLabel?.textColor = .white

        //userInformationLabel.text = " user Infor"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
