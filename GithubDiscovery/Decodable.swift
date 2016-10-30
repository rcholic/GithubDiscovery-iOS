//
//  Decodable.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation

protocol Decodable {
    static func fromJSON(json: AnyObject) -> Self
}

extension Decodable {
    static func fromJSONArray(json: [AnyObject]) -> [Self] {
        return json.map { Self.fromJSON(json: $0) }
    }
}
