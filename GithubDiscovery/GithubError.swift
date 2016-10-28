//
//  GithubError.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation

enum GithubError: Error {
    case rateLimitExceeded
    case notAuthenticated
    case wrongJsonParsing
    case generic
}

