//
//  MenuView.swift
//  WhatTheSport
//
//  Created by David Olivares on 8/6/21.
//

import UIKit
import Firebase


class MenuView: UIView {
 
    var delegate : TabBarViewController!
    
    let username = UILabel()
    
    let email = UILabel()
    
    let profile = UILabel()
    let setting = UILabel()
    let signOut = UILabel()
    
    let profileButton = UIButton()
    let settingButton = UIButton()
    let signOutButton = UIButton()
    
    public var userPhoto = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        
        var constraints: [NSLayoutConstraint] = []
        
        let db = Firestore.firestore()
        
        db.collection("users").document((currentUser?.userID)!)
            .addSnapshotListener { documentSnapshot, error in
                  guard let document = documentSnapshot, error == nil else {
                    print("Error fetching document: \(error!)")
                    return
                  }
                  guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                  }
                print("\n\n\n IN MENUUU!\n\n\n")
                //print("Current data: \(data)")
                self.username.text = data["username"] as? String
//
//                guard let urlstring = data["URL"] as? String else {
//                        print("error retreiving urlstring")
//                        return
//                }
//                IO.downloadImage(str: urlstring, imageView: self.userPhoto){}
        }

        userPhoto.backgroundColor = .lightGray
        userPhoto.contentMode = .scaleToFill
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.cornerRadius = 25.0
        userPhoto.frame = CGRect(x: self.bounds.width / 2 + 30, y: 40, width: 50, height: 50)
        self.addSubview(userPhoto)
        
        //username labe
        username.translatesAutoresizingMaskIntoConstraints = false
        username.font = UIFont.boldSystemFont(ofSize: 20.0)
        constraints.append(username.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 20))
        constraints.append(username.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor))
        self.addSubview(username)
        
        //email label
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = fireUser!.get("email") as? String
        constraints.append(email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 10))
        constraints.append(email.leadingAnchor.constraint(equalTo: username.leadingAnchor))
        self.addSubview(email)
        
       //  draw the line
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 180))
        path.addLine(to: CGPoint(x: 380, y: 180))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        self.layer.addSublayer(shapeLayer)
        
        //profile button
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        profileButton.tintColor = .gray
        constraints.append(profileButton.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 60))
        constraints.append(profileButton.leadingAnchor.constraint(equalTo: username.leadingAnchor))
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        self.addSubview(profileButton)
        
        //profile label
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.text = "Profile"
        constraints.append(profile.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 60))
        constraints.append(profile.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 50))
        self.addSubview(profile)
        
        
        //setting button
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingButton.tintColor = .gray
        constraints.append(settingButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 20))
        constraints.append( settingButton.leadingAnchor.constraint(equalTo: username.leadingAnchor))
        settingButton.addTarget(self, action: #selector(settingButtonPressed), for: .touchUpInside)
        self.addSubview( settingButton)
        
        //seeting label
        setting.translatesAutoresizingMaskIntoConstraints = false
        setting.text = "settings"
        constraints.append(setting.topAnchor.constraint(equalTo: settingButton.topAnchor))
        constraints.append(setting.leadingAnchor.constraint(equalTo: settingButton.trailingAnchor, constant: 50))
        self.addSubview(setting)
        
        //sign out button
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setImage(UIImage(systemName: "escape"), for: .normal)
        signOutButton.tintColor = .gray
        constraints.append(signOutButton.topAnchor.constraint(equalTo:settingButton.bottomAnchor, constant: 20))
        constraints.append(signOutButton.leadingAnchor.constraint(equalTo: username.leadingAnchor))
        signOutButton.addTarget(self, action: #selector(signOutPressed), for: .touchDown)
        self.addSubview(signOutButton)
        
        //sign out label
        signOut.translatesAutoresizingMaskIntoConstraints = false
        signOut.text = "Sign Out"
        constraints.append(signOut.topAnchor.constraint(equalTo: signOutButton.topAnchor))
        constraints.append(signOut.leadingAnchor.constraint(equalTo: signOutButton.trailingAnchor, constant: 50))
        self.addSubview(signOut)
        NSLayoutConstraint.activate(constraints)
    }
    
    func changeTextColor(color: UIColor) {
        username.textColor = color
        email.textColor = color
        profile.textColor = color
        setting.textColor = color
        signOut.textColor = color
    }
    
    func changeButtonColor(color: UIColor) {
        profileButton.tintColor = color
        settingButton.tintColor = color
        signOutButton.tintColor = color
    }
    
    @objc func profileButtonPressed() {

        let accountVC = delegate!
        accountVC.acountPageTapped()

    }
    
    @objc func settingButtonPressed() {
        
        let setingVC = delegate!
        setingVC.settingsPageTapped()
    }
    
    @objc func signOutPressed() {
        let signOutVC = delegate!
        signOutVC.signOutPageTapped()
       
    }

}
