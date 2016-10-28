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

struct Repo: BaseMappable {
    var id: Int
    var description: String
    var fullName: String
    var language: String?
    var forks: Int
    var stars: Int
    var owner: Owner
    
    //    init?(map: Map) {
    //        mapping(map: map)
    //    }
    
    
    //    init(id: Int, name: String, fullName: String) {
    //        self.id = id
    //        self.name = name
    //        self.fullName = fullName
    //    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        fullName <- map["full_name"]
        language <- map["language"]
        forks <- map["forks"]
        owner <- map["owner"]
        stars <- map["stargazers_count"]
        
    }
}
