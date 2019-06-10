//
//  Playlist.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 10/06/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Foundation
import Alamofire

class Playlist {
    
    // MARK: - Properties
    
    private var  playlist: [Track]
    
    // MARK: - Init
    
    init(with urlString: String) {
        
        self.playlist = [Track]()
        
        fetchPlaylistStrings(for: urlString) { playlistStrings in
            for item in playlistStrings {
                let track = Track(with: item)
                self.playlist.append(track)
            }
        }
    }
    
    //MARK: - Handlers
    
    private func fetchPlaylistStrings(for urlString: String, complition: @escaping([String]) -> ()) {
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .response { response in
                if let playlistString = String(data: response.data!, encoding: .utf8) {
                    
                    print("Sucess! Got the playlist string: \(playlistString)")
                    let playlistStrings = playlistString.components(separatedBy: " | ")
                    complition(playlistStrings)
                    
                } else {
                    print("Failed to get playlist!")
                }
        }
    }
    
    
}
