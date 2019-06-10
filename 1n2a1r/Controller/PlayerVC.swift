//
//  PlayerVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let progressBar: UISlider = {
        let slider = UISlider()
        
        slider.minimumTrackTintColor = UIColor.gray
        slider.maximumTrackTintColor = UIColor.gray
        slider.thumbTintColor = .black
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.setValue(0, animated: true)
        slider.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        slider.addTarget(self, action: #selector(progressBarValueDidChange),for: .valueChanged)

        return slider
    }()
    
    let playingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "-:-"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "-:-"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - init
    
    init(player: Player) {
        
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
        
        self.player.setDelegate(self)
        
        fetchPlaylist(for: PLAYLIST_REF)
        
        configureViewComponents()
    }
    
    //MARK: - media player delegate methods
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        updateProgressBar()
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        setTrackName()
        //checkForSongFinish()
    }
    
    //MARK: - handlers
    
    func setTrackName() {
        trackNameLabel.text = player.getTrackName()
    }
    
    func updateProgressBar() {
        
        playingTimeLabel.text = self.player.getPlayingTime()
        remainingTimeLabel.text = self.player.getRemainingTime()
        
        let position = self.player.getPosition()
        let value: Float = position
        print(value)
        self.progressBar.setValue(value, animated: true)
        
        
    }
    
    @objc func progressBarValueDidChange(sender:UISlider!) {
        let position = sender.value
        self.player.setPosition(position)
    }
    
    @objc func handlePlayButton() {
        
        self.player.play()
    }
    
    @objc func handleBackButton() {
        
//        self.player.back()
        progressBar.setValue(progressBar.value + 10, animated: true)
    }
    
    @objc func handleNextButton() {
        
        self.player.next()
    }
    
    func configureViewComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [backButton, playButton, nextButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(trackNameLabel)
        trackNameLabel.anchor(top: nil, left: nil, bottom: stackView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 400, height: 0)
        trackNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(progressBar)
        progressBar.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 20)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(playingTimeLabel)
        playingTimeLabel.anchor(top: progressBar.bottomAnchor, left: progressBar.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(remainingTimeLabel)
        remainingTimeLabel.anchor(top: progressBar.bottomAnchor, left: nil, bottom: nil, right: progressBar.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 35, width: 0, height: 0)
    }
    
    private func fetchPlaylist(for urlString: String) {
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .response { response in
                if let playlistString = String(data: response.data!, encoding: .utf8) {
                    
                    print("Sucess! Got the playlist string: \(playlistString)")
                    
                    let newPlaylist = Playlist()
                    
                    let playlistStrings = playlistString.components(separatedBy: " | ")
                    
                    for item in playlistStrings {
                        
                        let trackName = item
                        let trackUrlString = LIBRARY_REF + trackName
                        let encodedUrlString = trackUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: " ").inverted)
                        
                        guard let trackUrl = URL(string: encodedUrlString!) else {
                            print("Failed obtain encoded url string!")
                            return
                        }
                        
                        let track = Track(trackName: trackName, trackUrl: trackUrl)
                        newPlaylist.addTrack(track: track)
                    }
                    
                    self.player.setPlaylist(playlist: newPlaylist)
                    
                } else {
                    print("Failed to get playlist!")
                }
        }
    }
}
