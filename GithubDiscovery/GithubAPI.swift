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
    case pulls(owner: String, repo: String)
    case issues(owner: String, repo: String)
    case commits(owner: String, repo: String)
}

extension Github: TargetType {
    
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    public var path: String {
        switch self {
        case .token(_, _):
            return "/authorizations"
        case .repoSearch(_),
             .trendingReposSinceLastWeek:
            return "search/repositories"
        case .repo(let owner, let repoName):
            return "/repos/\(owner)/\(repoName)"
        case .repoReadMe(let owner, let repoName):
            return "/repos/\(owner)/\(repoName)/readme"
        case .pulls(let owner, let repo):
            return "/repos/\(owner)/\(repo)/pulls"
        case .issues(let owner, let repo):
            return "/repos/\(owner)/\(repo)/issues"
        case .commits(let owner, let repo):
            return "/repos/\(owner)/\(repo)/commits"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .repoSearch(_), .repo(_, _), .pulls(_, _), .commits(_, _), .trendingReposSinceLastWeek:
            return .GET
            
        default:
            return .GET
            
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "token \(GITHUB_TOKEN)"]
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
            
        case .trendingReposSinceLastWeek:
            return ["q": "ios"]
            
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
        case .issues(_, _), .trendingReposSinceLastWeek, .pulls(_, _), .commits(_, _):
            return self
        default:
            return self
        }
    }
}

var endpointClosure = { (target: Github) -> Endpoint<Github> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint: Endpoint<Github> = Endpoint(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
    
    print("end point closure")
    
        switch target {
            
        case .trendingReposSinceLastWeek, .commits, .pulls:
            return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": "token \(GITHUB_TOKEN)"])
 
        default:
            return endpoint.endpointByAddingParameterEncoding(JSONEncoding())
        }
//    return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": "token \(GITHUB_TOKEN)"])
}

private extension String {
    var URLEscapedString: String {
        
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)!
    }
}
