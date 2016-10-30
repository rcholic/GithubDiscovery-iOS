//
//  Owner.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import ObjectMapper

struct Owner: Mappable {
    var id: Int
    var name: String
    var fullName: String
    
        init?(map: Map) {
            self.id = 0
            self.name = "name"
            self.fullName = "full"
            mapping(map: map)
        }
    
    
        init(id: Int, name: String, fullName: String) {
            self.id = id
            self.name = name
            self.fullName = fullName
        }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["login"]
        fullName <- map["full_name"]
    }
}

