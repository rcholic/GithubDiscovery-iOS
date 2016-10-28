//
//  GithubAPI.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import Moya
import RxSwift

let GithubProvider = MoyaProvider<Github>(endpointClosure: endpointClosure)

public enum Github {
    case token(username: String, password: String)
    case repoSearch(query: String)
    case trendingReposSinceLastWeek
    case repo(owner: String, repoName: String)
    case repoReadMe(owner: String, repoName: String)
    case pulls(onwer: String, repo: String)
    case issues(onwer: String, repo: String)
    case commits(onwer: String, repo: String)
}

extension Github: TargetType {
    
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    public var path: String {
        switch self {
        case .token(_, _):
            return "/authorizations"
        case .repoSearch(_),
             .trendingReposSinceLastWeek:
            return "/search/repositories"
        case .repo(let owner, let repoName):
            return "/repos\(owner)/\(repoName)"
        case .repoReadMe(let owner, let repoName):
            return "/repos\(owner)/\(repoName)/readme"
        case .pulls(let owner, let repo):
            return "/repos\(owner)/\(repo)/pulls"
        case .issues(let owner, let repo):
            return "/repos\(owner)/\(repo)/issues"
        case .commits(let owner, let repo):
            return "/repos\(owner)/\(repo)/commits"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .repoSearch(_), .repo(_, _), .pulls(_, _):
            return .GET
            
        default:
            return .GET
            
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
            
        case .repo(_,_),
             .repoReadMe(_,_),
             .pulls,
             .issues,
             .commits:
            return nil
        case .repoSearch(let query):
            return ["q": query.URLEscapedString as AnyObject]
            
        default:
            return nil
        }
        
        
    }
    
    public var task: Task {
        return .request
    }
    
    public var sampleData: Data {
        switch self {
        case .repoSearch(_):
            return "{\"result\": nothing returned}".data(using: String.Encoding.utf8)!
        default:
            return "no result".data(using: String.Encoding.utf8)!
        }
    }
    
    public var target: TargetType {
        switch self {
        case .issues(_, _):
            return self
        default:
            return self
        }
    }
}

var endpointClosure = { (target: Github) -> Endpoint<Github> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint: Endpoint<Github> = Endpoint(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
    
    //    switch target {
    //    /*
    //    case .Token(let userString, let passwordString):
    //        let credentialData = "\(userString):\(passwordString)".data(using: String.Encoding.utf8)!
    //        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    //        return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": "Basic \(base64Credentials)"])
    //            .endpointByAddingParameterEncoding(.JSON)
    //    default:
    //        let appToken = Token()
    //        guard let token = appToken.token else {
    //            return endpoint
    //        }
    //        return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": "token \(token)"])
    //        */
    ////    default:
    ////        return endpoint.endpointByAddingParameterEncoding()
    //    }
    return endpoint
}

private extension String {
    var URLEscapedString: String {
        
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)!
    }
}
