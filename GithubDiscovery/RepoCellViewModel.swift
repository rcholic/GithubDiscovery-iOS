//
//  RepoCellViewModel.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import RxSwift

struct RepoCellViewModel {
    let fullName: String
    let description: String
    let language: String
    let stars: String
    
    init(repo: Repo) {
        self.fullName = repo.fullName
        self.description = repo.description
        self.language = repo.language ?? ""
        self.stars = "\(repo.stars) stars"
    }
}

extension Observable {
    func mapToRepoCellViewModels() -> Observable<[RepoCellViewModel]> {
        return self.map { repos in
            if let repos  = repos as? [Repo] {
                return repos.map { return RepoCellViewModel(repo: $0) }
            } else {
                return []
            }
        }
    }
}
