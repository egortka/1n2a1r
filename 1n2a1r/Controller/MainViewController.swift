//
//  MainViewController.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.title = "Downloads"
        
        view.backgroundColor = UIColor.white
        
        configureViewControllers()
        
        checkUserIsLoggedIn()
    }
    
    
    // create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        // home feed controller
        let feedViewController = constructNavigationController(unselectedImage: #imageLiteral(resourceName: "logo_black"), selectedImage: #imageLiteral(resourceName: "logo_black"), rootViewController:  DummyViewController())
        
        // search feed controller
        let searchViewController = constructNavigationController(unselectedImage: #imageLiteral(resourceName: "logo_black"), selectedImage: #imageLiteral(resourceName: "logo_black"), rootViewController: DummyViewController())
        
        // search feed controller
        let searchViewController2 = constructNavigationController(unselectedImage: #imageLiteral(resourceName: "logo_black"), selectedImage: #imageLiteral(resourceName: "logo_black"), rootViewController: DummyViewController())
        
        // view controllers to be added to tab controller
        viewControllers = [feedViewController, searchViewController, searchViewController2]
        tabBar.tintColor = .black
        
    }
    
    func constructNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct navigation controller
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.tintColor = .black
        
        return navigationController
    }
    
    func checkUserIsLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                // present log in screen
                let navigationController = UINavigationController(rootViewController: LoginViewController())
                self.present(navigationController, animated: true, completion: nil)
            }
        }
        
    }

}
