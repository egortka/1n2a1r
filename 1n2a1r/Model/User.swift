//
//  User.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 12/03/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Firebase

class User {
    
    // MARK: - Properties
    
    var username: String!
    var profileImageUrl: String!
    var uid: String!
    
    // MARK: - Init
    
    init(uid: String, dictionart: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let username = dictionart["username"] as? String {
            self.username = username
        }
        
        if let profileImageUrl = dictionart["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        }
        
    }
    
    //MARK: - Methods
    
}
