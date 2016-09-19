//
//  Token.swift
//  bcgdv-app
//
//  Created by Hamon Riazy on 19/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import Foundation

let authorisationTokenKey = "com.ryce.bcgdv-app.userpersistencykey"

func setToken(token: String) -> Bool {
    UserDefaults.standard.set(token, forKey: authorisationTokenKey)
    return UserDefaults.standard.synchronize()
}

func getToken() -> String? {
    return UserDefaults.standard.string(forKey: authorisationTokenKey)
}
