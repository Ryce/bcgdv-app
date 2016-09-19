//
//  User.swift
//  bcgdv-app
//
//  Created by Hamon Riazy on 19/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import Foundation

let loggedInUserKey = "com.ryce.bcgdv-app.userpersistencykey"

struct User {
    var email: String? = nil
    var password: String? = nil
    let userID: String
    var avatarURLString: String? = nil
    
    var avatarURL: URL? {
        get {
            guard let avatarURLString = avatarURLString else { return nil }
            return URL(string: avatarURLString)
        }
        
        set { }
    }
    
    init(with userID: String) {
        self.userID = userID
    }
    
    public func persist() -> Bool {
        UserDefaults.standard.set(self, forKey: loggedInUserKey)
        return UserDefaults.standard.synchronize()
    }
    
    static func loggedInUser() -> User? {
        return UserDefaults.standard.value(forKey: loggedInUserKey) as? User
    }
    
}
