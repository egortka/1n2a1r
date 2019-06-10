//
//  PlayerVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import Firebase

class PlayerVC: UIViewController, VLCMediaPlayerDelegate {

    // MARK: - properties
    
    var player: Player
    
    
    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "logo_black").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "next").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "previous").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Turbo mix 3000"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let progressBar: UISlider = {
        let slider = UISlider()
        
        slider.minimumTrackTintColor = UIColor.gray
        slider.maximumTrackTintColor = UIColor.gray
        slider.thumbTintColor = .black
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.setValue(0, animated: true)
        slider.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        return slider
    }()
    
    let startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2:22"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "1:22"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - init
    
    init(with player: Player) {
        
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "1n2a1r playlist"
        
        configureViewComponents()
    }
    
    //MARK: - handlers
    
    func configureViewComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [backButton, playButton, nextButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(trackNameLabel)
        trackNameLabel.anchor(top: nil, left: nil, bottom: stackView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
        trackNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(progressBar)
        progressBar.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 20)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(startTimeLabel)
        startTimeLabel.anchor(top: progressBar.bottomAnchor, left: progressBar.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(endTimeLabel)
        endTimeLabel.anchor(top: progressBar.bottomAnchor, left: nil, bottom: nil, right: progressBar.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 35, width: 0, height: 0)
    }
    
    
    @objc func handlePlayButton() {
        
        player.play()
    }
    
    @objc func handleBackButton() {
        
        player.back()
    }
    
    @objc func handleNextButton() {
        
        player.next()
    }
}
