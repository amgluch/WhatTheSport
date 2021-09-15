//
//  RegisterSportController.swift
//  WhatTheSport
//
//  Created by Adam Gluch on 7/26/21.
//

import UIKit

class SelectTeamController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var nextButton: UIButton!
    var delegate: UIViewController!
    var selectedSports: [String] = []
    var orderedSports: [String] = []
    var home: TabBarViewController!
    @IBOutlet weak var tableView: UITableView!
    
    private let mlbTeams: [String] = ["Arizona Diamondbacks","Atlanta Braves","Baltimore Orioles",
                                      "Boston Red Sox","Chicago Cubs","Chicago White Sox",
                                      "Cincinnati Reds","Cleveland Indians","Colorado Rockies",
                                      "Detroit Tigers","Houston Astros","Kansas City Royals",
                                      "Los Angeles Angels","Los Angeles Dodgers","Miami Marlins",
                                      "Milwaukee Brewers","Minnesota Twins","New York Mets",
                                      "New York Yankees","Oakland Athletics","Philadelphia Phillies",
                                      "Pittsburgh Pirates","San Diego Padres","San Francisco Giants",
                                      "Seattle Mariners","St. Louis Cardinals","Tampa Bay Rays",
                                      "Texas Rangers","Toronto Blue Jays","Washington Nationals"]
    
    private let mlsTeams: [String] = ["Atlanta United","Austin FC","Chicago Fire FC",
                                      "FC Cincinnati","Colorado Rapids","Columbus Crew",
                                      "D.C. United","FC Dallas","Houston Dynamo FC",
                                      "Sporting Kansas City","LA Galaxy","Los Angeles Football Club",
                                      "Inter Miami CF","Minnesota United","CF Montréal",
                                      "Nashville SC","New England Revolution","New York Red Bulls",
                                      "New York City FC","Orlando City","Philadelphia Union",
                                      "Portland Timbers","Real Salt Lake","San Jose Earthquakes",
                                      "Seattle Sounders FC", "Toronto FC", "Vancouver Whitecaps FC"]
    
    private let nbaTeams: [String] = ["Atlanta Hawks","Boston Celtics","Brooklyn Nets",
                                      "Charlotte Hornets","Chicago Bulls","Cleveland Cavaliers",
                                      "Dallas Mavericks","Denver Nuggets","Detroit Pistons",
                                      "Golden State Warriors","Houston Rockets","Indiana Pacers",
                                      "LA Clippers","Los Angeles Lakers","Memphis Grizzlies",
                                      "Miami Heat","Milwaukee Bucks","Minnesota Timberwolves",
                                      "New Orleans Pelicans","New York Knicks","Oklahoma City Thunder",
                                      "Orlando Magic","Philadelphia 76ers","Phoenix Suns",
                                      "Portland Trail Blazers","Sacramento Kings","San Antonio Spurs",
                                      "Toronto Raptors","Utah Jazz","Washington Wizards"]
    
    private let nflTeams: [String] = ["Arizona Cardinals","Atlanta Falcons","Baltimore Ravens",
                                      "Buffalo Bills","Carolina Panthers","Chicago Bears",
                                      "Cincinnati Bengals","Cleveland Browns","Dallas Cowboys",
                                      "Denver Broncos","Detroit Lions","Green Bay Packers",
                                      "Houston Texans","Indianapolis Colts","Jacksonville Jaguars",
                                      "Kansas City Chiefs","Las Vegas Raiders","Los Angeles Chargers",
                                      "Los Angeles Rams","Miami Dolphins","Minnesota Vikings",
                                      "New England Patriots","New Orleans Saints","New York Giants",
                                      "New York Jets","Philadelphia Eagles","Pittsburgh Steelers",
                                      "San Francisco 49ers","Seattle Seahawks","Tampa Bay Buccaneers",
                                      "Tennessee Titans","Washington Football Team"]
    private var selectedTeams: [String] = []
    private var teamsToShow: [[String]] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teamsToShow.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsToShow[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        if indexPath.row == 0 {
            let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "franchiseCellIdentifier") as! FranchiseCell
            let name = orderedSports[indexPath.section]
            cell.franchiseName = name
            cell.franchiseLogo.image = UIImage(named: name)
            cell.franchiseLogo.backgroundColor = background
            cell.backgroundColor = background
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let background: UIColor = currentUser!.settings!.dark ? .black : .white
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamCellIdentifier", for: indexPath) as! TeamCell
            let teamName = teamsToShow[indexPath.section][indexPath.row - 1]
            let teamLogo = UIImage(named: teamName)
            cell.teamLogo.image = teamLogo
            cell.teamName.text = teamName
            cell.backgroundColor = background
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let teamName = teamsToShow[indexPath.section][indexPath.row - 1]
            selectedTeams.append(teamName)
            print(teamName)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let teamName = teamsToShow[indexPath.section][indexPath.row - 1]
            let removedTeam = selectedTeams.remove(at: selectedTeams.firstIndex(of: teamName)!)
            print(removedTeam)
        }
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        inTransition = false
        orderedSports.append("MLB")
        teamsToShow.append(mlbTeams)
    
        orderedSports.append("MLS")
        teamsToShow.append(mlsTeams)
    
        orderedSports.append("NBA")
        teamsToShow.append(nbaTeams)
    
        orderedSports.append("NFL")
        teamsToShow.append(nflTeams)
        
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let navImage: UIImage? = currentUser!.settings!.dark ? UIImage() : nil
        self.navigationController?.navigationBar.setBackgroundImage(navImage, for: .default)
        view.backgroundColor = background
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigator.navigationBar.backgroundColor = UIColor(rgb: Constants.Colors.orange)
    
        self.title = "Select Team"
        view.backgroundColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        nextButton.backgroundColor = UIColor(rgb: Constants.Colors.orange)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 20.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: "teamCellIdentifier")
        tableView.register(UINib(nibName: "FranchiseCell", bundle: nil), forCellReuseIdentifier: "franchiseCellIdentifier")
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        //update firestore
        if selectedTeams.count != 0 {
            //TODO present Martin's view
            if home == nil {
                home = TabBarViewController()
            }
            
            let tabBar = UINavigationController(rootViewController: self.home)
            tabBar.modalPresentationStyle = .fullScreen
            self.present(tabBar, animated: true, completion: nil)
            
            let tabBarVC = TabBarViewController()
            navigationController?.pushViewController(tabBarVC, animated: true)
        } else { //require 1 team selected
            let alertController = UI.createAlert(title: "No team selected", msg: "Please select 1 team.")
            present(alertController, animated: true, completion: nil)
        }
    }
}
