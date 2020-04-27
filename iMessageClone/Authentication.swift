//
//  Authentication.swift
//  iMessageClone
//
//  Created by Matheus Cardoso on 4/20/20.
//  Copyright © 2020 Stream.io. All rights reserved.
//

import Foundation

struct AuthRequest: Codable {
    let appleUid: String
    let appleAuthCode: String
    let name: String?
    
    func encoded() -> Data {
        try! JSONEncoder().encode(self)
    }
}

struct AuthResponse: Codable {
    let apiKey: String
    let streamId: String
    let streamToken: String
    let email: String
    let name: String?
    
    init?(data: Data) {
        guard let res = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
            return nil
        }
        
        self = res
    }
}

func authenticate(request: AuthRequest,
                  completion: @escaping (AuthResponse?, String?) -> Void) {
    var urlReq = URLRequest(url: URL(string: "http://192.168.0.11:4000/authenticate")!)
    urlReq.httpBody = request.encoded()
    urlReq.httpMethod = "POST"
    urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
    
    URLSession.shared.dataTask(with: urlReq) { data, response, error in
        switch (response as? HTTPURLResponse)?.statusCode ?? -1 {
        case 200: break
        case 401: return completion(nil, "Apple did not confirm your identity")
        case 404: return completion(nil, "User not registered. Remove this app's entry in Settings > Apple ID > Security & Password > Apple ID logins and try again.")
        default: 
            let error = error?.localizedDescription ?? "Unknown error"
            return completion(nil, "\(error)")
        }
        
        guard let data = data, let res = AuthResponse(data: data) else {
            completion(nil, "Could not decode auth response")
            return
        }
        
        completion(res, nil)
    }.resume()
}
