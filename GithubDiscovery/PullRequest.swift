//
//  PullRequest.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import ObjectMapper

struct PullRequest: BaseMappable {
    var title: String
    var author: String
    var date: NSDate // ?? or String ?
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        author <- map["user"]["login"] // okay??
        date <- map["createdAt"]
    }
}
