//
//  GameScheduleViewController.swift
//  GameList
//
//  Created by John Wang on 8/4/21.
//

import UIKit
import Firebase

class GameScheduleViewController: ViewControllerWithMenu, UITableViewDelegate, UITableViewDataSource {
    
    struct Game {
        var date: String
        var formattedDate: String
        var time: String
        //var team: String
        var usersCalendar: [String] = []
        var usersNotification: [String] = []
        var teams: [Int] = []
        //var savedEventId: String = ""
        var savedNotificationId: String = ""
        var sport: String
    }
    
    
    var gameList = [Game]()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Games"
        
        self.containerView.addSubview(self.tableView)
        
        var constraints: [NSLayoutConstraint] = []

        self.tableView.tableFooterView = UIView(frame: .zero)
        
       tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        tableView.register(GameDateTableViewCell.self, forCellReuseIdentifier: GameDateTableViewCell.identifier)
      
        tableView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(tableView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor))
        constraints.append( tableView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
        tableView.delegate = self
        tableView.dataSource = self
        
        let db = Firestore.firestore()
        
        let games = db.collection("schedules")
        games.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                for sport in querySnapshot!.documents {
                    
                    games.document(sport.documentID).collection("games").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        }
                        for document in querySnapshot!.documents {
                            //print(document.documentID)
                            let date = document.get("date") as! String
                            
                            var formattedDate = document.get("formattedDate") as! String
                            
                            let time = document.get("time") as! String
                            let addTime = time.contains("am") || time.contains("12:") ? 0 : 12
                            let timeParts = time.components(separatedBy: CharacterSet(charactersIn:  ":amAMpmPM "))
                            let timeString = "T" + String(Int(timeParts[0])! + addTime) + ":" + String(Int(timeParts[1])!)
                            formattedDate = formattedDate.replacingOccurrences(of: "T00:00", with: timeString)
                            formattedDate = formattedDate.replacingOccurrences(of: "+0000", with: "-0500")
                            
                            let usersCalender = document.get("usersCalendar") as! [String]
                            let usersNotification = document.get("usersNotification") as! [String]
                            let teams = document.get("teams") as! [Int]
                            
                            let tempGame = Game(date: date, formattedDate: formattedDate, time: time, usersCalendar: usersCalender, usersNotification: usersNotification, teams: teams, savedNotificationId: document.documentID, sport: sport.documentID)
                            self.gameList.append(tempGame)
                        }
                        
                        self.gameList.sort(by: {(game1, game2) in
                            let fdate1 = game1.formattedDate
                            let fdate2 = game2.formattedDate
                            let times1 = fdate1.components(separatedBy: CharacterSet(charactersIn:  "-T:+"))
                            let times2 = fdate2.components(separatedBy: CharacterSet(charactersIn:  "-T:+"))
                            var i = 0
                            
                            while (i < times1.count && Int(times1[i])! == Int(times2[i])!){
                                i += 1
                            }
                            i = i >= times1.count ? i - 1 : i
                            
                            return Int(times1[i])! < Int(times2[i])!
                        }
                        )
                        DispatchQueue.main.async {
                            print("DONE WITH A SPORT")
                            self.tableView.reloadData()
                        }
                    }
                }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        
        tableView.backgroundColor = background
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight:CGFloat = CGFloat()

        if indexPath.row % 2 == 0 {
            cellHeight = 25
        }
        else if indexPath.row % 2 != 0 {
            cellHeight = 80
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let textColor: UIColor =  currentUser!.settings!.dark ? .white : .black
        
        if indexPath.row % 2 == 0 {
            let dateBackground: UIColor = currentUser!.settings!.dark ? UIColor(rgb: 0x060426) : UIColor(rgb: Constants.Colors.orange)
            let cell = tableView.dequeueReusableCell(withIdentifier: GameDateTableViewCell.identifier, for: indexPath) as! GameDateTableViewCell
            cell.contentView.backgroundColor = dateBackground
            let time = gameList[indexPath.row / 2].time
            cell.textLabel?.text = "\(gameList[indexPath.row / 2].date)\t\t\(time)"
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as! GameTableViewCell
        cell.textLabel?.text = ""
        //print("about to print indices")
        //print(gameList[indexPath.row / 2].teams[0])
        //print(gameList[indexPath.row / 2].teams[1])
        let sport = gameList[indexPath.row / 2].sport
        var sportArray: [String] = []
        switch sport {
        case "MLB":
            sportArray = mlb
        case "NBA":
            sportArray = nba
        case "MLS":
            sportArray = mls
        case "NFL":
            sportArray = nfl
        default:
            print("SHOULD NOT HAPPEN sport: \(sport)")
        }
        let team1 = sportArray[gameList[indexPath.row / 2].teams[0]]
        let team2 = sportArray[gameList[indexPath.row / 2].teams[1]]
        let teamText = "\(team1) VS \(team2)"
        //print(teamText)
        cell.displayLabel.text = teamText
        cell.textLabel?.textColor = textColor
        cell.displayLabel.textColor = textColor
        
        cell.index = indexPath.row / 2
        cell.delegate = self
        
        cell.notificationId = gameList[indexPath.row / 2].savedNotificationId
        
        cell.onCalendar =  gameList[indexPath.row / 2].usersCalendar.contains((currentUser?.userID)!)
        cell.onNotify =  gameList[indexPath.row / 2].usersNotification.contains((currentUser?.userID)!)
        
        cell.formattedDate = gameList[indexPath.row / 2].formattedDate
        
        let hash = (team1 + team2).hashValue
        //print("hash \(hash)")
        let hashD = Double(abs(hash))
        //print("hashD \(hashD)")
        let identifer = hashD / pow(10, 16)
        //print("identifer \(identifer)")
        cell.uniqueIdentifer = identifer
        
        cell.updateColor(color: background)
        
        return cell
      
    }
    
    func updateCalendar (index: Int, remove: Bool) {
        let ID = (currentUser?.userID)!
        let game = gameList[index].savedNotificationId
        let sport = gameList[index].sport
        updateFireLeague(sport: sport, field: "usersCalendar", items: [ID], game: game, remove: remove)
        if remove {
            if let removeIndex = gameList[index].usersCalendar.firstIndex(of: ID){
                gameList[index].usersCalendar.remove(at: removeIndex)
            }
        } else {
            gameList[index].usersCalendar.append(ID)
        }
    }
    
    func updateNotification (index: Int, remove: Bool) {
        let ID = (currentUser?.userID)!
        let game = gameList[index].savedNotificationId
        let sport = gameList[index].sport
        updateFireLeague(sport: sport, field: "usersNotification", items: [ID], game: game, remove: remove)
        if remove {
            if let removeIndex = gameList[index].usersNotification.firstIndex(of: ID){
                gameList[index].usersNotification.remove(at: removeIndex)
            }
        } else {
            gameList[index].usersNotification.append(ID)
        }
    }
    
    func updateFireLeague(sport: String, field: String, items: [String], game: String, remove: Bool) {
        let db = Firestore.firestore()
        let ref = db.collection("schedules").document(sport)
        let docRef = ref.collection("games").document(game)
        
        if !remove {
            docRef.updateData([
                field: FieldValue.arrayUnion(items)
                ]){ error in
                if let e = error {
                    print("error updating fire user \(e.localizedDescription)")
                }
            }
        } else {
            docRef.updateData([
                field: FieldValue.arrayRemove(items)
                ]){ error in
                if let e = error {
                    print("error updating fire user \(e.localizedDescription)")
                }
            }
        }
    }
}
