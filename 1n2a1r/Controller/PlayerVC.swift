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
import SwiftyJSON

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
        
        slider.addTarget(self, action: #selector(progressBarValueDidChange),for: [.touchUpInside, .touchUpOutside])
        slider.addTarget(self, action: #selector(progressBarValueWillChange),for: .valueChanged)

        return slider
    }()
    
    let playingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
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
    }
    
    //MARK: - handlers
    
    func setTrackName() {
        
        trackNameLabel.text = player.getTrackName()
    }
    
    func updateProgressBar() {
        
        playingTimeLabel.text = self.player.getPlayingTime()
        remainingTimeLabel.text = self.player.getRemainingTime()
        
        let position = self.player.getPosition()
        self.progressBar.setValue(position, animated: true)
        
    }
    
    @objc func progressBarValueWillChange(sender:UISlider!) {
        
        self.player.pause()
        
    }
    
    @objc func progressBarValueDidChange(sender:UISlider!) {

        let position = sender.value
        
        if position < 0.99 {
            
            self.player.setPosition(position)
            
        } else {
            
            self.player.next()
            self.player.play()
        }
    }
    
    @objc func handlePlayButton() {
        
        self.player.setPlaylistMod()
        self.player.play()
    }
    
    @objc func handleBackButton() {
        
        self.player.back()
        self.setTrackName()
    }
    
    @objc func handleNextButton() {
        
        self.player.next()
        self.setTrackName()
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
        trackNameLabel.anchor(top: nil, left: view.leftAnchor, bottom: stackView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 100, paddingRight: 10, width: 400, height: 0)
        trackNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(progressBar)
        progressBar.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 380, height: 20)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(playingTimeLabel)
        playingTimeLabel.anchor(top: progressBar.bottomAnchor, left: progressBar.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(remainingTimeLabel)
        remainingTimeLabel.anchor(top: progressBar.bottomAnchor, left: nil, bottom: nil, right: progressBar.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 35, width: 0, height: 0)
    }
    
    func fetchPlaylist(for urlString: String) {
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    
                    print("Success! Got the playlist data")
                    
                    let playlistJSON : JSON = JSON(response.result.value!)
                    print(playlistJSON)
                    self.updatePlaylist(with: playlistJSON)
                    
                }
                else {
                    
                    print("Error \(response.result.error!)")
                    
                }
        }
    }
    
    func updatePlaylist(with json: JSON) {
        
        let playlistData = json["monthly"][0]["playlist"]
        
        let newPlaylist = Playlist()
        for item in playlistData {
            
            guard let trackName = item.1["title"].string else {
                print("Failed obtain trackName string from json!")
                return
            }
            
            guard let trackUrl = item.1["url"].string else {
                print("Failed obtain trackUrl string from json!")
                return
            }
            
            let trackUrlString = LIBRARY_REF + trackUrl
            
            let encodedUrlString = trackUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: " ").inverted)

            guard let url = URL(string: encodedUrlString!) else {
                print("Failed obtain encoded url string!")
                return
            }

            let track = Track(trackName: trackName, trackUrl: url)
            newPlaylist.addTrack(track: track)
        }
        
        self.player.setPlaylist(playlist: newPlaylist)
    
    }
}
