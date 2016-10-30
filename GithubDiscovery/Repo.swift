//
//  Repo.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
//import SwiftyJSON
import ObjectMapper

struct Repo: Mappable {
    var id: Int
    var description: String
    var fullName: String
    var language: String?
    var forks: Int
    var stars: Int
    var owner: Owner?
    var isPrivate: Bool
    
    init(id: Int, description: String, fullName: String,
         forks: Int, stars: Int) {
        self.id = id
        self.description = description
        self.fullName = fullName
        self.forks = forks
        self.stars = stars
        self.isPrivate = false
//        self.language = ""
//        self.owner = nil
    }
    
    init?(map: Map) {
//        self.id = map["id"] as
//        self.description = map["description"]
        self.fullName = ""
        self.language = ""
        self.forks = 0
        self.stars = 0
        self.owner = nil
        self.isPrivate = false
        
        self.mapping(map: map)
    }
    
//    init?(JSON: [String: Any]?) {
//        if JSON == nil {
//            return
//        }
//        self.mapping(map: <#T##Map#>)
//    }
    
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        fullName <- map["full_name"]
        language <- map["language"]
        forks <- map["forks"]
        owner <- map["owner"]
        stars <- map["stargazers_count"]
        isPrivate <- map["private"]
        
    }
}
