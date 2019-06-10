//
//  Track.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 10/06/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Foundation

class Track {
    
    // MARK: - Properties
    
    var title: String
    var url: URL

    // MARK: - Init
    
    init(trackName: String, trackUrl: URL) {
        
        self.title = trackName
        self.url = trackUrl
    }
}
