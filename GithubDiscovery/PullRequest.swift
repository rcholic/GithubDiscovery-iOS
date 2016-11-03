//
//  PullRequest.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol BaseCellData {
    var date: String? { get set }
    var title: String { get set }
    var author: String { get set }
}

class PullRequest: Mappable, BaseCellData {
    var number: Int = 0 // pull number
    var title: String = ""
    var author: String = "Unknown"
    var html_url: String = ""
    var diff_url: String = ""
    var patch_url: String = ""
    var date: String? = nil
    
    required init(map: Map) {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        number <- map["number"]
        title <- map["title"]
        author <- map["user.login"] // nested json field "login"
        html_url <- map["html_url"]
        diff_url <- map["diff_url"]
        patch_url <- map["patch_url"]
        if let dateStr = map["created_at"].currentValue as? String {
            let d = NSDate(githubStr: dateStr)
            date = dateFormatter.string(from: d as Date)
        }
    }
}
