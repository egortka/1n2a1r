//
//  Player.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 10/06/2019.
//  Copyright © 2019 ET. All rights reserved.
//

class Player {
    
    // MARK: - Properties
    let player = VLCMediaPlayer()
    var playList: Playlist
    
    // MARK: - Init
    
    init(with playList: Playlist) {
        
        self.playList = playList
    }
    
    //MARK: - Handlers
    
    func play() {
    }
    
    func back() {
        
    }
    
    func next() {
        
    }
    
    
    
}
