////
////  DataStore.swift
////  SpotifyServer
////
////  Created by Robert Deans on 3/25/17.
////  Copyright © 2017 Robert Deans. All rights reserved.
////
//
//import Foundation
//
//final class DataStore {
//    
//    static let shared = DataStore()
//    
//    var users = [User]()
//    
//    
//    func getUsersFromAPI(completion: @escaping () -> () ) {
//
//        APIClient.getSpotifyUsersData { (jsonData) in
//            for response in jsonData {
//                let newUser = User(herokuJSON: response)
//                print("name is \(newUser.name)")
//
//            }
//        completion()
//        }
//    }
//}
