//
//  Repo.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import SwiftyJSON
//import ObjectMapper

struct Repo: Decodable {
    var id: Int
    var description: String
    var fullName: String
    var language: String
    var forks: Int
    var stars: Int
    var createdAt: NSDate?
    var owner: Owner
    var isPrivate: Bool
    
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
    
    static func fromJSON(json: AnyObject) -> Repo {
        let json = JSON(json)
        let id = json["id"].intValue
        let createdAt = NSDate(githubStr: json["created_at"].stringValue)
        let fullName = json["full_name"].stringValue
        let description = json["description"].stringValue
        let language = json["language"].string ?? ""
        let stars = json["stargazers_count"].intValue
        let forks = json["forks"].intValue
        let owner = Owner.fromJSON(json: json["onwer"].object as AnyObject)
        
        return Repo(id: id,
                    description: description,
                    fullName: fullName,
                    owner: owner,
                    forks: forks,
                    stars: stars,
                    language: language,
                    createdAt: createdAt)
    }
    /*
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
    */
}
