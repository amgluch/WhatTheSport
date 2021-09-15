//
//  TabBarViewController.swift
//  GameList
//
//  Created by John Wang on 8/4/21.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var vc1: UINavigationController!
    var vc2: UINavigationController!
    
    var plusButton: UIBarButtonItem!
    var filterButton: UIBarButtonItem!
    var moreButton: UIBarButtonItem!
    
    var filtersVC: FiltersViewController!
    var createPostVC: CreatePostViewController!
    var accountPageVC: AccountPageViewController!
    var settingsVC: SettingViewController!
    
    var gameController: GameScheduleViewController!
    var feedController: FeedViewController!
    
    var userPhoto: UIImageView!
    
    var isSlide = false
    var inAnimation = false
    var stringURL = ""
    
    func acountPageTapped() {
        if let settings = settingsVC, let account = settings.nextVC {
            accountPageVC = account
        }
        else if accountPageVC == nil {
            accountPageVC = AccountPageViewController()
            accountPageVC.profilePhoto.setImage(userPhoto.image, for: .normal)
        }
             
        if let navigator = navigationController {
              navigator.pushViewController(accountPageVC, animated: true)
        }
    }
    
    func settingsPageTapped() {
        if settingsVC == nil {
            settingsVC = SettingViewController()
            
            if accountPageVC != nil {
                settingsVC.nextVC = accountPageVC
            } else {
                settingsVC.profilePic = userPhoto.image
            }
        }
        
        if let navigator = navigationController {
              navigator.pushViewController(settingsVC, animated: true)
        }
    }
    
    func signOutPageTapped() {
        let home = UINavigationController(rootViewController: SignUpViewController())
        
        home.modalPresentationStyle = .fullScreen
        self.present(home, animated: true, completion: nil)
    }
    
    @objc
    func menuBarButtonTapped() {
        if inAnimation {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut){
            self.inAnimation = true
            let currentViewController = UIApplication.getTopViewController() as! ViewControllerWithMenu
            currentViewController.containerView.frame.origin.x = self.isSlide ? 0 : currentViewController.containerView.frame.width - currentViewController.slideInMenuPadding
            print("in animation")
        } completion: { (didFinish) in
            print("finished")
            self.inAnimation = false
            self.isSlide.toggle()
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        moreButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target:self, action: #selector(menuBarButtonTapped))
        
        self.navigationItem.leftBarButtonItem = moreButton
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.delegate = self
        
        let db = Firestore.firestore()
        
        userPhoto = UIImageView()
        
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
                print("\n\n\n IN TABBAR!\n\n\n")
                
                guard let urlstring = data["URL"] as? String else {
                        print("error retreiving urlstring")
                        return
                }
                
                if (urlstring != self.stringURL) {
                    IO.downloadImage(str: urlstring, imageView: self.userPhoto){
                        self.updatePic()
                    }
                    self.stringURL = urlstring
                }
        }
        
        filterButton = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.down.circle.fill"), style: .plain, target:self, action: #selector(filterTransition))
        
        plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(queueCreatePost(_:)))
        
        gameController = GameScheduleViewController()
        gameController.delegate = self
        gameController.menuView.delegate = self
        vc1 = UINavigationController(rootViewController: gameController)
        vc1.isNavigationBarHidden = true
        vc1.title = "Games"
        
        feedController = FeedViewController()
        feedController.delegate = self
        feedController.menuView.delegate = self
        vc2 = UINavigationController(rootViewController: feedController)
        vc2.isNavigationBarHidden = true
        vc2.title = "Feed"
        
        self.setViewControllers([vc1, vc2], animated: false)
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["calendar", "house.fill", "star.fill"]
        
        for index in 0 ..< items.count {
          
            items[index].image = UIImage(systemName: images[index])
            items[index].image?.withTintColor(.white)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inTransition = false
        
        updatePic()
        print("in dark mode?: \(currentUser!.settings!.dark)")
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        let navImage: UIImage? = currentUser!.settings!.dark ? UIImage() : nil

        if let nav = navigationController {
            configureNavigator (navigator: nav)
            setTitle()
        }
        
        self.view.backgroundColor = background
        self.tabBar.backgroundImage = navImage
        self.tabBar.barTintColor = UIColor(rgb: Constants.Colors.orange)
        self.tabBar.tintColor = .white
    }
    
    func updatePic() {
        if (gameController.menuView.userPhoto.image != self.userPhoto.image) {
            gameController.menuView.userPhoto.image = self.userPhoto.image
            feedController.menuView.userPhoto.image = self.userPhoto.image
        }
    }

    func configureNavigator (navigator: UINavigationController) {
        let navImage: UIImage? = currentUser!.settings!.dark ? UIImage() : nil
        navigator.navigationBar.setBackgroundImage(navImage, for: .default)
        navigator.navigationBar.barTintColor = UIColor(rgb: Constants.Colors.orange)

        navigator.navigationBar.tintColor = .white
        navigator.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigator.navigationBar.barStyle = .black
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        setTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func setTitle () {
        var title: String?
        
        switch selectedViewController {
        case vc1:
            title = "Games"
            self.navigationItem.rightBarButtonItems = [filterButton]
        case vc2:
            title = "Feed"
            self.navigationItem.rightBarButtonItems = [plusButton, filterButton]
        default:
            title = "Should not happen"
        }
        
        self.title = title
    }
    
    @objc
    func filterTransition() {
        
        if filtersVC == nil{
            filtersVC = FiltersViewController()
        }
        UI.transition(dest: filtersVC, src: self)
    }
    
    @objc
    func queueCreatePost(_ _: UIBarButtonItem) {
        if self.createPostVC == nil {
            self.createPostVC = CreatePostViewController()
        }
        self.createPostVC.delegate = self.feedController
        if let navigator = navigationController {
            navigator.pushViewController(self.createPostVC, animated: true)
        }
    }
}
