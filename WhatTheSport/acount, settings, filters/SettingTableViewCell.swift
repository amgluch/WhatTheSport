//
//  SettingTableViewCell.swift
//  FinalProject
//
//  Created by John Wang on 8/2/21.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    let displayLabel = UILabel()
    
    var border = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        displayLabel.frame = CGRect(x: 250, y:0, width: 150, height: contentView.frame.size.height)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(displayLabel)
      
        displayLabel.textAlignment = .right
        let width = CGFloat(2.0)
        border.frame = CGRect(x: 20, y:  contentView.frame.size.height - width, width:   contentView.frame.size.width + 74, height:  contentView.frame.size.height)
        border.borderWidth = width
        contentView.layer.addSublayer(border)
        contentView.layer.masksToBounds = true
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
