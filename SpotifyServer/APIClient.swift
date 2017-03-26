//
//  APIClient.swift
//
//
//  Created by Robert Deans on 3/25/17.
//
//

import Foundation

class APIClient {
    
    class func getSpotifyUsersData(branch: String, not: Bool, nameOrID: String?, completion: @escaping ([[String:Any]]) -> Void) {
        
        var rootLink = "https://secret-lake-19671.herokuapp.com/\(branch)/"
        

        if nameOrID != nil && nameOrID != "" {
            if not {
                rootLink = rootLink + "/not/" + nameOrID!
            } else {
                rootLink = rootLink + nameOrID!
            }
        } else if nameOrID == "" {
            rootLink = "https://secret-lake-19671.herokuapp.com/people/"
        }
        // forced unwrapping bad practice, but did safeguard above!
        
        guard let url = URL(string: rootLink) else { print("trouble unwrapping url"); return }
        
        print("url = \(url.absoluteString)")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { print("error unwrapping data"); return }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String:Any]]
                completion(responseJSON)
            } catch {
                print("ERROR: \(error)")
            }
        }
        dataTask.resume()
        
    }
    
    class func putSpotifyUserData(user: User, newName: String?, newCity: String?) {
    
        var newUser = user
        
        if newName != nil {
            newUser.name = newName!
        }
        
        if newCity != nil {
            newUser.favoriteCity = newCity!
        }
        
        let dict = ["name": newUser.name, "favoritecity": newUser.favoriteCity] as [String: Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        
        let rootLink = "https://secret-lake-19671.herokuapp.com/people/\(user.id)"
        
        guard let url = URL(string: rootLink) else { print("trouble unwrapping url"); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("User posted: status code = \(httpResponse.statusCode)")
            }
        }
        task.resume()
        
    }
    
    class func postSpotifyUserData(name: String, city: String) {
        let dict = ["name": name, "favoritecity": city] as [String: Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        let rootLink = "https://secret-lake-19671.herokuapp.com/people/"
        guard let url = URL(string: rootLink) else { print("trouble unwrapping url"); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("User posted: status code = \(httpResponse.statusCode)")
            }
        }
        task.resume()
        
    }
    
    class func deleteSpotifyUserData(userID: Int) {
        let rootLink = "https://secret-lake-19671.herokuapp.com/people/\(userID)"
        
        guard let url = URL(string: rootLink) else { print("trouble unwrapping url"); return }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("User deleted: status code = \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
    
}
