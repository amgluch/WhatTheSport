//
//  ViewController.swift
//  FinalProject
//
//  Created by John Wang on 8/2/21.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    let settingDisplay = ["Account", "DarkMode", "App version"]
    var nextVC: AccountPageViewController!
    var profilePic: UIImage!
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let navImage: UIImage? = currentUser!.settings!.dark ? UIImage() : nil
        
        if let navigator = navigationController {
            self.navigationController?.navigationBar.setBackgroundImage(navImage, for: .default)
            //self.navigationController?.navigationBar.shadowImage = UIImage()
            navigator.navigationBar.barTintColor = UIColor(rgb: Constants.Colors.orange)
            navigator.navigationBar.tintColor = .white
            navigator.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            navigator.navigationBar.isTranslucent = true
        }
        
        self.title = "Settings"
        
        var constraints: [NSLayoutConstraint] = []

       
        view.addSubview(tableView)

        self.tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.register(SettingToggleTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
        constraints.append( tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        //tableView.frame = CGRect(x: 0, y: 250, width: view.bounds.width, height: view.bounds.height - 500)
        tableView.backgroundColor = background
        NSLayoutConstraint.activate(constraints)
        view.backgroundColor = background
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inTransition = false
    }
    
    @objc func darkModeSwitch( sender: UISwitch) {
        currentUser!.settings!.dark = !(currentUser!.settings!.dark)
        IO.saveContext()
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let navImage: UIImage? = currentUser!.settings!.dark ? UIImage() : nil
        self.navigationController?.navigationBar.setBackgroundImage(navImage, for: .default)
        view.backgroundColor = background
        tableView.backgroundColor = background
        tableView.reloadData()
    }
    
    @objc func pushSwitch( sender: UISwitch) {
        currentUser!.settings!.push = !(currentUser!.settings!.push)
        IO.saveContext()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let lineColor : UIColor = currentUser!.settings!.dark ? .white : UIColor(rgb: Constants.Colors.orange)
        let textColor: UIColor =  currentUser!.settings!.dark ? .white : .black
        
        let cell: SettingTableViewCell = (indexPath.row == 1) ?
            tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath)  as! SettingTableViewCell :
            tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
        
        cell.contentView.backgroundColor = background
        cell.border.borderColor = lineColor.cgColor
        cell.textLabel?.textColor = textColor
        cell.displayLabel.textColor = textColor
        cell.textLabel?.text = settingDisplay [indexPath.row]
        
        if indexPath.row == 1 {
            let togglecell = cell as! SettingToggleTableViewCell
            togglecell.toggle.isOn = currentUser!.settings!.dark
            togglecell.toggle.addTarget(self, action: #selector(darkModeSwitch), for: .valueChanged)
            return togglecell
        }
        
        if ( indexPath.row == 0) {
            cell.displayLabel.isHidden = true
        }
        else {
            cell.displayLabel.text = "V.1"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let row = indexPath.row
        switch row {
        case 0:
            if inTransition {
                return
            } else {
                inTransition = true
            }
            
            print("this is row \(row)")
            if nextVC == nil{
                print("this is row at \(indexPath.row)")
                nextVC = AccountPageViewController()
                if let image = profilePic {
                    nextVC.profilePhoto.setImage(image, for: .normal)
                }
            }
            
            UI.transition(dest: self.nextVC, src: self)
        case 3:
            print("this is row \(row)")

        default:
            print("This should not happen.")
        }
        self.tableView.reloadData()
        
      
    }


}

