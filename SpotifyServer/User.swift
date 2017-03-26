//
//  User.swift
//  SpotifyServer
//
//  Created by Robert Deans on 3/25/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import Foundation

struct User {
    
    var name: String
    var favoriteCity: String
    let id: Int
    
    init(herokuJSON: [String:Any]) {

        guard let name = herokuJSON["name"] as? String,
            let favoriteCity = herokuJSON["favoritecity"] as? String,
            let id = herokuJSON["id"] as? Int
        
            else { fatalError() }
        
        self.name = name
        self.favoriteCity = favoriteCity
        self.id = id
    }

}

enum Branch {
    case name, city, id
}
