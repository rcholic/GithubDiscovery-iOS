//
//  NSDate+Github.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation


extension NSDate {
    convenience init(githubStr dateStr: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXX"
        
        if let date = dateFormatter.date(from: dateStr) {
            self.init(timeInterval: 0, since: date)
        } else {
            self.init()
        }
    }
}
