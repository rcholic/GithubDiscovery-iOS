//
//  PullRequest.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import ObjectMapper

class PullRequest: Mappable {
    var title: String = ""
    var author: String = "Unknown"
    var date: NSDate?
    
    required init(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        author <- map["user.login"] // nested json field "login"
        date <- map["createdAt"]
    }
}
