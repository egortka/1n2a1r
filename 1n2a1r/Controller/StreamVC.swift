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
    
    var mediaPlayer = VLCMediaPlayer()
    var isPlaing = false
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Live stream"
        
        mediaPlayer.delegate = self
        let url = STREAM_REF
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: " ").inverted)
        mediaPlayer.media = VLCMedia(url: URL(string: encodedUrl!)!)
        
        view.addSubview(playButton)
        playButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK: - handlers
    @objc func handlePlayButton() {
        if isPlaing {
            mediaPlayer.stop()
            isPlaing = false
        } else {
            mediaPlayer.play()
            isPlaing = true
        }
        
    }
}
