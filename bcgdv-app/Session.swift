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
                
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                guard let userID = json["userid"] as? String,
                    let token = json["token"] as? String else {
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
    
    
    func getUser(withUserID userID: String, completion: @escaping (Result<User>) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let urlString = self.endpoint + "/users/" + userID
            guard let url = URL(string: urlString) else { fatalError("a valid URL must be provided") }
            
            let urlRequest = URLRequest(url: url)
            
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
                
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                let transactions = User() // TODO:
                
                guard transactions.count != 0 else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.parsingError))
                    }
                    return // BAIL
                }
                
                DispatchQueue.main.async {
                    completion(.success(transactions))
                }
                
            }
            
            task.resume()
        }
    }
    
    
    func updateUserAvatar(withUserID userID: String, avatar: UIImage, completion: @escaping (Result<User>) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let urlString = self.endpoint + "/users/" + userID + "/avatar"
            guard let url = URL(string: urlString) else { fatalError("a valid URL must be provided") }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
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
                
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                let transactions = User() // TODO:
                
                guard transactions.count != 0 else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.parsingError))
                    }
                    return // BAIL
                }
                
                DispatchQueue.main.async {
                    completion(.success(transactions))
                }
                
            }
            
            task.resume()
        }
    }

}
