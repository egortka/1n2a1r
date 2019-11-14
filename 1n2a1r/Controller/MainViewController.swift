//
//  MainViewController.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    let player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        view.backgroundColor = UIColor.white
        
        view.backgroundColor = UIColor.white
       
        configureViewControllers()
        
    }

    // create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        // home feed controller
        let playerVC = constructNavigationController(unselectedImage: #imageLiteral(resourceName: "player"), selectedImage: #imageLiteral(resourceName: "selectedPlayer"), rootViewController:  PlayerVC(player: self.player))
        
        // search feed controller
        let streamVC = constructNavigationController(unselectedImage: #imageLiteral(resourceName: "stream"), selectedImage: #imageLiteral(resourceName: "selectedStream"), rootViewController: StreamVC(player: self.player))
        
        // search feed controller
        let chatVC = constructNavigationController(unselectedImage: #imageLiteral(resourceName: "chat"), selectedImage: #imageLiteral(resourceName: "selectedChat"), rootViewController: SignUpViewController())
        
        // view controllers to be added to tab controller
        viewControllers = [playerVC, streamVC, chatVC]
        tabBar.tintColor = .black
        self.reloadInputViews()
        
    }
    
    func constructNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct navigation controller
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        
        return navigationController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            
            if Auth.auth().currentUser != nil {
                
                let chatViewController = ChatVC()
                let navigationController = UINavigationController(rootViewController: chatViewController)
                navigationController.navigationBar.tintColor = .black
                self.present(navigationController, animated: true, completion: nil)
                
                return false
            }
            
            
        }
        
        return true
    }
}
