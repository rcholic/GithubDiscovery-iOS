//
//  Repository.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 11/2/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import ObjectMapper

struct Context: MapContext {
    var importMappingInfo = "mapping github API JSON to data objects"
}

class Repository: Mappable {
    var id: Int = 0
    var description: String = ""
    var fullName: String = ""
    var language: String = ""
    var forks: Int = 0
    var stars: Int = 0
    var createdAt: NSDate?
    var owner: Owner?
    var isPrivate: Bool = false
    
    required init(map: Map) {
        self.createdAt = nil
        self.owner = nil
        self.mapping(map: map)
    }
    
    init(id: Int, description: String, fullName: String, owner: Owner,
         forks: Int, stars: Int, language: String, createdAt: NSDate?) {
        self.id = id
        self.description = description
        self.fullName = fullName
        self.forks = forks
        self.stars = stars
        self.isPrivate = false
        self.createdAt = createdAt
        self.language = language
        self.owner = owner
    }
    
     func mapping(map: Map) {
        
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
