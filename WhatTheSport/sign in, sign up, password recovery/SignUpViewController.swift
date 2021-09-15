//

import UIKit
import Firebase
import CoreData
import FirebaseStorage

class SignUpViewController: UIViewController, Transitioner, UITextFieldDelegate {

    var emailField: UITextField!
    var fromSignUp: Bool!
    var usernameField: UITextField!
    var passwordField: UITextField!
    var confirmField: UITextField!
    var signUpButton: UIButton!
    var signInVC: SignInViewController!
    var nextVC: UIViewController!
    var constraint: NSLayoutConstraint!
    var logo: UIImageView!
    var signInLabel: UIButton!
    var user: NSManagedObject?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        //ONLY UNCOMMENT TO DELETE ALL OF CORE DATA FROM THIS APP
        //clearCoreData()
        super.viewDidLoad()
        fromSignUp = false
        var constraints: [NSLayoutConstraint] = []
        
        if let navigator = navigationController {
            navigator.navigationBar.tintColor = .white
            navigator.navigationBar.barTintColor = UIColor(rgb: Constants.Colors.orange)
            navigator.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            navigator.navigationBar.barStyle = .black
            //navigator.navigationBar.backgroundColor = UIColor(rgb: Constants.Colors.orange)
        }
        
        view.backgroundColor = UIColor(rgb: Constants.Colors.lightOrange)
        self.title = "Sign Up"
        
        logo = UIImageView(frame: .zero)
        logo.image = UIImage(named: "splash")
        
