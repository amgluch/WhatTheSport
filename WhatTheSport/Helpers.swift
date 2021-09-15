//
//  helpers.swift
//  WhatTheSport

import Foundation
import UIKit
import FirebaseStorage
import Firebase
import CoreData

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

var currentUser:User?
var fireUser:DocumentSnapshot?
var inTransition: Bool = false

class TextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setLeftPaddingPoints(10)
        self.setRightPaddingPoints(10)
    }

    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

class SecureTextField: TextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSecureTextEntry = false
        self.textContentType = .oneTimeCode
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

class LinkButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(rgb: Constants.Colors.orange).withAlphaComponent(0)
        self.setTitleColor(UIColor(rgb: Constants.Colors.orange), for: .normal)
    }
    
    convenience init(title: String) {
        self.init()
        let signInAttributes: [NSAttributedString.Key: Any] = [/*.underlineStyle: NSUnderlineStyle.single.rawValue, */ .font: UIFont.systemFont(ofSize: 18)]
        self.setAttributedTitle(NSMutableAttributedString(string: title, attributes: signInAttributes), for: .normal)
    }
    
    convenience init() {
        self.init(type: .roundedRect)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(rgb: Constants.Colors.orange)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 20.0
    }
    
    convenience init(title: String) {
        self.init()
        let attributes: [NSAttributedString.Key: Any] = [/*.underlineStyle: NSUnderlineStyle.single.rawValue, */ .font: UIFont.systemFont(ofSize: 18)]
        self.setAttributedTitle(NSMutableAttributedString(string: title, attributes: attributes), for: .normal)
    }
    
    convenience init() {
        self.init(type: .roundedRect)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

extension UIApplication {
    
    //get the current view controller
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

struct Constants {
    struct Colors {
        static let lightOrange = 0xfce9d4
        static let orange = 0xff9500
    }
    struct Defaults {
        static let profilePicture = "https://firebasestorage.googleapis.com/v0/b/whatthesport-59d4a.appspot.com/o/images%2Fsplash.png?alt=media&token=23281d6d-19cb-4278-83b9-d411df8917d4"
    }
    struct Field {
        static let spacing: CGFloat = 15.0
        static let height: CGFloat = 45.0
    }
    struct RadioControl {
            static let height: CGFloat = 50
    }
}

struct UI {
    static func createAlert(title: String, msg: String) -> UIAlertController{
        let controller = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: nil))
        return controller
    }
    static func transition(dest: UIViewController, src: UIViewController){
        if let navigator = src.navigationController {
            navigator.pushViewController(dest, animated: true)
        }
    }
}

struct IO {
    static func uploadImage(image: Data, format: String, update: Bool) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var urlString: String?
        // Data in memory
        let data = image

        let splashref = storageRef.child("images/\(UUID().uuidString).\(format)")

