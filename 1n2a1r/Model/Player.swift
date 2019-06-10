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
    var playlist: Playlist
    
    // MARK: - Init
    
    init(with playlist: Playlist) {
        
        self.playlist = playlist
        self.player.media = VLCMedia(url: playlist.getTrack(number: 0).url)
    }
    
    //MARK: - Handlers
    
    func play() {
        player.play()
    }
    
    func back() {
        
    }
    
    func next() {
        
    }
    
    
    
}