        //uploadImage(image: logo.image!.pngData()!)
        //downloadImage(str: urlString)
        self.view.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(logo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
        constraints.append(logo.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(logo.widthAnchor.constraint(equalToConstant: view.bounds.width-50))
        constraints.append(logo.heightAnchor.constraint(equalToConstant: 125))
        
        emailField = TextField(placeholder: "Email")
        self.view.addSubview(emailField)
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(emailField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 125))
        constraints.append(emailField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(emailField.widthAnchor.constraint(equalToConstant: view.bounds.width-50))
        constraints.append(emailField.heightAnchor.constraint(equalToConstant: Constants.Field.height))
        
        usernameField = TextField(placeholder: "Choose username")
        self.view.addSubview(usernameField)
    
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(usernameField.centerXAnchor.constraint(equalTo: emailField.centerXAnchor))
        constraints.append(usernameField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: Constants.Field.spacing))
        constraints.append(usernameField.widthAnchor.constraint(equalTo: emailField.widthAnchor))
        constraints.append(usernameField.heightAnchor.constraint(equalTo: emailField.heightAnchor))
        
        passwordField = SecureTextField(placeholder: "Choose password")
        passwordField.delegate = self
        self.view.addSubview(passwordField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(passwordField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor))
        constraints.append(passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: Constants.Field.spacing))
        constraints.append(passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor))
        constraints.append(passwordField.heightAnchor.constraint(equalTo: emailField.heightAnchor))
        
        confirmField = SecureTextField(placeholder: "Repeat password")
        confirmField.delegate = self
        self.view.addSubview(confirmField)
        
        confirmField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(confirmField.centerXAnchor.constraint(equalTo: passwordField.centerXAnchor))
        constraints.append(confirmField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: Constants.Field.spacing))
        constraints.append(confirmField.widthAnchor.constraint(equalTo: emailField.widthAnchor))
        constraints.append(confirmField.heightAnchor.constraint(equalTo: emailField.heightAnchor))
        
        signUpButton = Button(title: "Sign Up")
        signUpButton.addTarget(self, action: #selector(signUpPress), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(signUpButton.centerXAnchor.constraint(equalTo: confirmField.centerXAnchor))
        constraints.append(signUpButton.topAnchor.constraint(equalTo: confirmField.bottomAnchor, constant: Constants.Field.spacing * 1.75))
        constraints.append(signUpButton.widthAnchor.constraint(equalTo: emailField.widthAnchor))
        constraints.append(signUpButton.heightAnchor.constraint(equalTo: emailField.heightAnchor))
        
//        signInLabel = UILabel(frame: .zero)
//        signInLabel.textColor = .blue
//        signInLabel.attributedText = NSAttributedString(string: "SignIn", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
//        signInLabel.textAlignment = .center
//        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.signInPress))
//        signInLabel.isUserInteractionEnabled = true
//        signInLabel.addGestureRecognizer(tap)
//        self.view.addSubview(signInLabel)
        
        var stackList: [UIView] = []
        
        signInLabel = LinkButton(title: "Sign In")
        signInLabel.addTarget(self, action: #selector(signInPress), for: .touchUpInside)
        
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let signInText = UILabel(frame: .zero)
        signInText.textAlignment = .right
        signInText.text = "Already have an account?"
        stackList.append(signInText)
        stackList.append(signInLabel)
        
        let hStack = UIStackView(arrangedSubviews: stackList)
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 5
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(hStack.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: Constants.Field.spacing * 3))
        constraints.append(hStack.centerXAnchor.constraint(equalTo: signUpButton.centerXAnchor))
        constraints.append(hStack.heightAnchor.constraint(equalTo: signUpButton.heightAnchor))
        
        self.view.addSubview(hStack)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inTransition = false
    }
    
    @objc func signInPress(sender: UIButton!) {
        if signInVC == nil {
            signInVC = SignInViewController()
        }
        signInVC.signUpVC = self

        if let navigator = navigationController {
            navigator.pushViewController(signInVC, animated: true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == self.passwordField || textField == self.confirmField) {
            textField.isSecureTextEntry = true
        }
    }

    @objc func signUpPress(sender: UIButton!) {
        guard let email = emailField.text,
              let password = passwordField.text,
              let username = usernameField.text,
              email.count > 0,
              password.count > 0,
              username.count > 0
        else {
          let controller = UI.createAlert(title: "Error", msg: "fields must not be blank")
          self.present(controller, animated: true, completion: nil)
          return
        }
        
        if let confirm = confirmField.text,
        confirm == password {
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if error == nil {
                    let db = Firestore.firestore()
                    let userID = user!.user.uid
                    
                    let docRef = db.collection("users").document(userID)
                    docRef.setData( ["username": username, "sports": [String](),
                                                              "teams": [String](), "postIDs": [String](),
                                                              "URL": Constants.Defaults.profilePicture , "uid": userID,
                                                              "email": email, "dark" : false, "allTeams": false, "allSports": false] ) { (error) in
                        if error != nil {
                            let controller = UI.createAlert(title: "Error", msg: error!.localizedDescription)
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                    self.user = self.createUser(userID: userID)
                    IO.saveContext()

                    self.fromSignUp = true
                    self.signIn (email: email, password: password)
                } else {
                    let controller = UI.createAlert(title: "Error", msg: error!.localizedDescription)
                    self.present(controller, animated: true, completion: nil)
                }
            }
        } else {
            let controller = UI.createAlert(title: "Error", msg: "Passwords do not match")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func signIn (email: String, password: String) {
        if inTransition {
            return
        } else {
            inTransition = true
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
          user, error in
          if error == nil {
            
            let userID = user!.user.uid
            
            //TODO: only assign if not nil  ?
            let users = IO.retrieveUser(userID: userID)
            IO.retrieveFireUser(userID: userID){
                if !(users!.isEmpty) {
                    currentUser = users![0] as? User
                } else {
                    currentUser = self.createUser(userID: userID) as? User
                    currentUser!.filters!.allGames = fireUser!.get("allTeams") as! Bool
                    currentUser!.filters!.allSports = fireUser!.get("allSports") as! Bool
                    currentUser!.settings!.dark = fireUser!.get("dark") as! Bool
                }
                self.printUserInfo(userID: userID)
                
                if self.fromSignUp {
                    self.nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "registerSportID")
                } else {
                    self.nextVC = TabBarViewController()
                }
                
                let register = UINavigationController(rootViewController: self.nextVC)
                register.modalPresentationStyle = .fullScreen
                self.present(register, animated: true, completion: nil)
                //UI.transition(dest: self.nextVC, src: self)
                print("signed in")
            }
          } else {
            inTransition = false
            let controller = UI.createAlert(title: "Error", msg: error!.localizedDescription)
            self.present(controller, animated: true, completion: nil)
          }
        }
    }
    
    func createUser(userID: String) -> NSManagedObject {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        
        // Set the attribute values
        user.setValue(userID, forKey: "userID")
        let settings = NSEntityDescription.insertNewObject(forEntityName: "Setting", into: context) as! Setting
        let filters = NSEntityDescription.insertNewObject(forEntityName: "Filter", into: context) as! Filter
        user.filters = filters
        user.settings = settings
        
        return user
    }
    
    func printUserInfo(userID: String) {
        print("core user info")
        
        print("\tuserID: \(currentUser!.userID)")
        print("\tsettings: \(currentUser!.settings)")
        print("\tfilters: \(currentUser!.filters)")
        
        if let fire = fireUser {
            print("\tuserID: \(fire.get("uid") as! String)")
            print("\tURL: \(fire.get("URL") as! String)")
        }
        
    }
    
    func clearEntity(entity: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
            }
            try context.save()
            
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func clearCoreData() {
        clearEntity(entity: "User")
        clearEntity(entity: "Setting")
        clearEntity(entity: "Filter")
        print("\n\nCLEARED ALL CORED DATA\n\n")
    }
    
}

