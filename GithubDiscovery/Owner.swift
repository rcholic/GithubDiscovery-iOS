//
//  Owner.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import ObjectMapper

class Owner: Mappable {
    var id: Int = 0
    var name: String = ""
    var fullName: String = ""
    
    required init(map: Map) {
        self.mapping(map: map)
    }
    
    init(id: Int, name: String, fullName: String) {
        self.id = id
        self.name = name
        self.fullName = fullName
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["login"]
        fullName <- map["full_name"]
    }
    
}

