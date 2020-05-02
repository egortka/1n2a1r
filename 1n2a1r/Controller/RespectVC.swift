//
//  RespectVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 07/04/2020.
//  Copyright © 2020 ET. All rights reserved.
//

import UIKit

class RespectVC: UIViewController {
    
    var respectButton1: RespectButton?
    var respectButton2: RespectButton?
    var respectButton3: RespectButton?
    
    let backButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("BACK", for: UIControl.State.normal)
        button.backgroundColor = .black
        button.layer.opacity = 0.8
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    let button1: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("button1", for: UIControl.State.normal)
//        button.backgroundColor = #colorLiteral(red: 1, green: 0.8078431373, blue: 0.0431372549, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.5960784314, blue: 0.03529411765, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleButton1), for: .touchUpInside)
        return button
    }()
    
    let button2: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("button2", for: UIControl.State.normal)
//        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.2588235294, blue: 0.5176470588, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.2588235294, blue: 0.5176470588, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleButton2), for: .touchUpInside)
        return button
    }()
    
    let button3: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("button3", for: UIControl.State.normal)
        //        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.2588235294, blue: 0.5176470588, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7098039216, blue: 0.7843137255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleButton3), for: .touchUpInside)
        return button
    }()
    
    //MARK: - init
       override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let button = respectButton1 {
            button1.setTitle(button.title, for: UIControl.State.normal)
        }
        
        if let button = respectButton2 {
            button2.setTitle(button.title, for: UIControl.State.normal)
        }
        
        if let button = respectButton3 {
            button3.setTitle(button.title, for: UIControl.State.normal)
        }
        
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true

        view.addSubview(button1)
        button1.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: view.frame.height * 0.25, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 80, height: 80)
        
        view.addSubview(button2)
        button2.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: view.frame.height * 0.25 + 100, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 80, height: 80)
        
        view.addSubview(button3)
        button3.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: view.frame.height * 0.25 + 200, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 80, height: 80)
        
        view.addSubview(backButton)
        backButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
    }
    
    //MARK: - handlers
    func openURL(targetUrl: String) {
        if let url = URL(string: targetUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleButton1() {
        if let url = respectButton1?.url {
            openURL(targetUrl: url)
        }
    }
    
    @objc func handleButton2() {
        if let url = respectButton2?.url {
            openURL(targetUrl: url)
        }
    }
    
    @objc func handleButton3() {
        UIPasteboard.general.string = NUMBER
        
        if let text = respectButton3?.url {
            let alert = UIAlertController(title: "Number has been copied to clipboard", message: text, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