        splashref.putData(data, metadata: nil) { (metadata, error) in
          guard error == nil else {
            // Uh-oh, an error occurred!
            print("\n\n\n\nerror uploading picture")
            return
          }
            splashref.downloadURL { (url, error) in
                guard let url = url, error == nil else {
                  // Uh-oh, an error occurred!
                    print("\n\n\n\nerror downloading url")
                  return
                }
                urlString = url.absoluteString
                IO.updateFireUser(field: "URL", str: urlString!, completion: nil)
            }
        }
        print("finish with uploading")
    }
    
    static func uploadImage(image: UIImage, format: String, update: Bool) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("\n\n\n\nerror uploading picture")
            return
        }
        uploadImage(image: data, format: format, update: update)
    }
    
    typealias CompletionMethod = ()  -> Void
    static func downloadImage(url: URL, imageView: UIImageView, completion: CompletionMethod?) {
        var image: UIImage?
        let task = URLSession.shared.dataTask(with: url) { ( data, _, error) in
            guard let data = data, error == nil else {
                print ("\n\n\n\nerror with downloading image")
                return
            }
            image = UIImage(data: data)
            DispatchQueue.main.async {
                imageView.image = image
                if completion != nil {
                    completion?()
                }
            }
        }
        task.resume()
    }
    
    static func downloadImage(str: String, imageView: UIImageView, completion: CompletionMethod?) {
        guard let url = URL(string: str) else {
            print("error downloading image, string: \(str)")
            return
        }
        print("downloading image, url: \(str)")
        IO.downloadImage(url: url, imageView: imageView, completion: completion)
    }
    
    static func retrieveUser(userID: String) -> [NSManagedObject]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        var fetchedResults:[NSManagedObject]? = nil
        
        let predicate = NSPredicate(format: "userID == '\(userID)'")
        request.predicate = predicate
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return(fetchedResults)
    }
    
    static func retrieveFireUser(userID: String, completion: CompletionMethod?) {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        let docRef = ref.document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                fireUser = document
            } else {
                print("error retreiving firestore data")
            }
            if completion != nil {
                completion?()
            }
        }
    }
    
    static func updateFireUser(field: String, str: String, completion: CompletionMethod?) {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        guard let userID = currentUser?.userID else {
            print("error updating fire user")
            return
        }
        let docRef = ref.document(userID)
        print("field: \(field)")
        print("new: \(str)")
        docRef.updateData([field: str]){ error in
            if let e = error {
                print("error updating fire user \(e.localizedDescription)")
            }
        }
        print("updating\n\n")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                fireUser = document
            } else {
                print("error updating fire user")
            }
            if completion != nil {
                completion?()
            }
        }
    }
    
    static func updateFireUserArray(field: String, collection: [String], completion: CompletionMethod?) {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        guard let userID = currentUser?.userID else {
            print("error updating fire user")
            return
        }
        let docRef = ref.document(userID)
        print("field: \(field)")
        print("new: \(collection)")
        docRef.updateData([field: collection]){ error in
            if let e = error {
                print("error updating fire user \(e.localizedDescription)")
            }
        }
        print("updating\n\n")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                fireUser = document
            } else {
                print("error updating fire user")
            }
            if completion != nil {
                completion?()
            }
        }
    }
    
    static func updateFireUserArray(userID: String, field: String, items: [String], remove: Bool) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        
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
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                fireUser = document
            } else {
                print("error updating fire user")
            }
        }
    }
    
    static func saveContext(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Commit the changes
        do {
            try context.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}

let mlbTeams: [String] = ["Arizona Diamondbacks","Atlanta Braves","Baltimore Orioles",
                                  "Boston Red Sox","Chicago Cubs","Chicago White Sox",
                                  "Cincinnati Reds","Cleveland Indians","Colorado Rockies",
                                  "Detroit Tigers","Houston Astros","Kansas City Royals",
                                  "Los Angeles Angels","Los Angeles Dodgers","Miami Marlins",
                                  "Milwaukee Brewers","Minnesota Twins","New York Mets",
                                  "New York Yankees","Oakland Athletics","Philadelphia Phillies",
                                  "Pittsburgh Pirates","San Diego Padres","San Francisco Giants",
                                  "Seattle Mariners","St. Louis Cardinals","Tampa Bay Rays",
                                  "Texas Rangers","Toronto Blue Jays","Washington Nationals"]

let mlsTeams: [String] = ["Atlanta United","Austin FC","Chicago Fire FC",
                                  "FC Cincinnati","Colorado Rapids","Columbus Crew",
                                  "D.C. United","FC Dallas","Houston Dynamo FC",
                                  "Sporting Kansas City","LA Galaxy","Los Angeles Football Club",
                                  "Inter Miami CF","Minnesota United","CF Montréal",
                                  "Nashville SC","New England Revolution","New York Red Bulls",
                                  "New York City FC","Orlando City","Philadelphia Union",
                                  "Portland Timbers","Real Salt Lake","San Jose Earthquakes",
                                  "Seattle Sounders FC", "Toronto FC", "Vancouver Whitecaps FC"]

let nbaTeams: [String] = ["Atlanta Hawks","Boston Celtics","Brooklyn Nets",
                                  "Charlotte Hornets","Chicago Bulls","Cleveland Cavaliers",
                                  "Dallas Mavericks","Denver Nuggets","Detroit Pistons",
                                  "Golden State Warriors","Houston Rockets","Indiana Pacers",
                                  "LA Clippers","Los Angeles Lakers","Memphis Grizzlies",
                                  "Miami Heat","Milwaukee Bucks","Minnesota Timberwolves",
                                  "New Orleans Pelicans","New York Knicks","Oklahoma City Thunder",
                                  "Orlando Magic","Philadelphia 76ers","Phoenix Suns",
                                  "Portland Trail Blazers","Sacramento Kings","San Antonio Spurs",
                                  "Toronto Raptors","Utah Jazz","Washington Wizards"]

let nflTeams: [String] = ["Arizona Cardinals","Atlanta Falcons","Baltimore Ravens",
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


let sportsList = ["MLB", "MLS", "NBA", "NFL"]

let sportsIndexList = [mlbTeams, mlsTeams, nbaTeams, nflTeams]
