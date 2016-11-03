//
//  Commit.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 11/2/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import ObjectMapper

let dateFormatter = DateFormatter()
class Commit: Mappable, BaseCellData {
    var author: String = ""
    var title: String = ""
    var date: String? = nil
    
    required init(map: Map) {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        author <- map["author.login"] // commit.author.name
        title <- map["commit.message"]
//        date <- map["committer.date"]
        if let dateStr = map["created_at"].currentValue as? String {
            let d = NSDate(githubStr: dateStr)
            date = dateFormatter.string(from: d as Date)
        }
    }
    
}
