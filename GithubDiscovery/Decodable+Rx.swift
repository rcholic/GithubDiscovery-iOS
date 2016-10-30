//
//  Decodable+Rx.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Moya
import RxSwift
import SwiftyJSON

extension ObservableType where E == Response {
    func checkIfAuthenticated() -> Observable<E> {
        return self.map { response in
            guard response.statusCode != 403 || response.statusCode != 404 else {
                throw GithubError.notAuthenticated
            }
            return response
        }
    }
    
    func checkIfRateLimitExceeded() -> Observable<E> {
        return self.map { response -> E in
            guard let httpResponse = response.response as? HTTPURLResponse else {
                throw GithubError.generic
            }
            
            guard let remainingCount = httpResponse.allHeaderFields["X-RateLimit-Remaining"] else {
                throw GithubError.generic
            }
            
            guard (remainingCount as AnyObject).integerValue! != 0 else {
                throw GithubError.rateLimitExceeded
            }
            return response
        }
    }
}

extension ObservableType where E == Response {
    func mapToModels<T: Decodable>(_: T.Type) -> Observable<[T]> {

        return self.mapSwiftyJSON()
            .map { json -> [T] in
                guard let array = json as? [AnyObject] else {
                    throw GithubError.wrongJsonParsing
                    
                }
                return T.fromJSONArray(json: array)
        }
    }
    
    func mapToModels<T: Decodable>(_: T.Type, arrayRootKey: String) -> Observable<[T]> {
        return self.mapSwiftyJSON()
            .map { json -> [T] in
                if let dict = json as? [String : AnyObject],
                    let subJson = dict[arrayRootKey] {
                    return T.fromJSONArray(json: subJson as! [AnyObject])
                } else {
                    throw GithubError.wrongJsonParsing
                }
        }
    }
    
    func mapToModel<T: Decodable>(_: T.Type) -> Observable<T> {
        return self.mapSwiftyJSON()
            .map { json -> T in
                return T.fromJSON(json: json as AnyObject)
        }
    }
}

private extension ObservableType where E == Response {
    func mapSwiftyJSON() -> Observable<JSON> {
        return self.mapSwiftyJSON()
            .map { json in
                return JSON(json)
        }
    }
}

