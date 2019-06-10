//
//  Player.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 10/06/2019.
//  Copyright © 2019 ET. All rights reserved.
//

class Player {
    
    // MARK: - Properties
    private let player = VLCMediaPlayer()
    private var playlist: Playlist?
    private var currentTrack = 0
    
    // MARK: - Init

    
    //MARK: - Methods
    
    func setPlaylist(playlist: Playlist) {
        
        self.playlist = playlist
        setTrack(number: 0)
    }
    
    func play() {
        if !self.player.isPlaying {
            self.player.play()
        } else {
            self.player.pause()
        }
        
    }
    
    func back() {
        
        let isPlaying = self.player.isPlaying
        setTrack(number: currentTrack - 1)
        if isPlaying {
            self.player.play()
        }
    }
    
    func next() {
        
        let isPlaying = self.player.isPlaying
        setTrack(number: currentTrack + 1)
        if isPlaying {
            self.player.play()
        }
    }
    
    func getTrackName() -> String {
        
        let trackNameString = self.player.media.metadata(forKey: VLCMetaInformationTitle)
        let trackName = trackNameString.replacingOccurrences(of: ".mp3", with: "")
        
        return trackName
    }
    
    func getPlayingTime() -> String {
        
        let seconds = self.player.time.intValue / 1000
        let timeString = VLCTime.getString(seconds: seconds)
        return timeString
    }
    
    func getRemainingTime() -> String {
        
        let seconds = self.player.media.length.intValue / 1000 - self.player.time.intValue / 1000
        let timeString = VLCTime.getString(seconds: seconds)
        
        return timeString
    }
    
    func getPosition() -> Float {
        
        let position = self.player.position
        print(position)
        return position
    }
    
    func setPosition(_ position: Float) {
        
        self.player.position = position
        self.player.play()
    }
    
    private func setTrack(number: Int) {
        
        guard let track = self.playlist?.getTrack(number: number) else { return }
        self.player.media = VLCMedia(url: track.url)
        self.currentTrack = number
    }
    
    func setDelegate(_ delegate: VLCMediaPlayerDelegate) {
        
        self.player.delegate = delegate
    }
    
    
    
}
