//
//  Playlist.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 10/06/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Foundation

class Playlist {
    
    // MARK: - Properties
    
    private var  playlist = [Track]()
    
    // MARK: - Init
    
    
    //MARK: - Methods
    func addTrack(track: Track) {
        self.playlist.append(track)
    }
    
    func getTrack(number: Int) -> Track? {
        let trackNumber = Int.mod(number, playlist.count)
        print(trackNumber)
        return self.playlist[trackNumber]
    }
    
    
}
