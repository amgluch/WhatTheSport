//
//  FiltersViewController.swift
//  The final
//
//  Created by John Wang on 8/2/21.
//

import UIKit

class FiltersViewController: UIViewController{
 
    let filtersDisplay = [ "All Teams", "All Sports"]
    
    var allGames = UILabel()
    
    var allSports = UILabel()
    
    let allGamesToggle = UISwitch()
    let allSportsToggle = UISwitch()
    var labels: [UILabel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filters"
        
        var constraints: [NSLayoutConstraint] = []
        
        labels = [allGames, allSports]
        
        // allTeams
        allGames.textAlignment = NSTextAlignment.center
        allGames.translatesAutoresizingMaskIntoConstraints = false
        allGames.text = filtersDisplay[0]
        constraints.append( allGames.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40))
        constraints.append( allGames.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
        self.view.addSubview(allGames)
        
        allGamesToggle.translatesAutoresizingMaskIntoConstraints = false
        constraints.append( allGamesToggle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40))
        constraints.append( allGamesToggle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -70))
        allGamesToggle.isOn = currentUser!.filters!.allGames
        allGamesToggle.addTarget(self, action: #selector(allGamesSwithch), for: .valueChanged)
        self.view.addSubview(allGamesToggle)
        
        
        // allSports
        allSports.textAlignment = NSTextAlignment.center
        allSports.translatesAutoresizingMaskIntoConstraints = false
        allSports.text = filtersDisplay[1]
        constraints.append( allSports.topAnchor.constraint(equalTo: allGames.bottomAnchor, constant: 60))
        constraints.append( allSports.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
        self.view.addSubview(allSports)
        
        allSportsToggle.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(allSportsToggle.topAnchor.constraint(equalTo: allSports.topAnchor))
        constraints.append(allSportsToggle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -70))
        allSportsToggle.isOn = currentUser!.filters!.allSports
        allSportsToggle.addTarget(self, action: #selector(allSportsSwithch), for: .valueChanged)
        self.view.addSubview(allSportsToggle)
        
        NSLayoutConstraint.activate(constraints)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inTransition = false
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let textColor: UIColor =  currentUser!.settings!.dark ? .white : .black
        let navImage: UIImage? = currentUser!.settings!.dark ? UIImage() : nil
        self.navigationController?.navigationBar.setBackgroundImage(navImage, for: .default)
        view.backgroundColor = background
        for label in labels {
            label.textColor = textColor
        }
    }
    
    @objc func allGamesSwithch( sender: UISwitch) {
        currentUser!.filters!.allGames = !(currentUser!.filters!.allGames)
        IO.saveContext()
    }
    
    @objc func allSportsSwithch( sender: UISwitch) {
        currentUser!.filters!.allSports = !(currentUser!.filters!.allSports)
        IO.saveContext()
    }

}


