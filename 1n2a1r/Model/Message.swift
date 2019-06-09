//
//  Message.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    // MARK: - Properties
    
    var uid: String!
    var messageText: String!
    var creationDate: Date!
    var user: User?
    
    // MARK: - Init
    
    init(with user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.user = user
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        }
        
        if let text = dictionary["messageText"] as? String {
            self.messageText = text
        }
        
        if let date = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: date)
        }
    }
    
    // MARK: - Methods
}
