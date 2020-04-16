//
//  StreamVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import AVFoundation

class StreamVC: UIViewController, VLCMediaPlayerDelegate {

    // MARK: - properties
    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "logo_black").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        button.layer.shadowColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.0
        button.layer.shadowOffset = .zero
        return button
    }()
    
    let respectButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("SEND RESPECT", for: UIControl.State.normal)
        button.backgroundColor = .black
        button.layer.opacity = 0.8
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleRespectButton), for: .touchUpInside)
        return button
    }()
    
    var player: Player
    var isPlaing = false
    
    //MARK: - init
    
    init(player: Player) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
        self.player.setDelegate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true

        let url = STREAM_REF
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: " ").inverted)
        guard let streamURL = URL(string: encodedUrl!) else { return }
        self.player.setLiveStreamURL(streamURL: streamURL)
        self.player.setLiveStreamMod()
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: nil)

        
        view.addSubview(playButton)
        playButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(respectButton)
        respectButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 320, height: 80)
    }
    
    //MARK: - handlers
    
    @objc func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        // Switch over the interruption type.
        switch type {
            
        case .began:
            handlePause()
            
        case .ended:
            handlePlay()
            
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                handlePlay()
            } else {
                handlePlay()
            }
            
        default: ()
        }
    }
    
    
    @objc func handlePlayButton() {
        
        if isPlaing {
            handlePause()
        } else {
            handlePlay()
        }
    }
    
    func handlePlay() {
        self.player.play()
        playButton.layer.shadowOpacity = 1
        isPlaing = true
    }
    
    func handlePause() {
        self.player.pause()
        playButton.layer.shadowOpacity = 0
        isPlaing = false
    }

    @objc func handleRespectButton() {
        let nextViewController = RespectVC()
        if let navigationController = self.navigationController {
                navigationController.pushViewController(nextViewController, animated: true)
        }
    }
//
//    // MARK: - VLCMediaPlayerDelegate
//    func mediaPlayerStateChanged(_ aNotification: Notification!) {
//        print("------------------------------")
//        print(VLCMediaPlayerStateToString(self.player.getState()))
//        print(self.player.getChannel())
//    }
}
