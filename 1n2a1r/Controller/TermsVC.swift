//
//  TermsVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 22/08/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit

class TermsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()

        let myWebView:UIWebView = UIWebView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        
        self.view.addSubview(myWebView)
        
        //Load web site into my web view
        let myURL = URL(string: "https://egortka.github.io/")
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        myWebView.loadRequest(myURLRequest)
    }
    
    func configureNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        self.navigationItem.title = "Back"
    }
    
    @objc func handleBackButton() {

        if let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController {
            mainViewController.selectedIndex = 0
        }
        
        self.dismiss(animated: true, completion: nil)
    }


}
