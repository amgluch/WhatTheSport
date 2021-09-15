//
//  ViewController.swift
//  The final
//
//  Created by John Wang on 8/1/21.
//

import UIKit
import Firebase

class AccountPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    let setting = ["Username", "Email", "Change password", "Change profile photo", "Following", "Sign out"]
    

    var userInformation = ["default", "default", "default", "default", "default", "default"]
    
    var pictureVC: SettingProfilePictureViewController!
    var registerVC: RegisterSportController!
    
    
    var profilePhoto = UIButton()
    
    private let tableView = UITableView()
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 250, width: view.bounds.width, height: view.bounds.height - 250)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if profilePhoto.currentImage == nil {
            guard let urlstring = fireUser!.get("URL") as? String else{
                print("error retreiving urlstring")
                return
            }
            
            let imageView = UIImageView()
            //ADD LOADING ICON?
            IO.downloadImage(str: urlstring, imageView: imageView){
                self.profilePhoto.setImage(imageView.image, for: .normal)
                self.setup()
            }
        } else {
            setup()
        }
    }
    
    func setup () {
        self.view.addSubview(self.tableView)
        self.tableView.frame = CGRect(x: 0, y: 250, width: self.view.bounds.width, height: self.view.bounds.height - 500)
        self.tableView.register(AccountPageTableViewCell.self, forCellReuseIdentifier: "accountCell")
        
        self.title = fireUser!.get("username") as? String
        self.userInformation[0] = fireUser!.get("username") as! String
        self.userInformation[1] = fireUser!.get("email") as! String
        
        
        self.profilePhoto.contentMode = .scaleToFill
        self.profilePhoto.backgroundColor = .white
        self.profilePhoto.layer.masksToBounds = true
        self.profilePhoto.layer.cornerRadius = 50.0
        self.profilePhoto.frame = CGRect(x: self.view.bounds.width / 2 - 50, y: 125, width: 100, height: 100)
        self.profilePhoto.addTarget(self, action: #selector(self.changePicture), for: .touchUpInside)
        self.view.addSubview(self.profilePhoto)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: Constants.Colors.orange)
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inTransition = false
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let navImage: UIImage? = currentUser!.settings!.dark ? UIImage() : nil
        self.navigationController?.navigationBar.setBackgroundImage(navImage, for: .default)
        tableView.backgroundColor = background
        view.backgroundColor = background
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let lineColor : UIColor = currentUser!.settings!.dark ? .white : UIColor(rgb: Constants.Colors.orange)
        let textColor: UIColor =  currentUser!.settings!.dark ? .white : .black
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountPageTableViewCell
        
        cell.textLabel?.textColor = textColor
        cell.userInformationLabel.textColor = textColor
        cell.pageInformationLabel.textColor = textColor
        cell.contentView.backgroundColor = background
        cell.border.borderColor = lineColor.cgColor
        
        
        if indexPath.row > 1 {
            cell.userInformationLabel.isHidden = true
        }
        cell.configuer(pageInfo: setting[indexPath.row], information: userInformation[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let row = indexPath.row
        switch row {
        //username
        case 0:
            updateUserInforAlert(titleString: "Change Username", messageString: "Please enter your username", placeholderString: "username", index: 0)
        //email
        case 1:
            print("this is row \(row)")
        //password
        case 2:
            print("this is row \(row)")
            guard let email = fireUser?.get("email") as? String else {
                return print("error retreiving email")
            }
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    let controller = UI.createAlert(title: "Success", msg: "Check your email to reset password")
                    self.present(controller, animated: true, completion: nil)
                } else {
                    let controller = UI.createAlert(title: "Error", msg: error!.localizedDescription)
                    self.present(controller, animated: true, completion: nil)
                }
            }
        //profile picture
        case 3:
            if inTransition {
                return
            } else {
                inTransition = true
            }
            
            if pictureVC == nil{
                print("this is row at \(indexPath.row)")
                pictureVC = SettingProfilePictureViewController()
            }
            pictureVC.photo = profilePhoto.currentImage
            pictureVC.delegate = self
            UI.transition(dest: pictureVC, src: self)
        
            print("this is row \(row)")
        //following
        case 4:
            if inTransition {
                return
            } else {
                inTransition = true
            }
            
            if registerVC == nil{
                registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerSportID") as? RegisterSportController
            }
            
            //TODO: PASS IN THE USERS FOLLOWED SPORTS AND TEAMS!!!
            
            UI.transition(dest: registerVC, src: self)
        //sign out
        case 5:
            let home = UINavigationController(rootViewController: SignUpViewController())
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true, completion: nil)
            print("this is row \(row)")
        default:
            print("This should not happened!")
        }
        self.tableView.reloadData()
    }
    
    func updateUserInforAlert(titleString: String, messageString: String, placeholderString: String, index: Int) {
        let controller = UIAlertController(
            title: titleString,
            message: messageString,
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        
        controller.addTextField(configurationHandler: {
            (textField:UITextField!) in textField.placeholder = placeholderString
        })
        
        controller.addAction(UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: {
                                    
                                    (paramAction:UIAlertAction!) in
                                    if let textFieldArray = controller.textFields {
                                        let textFields = textFieldArray as [UITextField]
                                        let enteredText = textFields[0].text!
                                        self.userInformation[index] = enteredText
                                        self.tableView.reloadData()
                                        if (index == 0) {
                                            self.title = enteredText
                                            print("about to update \(self.userInformation[0])")
                                            IO.updateFireUser(field: "username", str: self.userInformation[0], completion: nil)
                                        }
                                        print("this is \(self.userInformation[index])")
                                    }
                                    
                                }))
        present(controller, animated: true, completion: nil)
    }
    
    func updatePicture(newPhoto: UIImage) {
        profilePhoto.setImage(newPhoto, for: .normal)
    }
    
    @objc func changePicture() {
        
        if pictureVC == nil{
          
            pictureVC = SettingProfilePictureViewController()
        }
    
        pictureVC.delegate = self
        pictureVC.photo = profilePhoto.currentImage
        if let navigator = navigationController {
            navigator.pushViewController(pictureVC, animated: true)
        }
        
    }

}

