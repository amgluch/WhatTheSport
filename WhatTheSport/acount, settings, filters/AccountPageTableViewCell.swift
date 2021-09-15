//
//  AccountPageTableViewCell.swift
//  The final
//
//  Created by John Wang on 8/1/21.
//

import UIKit

class AccountPageTableViewCell: UITableViewCell {
    
    public let userInformationLabel = UILabel()
   // var nextVC: UIViewController!
     
    
    public let pageInformationLabel = UILabel()
    
    var border = CALayer()
 
    public func configuer (pageInfo: String, information: String){
      
        userInformationLabel.text = information
        pageInformationLabel.text = pageInfo
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageInformationLabel.frame = CGRect(x: 10, y:0, width: 200, height: contentView.frame.size.height)
        var constraints: [NSLayoutConstraint] = []
        userInformationLabel.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(userInformationLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15))
        constraints.append( userInformationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userInformationLabel)
        contentView.addSubview(pageInformationLabel)
        
        userInformationLabel.textAlignment = .right
        let width = CGFloat(2.0)
        border.frame = CGRect(x: 15, y:  contentView.frame.size.height - width, width:   contentView.frame.size.width + 94, height:  contentView.frame.size.height)
        border.borderWidth = width
        contentView.layer.addSublayer(border)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
