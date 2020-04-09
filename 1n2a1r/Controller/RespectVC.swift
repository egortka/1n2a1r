//
//  RespectVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 07/04/2020.
//  Copyright © 2020 ET. All rights reserved.
//

import UIKit

class RespectVC: UIViewController {
    
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
    
    let yandexButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Yandex money", for: UIControl.State.normal)
//        button.backgroundColor = #colorLiteral(red: 1, green: 0.8078431373, blue: 0.0431372549, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.5960784314, blue: 0.03529411765, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleYandexButton), for: .touchUpInside)
        return button
    }()
    
    let patreonButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Patreon", for: UIControl.State.normal)
//        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.2588235294, blue: 0.5176470588, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.2588235294, blue: 0.5176470588, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePatreonButton), for: .touchUpInside)
        return button
    }()
    
    let sberButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Sber/Alfa", for: UIControl.State.normal)
        //        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.2588235294, blue: 0.5176470588, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7098039216, blue: 0.7843137255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSberButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - init
       override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true

        view.addSubview(yandexButton)
        yandexButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 250, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 80, height: 80)
        
        view.addSubview(patreonButton)
        patreonButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 350, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 80, height: 80)
        
        view.addSubview(sberButton)
        sberButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 450, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 80, height: 80)
        
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
    
    @objc func handleYandexButton() {
        openURL(targetUrl: YANDEX_MONEY)
    }
    
    @objc func handlePatreonButton() {
        openURL(targetUrl: PATREON)
    }
    
    @objc func handleSberButton() {
        UIPasteboard.general.string = SBER_NUMBER
        
        let alert = UIAlertController(title: "Number has been copied to clipboard", message: "Finish transaction with your bank app", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
