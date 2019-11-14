//
//  StreamVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import Firebase

class StreamVC: UIViewController, VLCMediaPlayerDelegate {

    // MARK: - properties
    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "logo_black").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        return button
    }()
    
    var player: Player
    var isPlaing = false
    
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
        self.navigationItem.title = "Live stream"

        let url = "http://stream.dancewave.online:8080/dance.ogg" //STREAM_REF
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: " ").inverted)
        
        guard let streamURL = URL(string: encodedUrl!) else { return }
        self.player.setLiveStreamURL(streamURL: streamURL)
        
        view.addSubview(playButton)
        playButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK: - handlers
    @objc func handlePlayButton() {
        
        self.player.setLiveStreamMod()
        self.player.play()
        
//        if isPlaing {
//            self.player.pause()
//            isPlaing = false
//        } else {
//            player.pause()
//            self.player.play()
//            isPlaing = true
//        }
        
    }
}
