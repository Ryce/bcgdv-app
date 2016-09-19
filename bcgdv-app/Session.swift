//
//  Session.swift
//  bcgdv-app
//
//  Created by Hamon Riazy on 19/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

enum SessionError: Error {
    case networkFailure(String)
    case jsonParsingError
    case parsingError
    case imageParsingError
    case tokenPresistencyError
    case tokenNotAvailableError
}

struct Session {
    let endpoint = ""
    
    func createSession(parameters: [String : String], completion: @escaping (Result<User>) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let urlString = self.endpoint + "/sessions/new"
            guard let url = URL(string: urlString) else { fatalError("a valid URL must be provided") }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completion(.failure(error))
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return // BAIL
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.networkFailure("No Data provided")))
                    }
                    return // BAIL
                }
                
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : String] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                guard let userID = json["userid"],
                    let token = json["token"] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                guard setToken(token: token) else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.tokenPresistencyError))
                    }
                    return // BAIL
                }
                
                let user = User(with: userID)
                
                DispatchQueue.main.async {
                    completion(.success(user))
                }
                
            }
            
            task.resume()
        }
    }
    
    
    func getUser(withUser user: User, completion: @escaping (Result<User>) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let urlString = self.endpoint + "/users/" + user.userID
            guard let url = URL(string: urlString) else { fatalError("a valid URL must be provided") }
            
            var urlRequest = URLRequest(url: url)
            
            guard let token = getToken() else {
                DispatchQueue.main.async {
                    completion(.failure(SessionError.tokenNotAvailableError))
                }
                return // BAIL
            }
            
            urlRequest.allHTTPHeaderFields = ["Bearer":token]
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return // BAIL
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.networkFailure("No Data provided")))
                    }
                    return // BAIL
                }
                
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : String],
                    let avatarURLString = json["avatar_url"],
                    let email = json["email"] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                var mutableUser = user
                mutableUser.avatarURLString = avatarURLString
                mutableUser.email = email
                
                DispatchQueue.main.async {
                    completion(.success(mutableUser))
                }
                
            }
            
            task.resume()
        }
    }
    
    
    func updateUserAvatar(withUser user: User, avatar: UIImage, completion: @escaping (Result<User>) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let urlString = self.endpoint + "/users/" + user.userID + "/avatar"
            guard let url = URL(string: urlString) else { fatalError("a valid URL must be provided") }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            guard let token = getToken() else {
                DispatchQueue.main.async {
                    completion(.failure(SessionError.tokenNotAvailableError))
                }
                return // BAIL
            }
            
            urlRequest.allHTTPHeaderFields = ["Bearer":token]
            
            guard let imageData = UIImageJPEGRepresentation(avatar, 0.8) else {
                completion(.failure(SessionError.imageParsingError))
                return
            }
            
            let jsonData = ["avatar": imageData.base64EncodedString()]
            
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            } catch {
                completion(.failure(error))
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return // BAIL
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.networkFailure("No Data provided")))
                    }
                    return // BAIL
                }
                
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : String],
                    let avatarURLString = json["avatar_url"] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                var mutableUser = user
                mutableUser.avatarURLString = avatarURLString
                
                DispatchQueue.main.async {
                    completion(.success(mutableUser))
                }
                
            }
            
            task.resume()
        }
    }

}
