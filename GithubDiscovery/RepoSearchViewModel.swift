//
//  RepoSearchViewModel.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

enum RepoSearchViewModelResult {
    case query([RepoCellViewModel])
    case queryNothingFound
    case empty
}

class RepoSearchViewModel {
    //inputs
    var triggerRefresh = PublishSubject<Void>()
    private var provider: MoyaProvider<Github>
    
    // outputs
    let executing: Driver<Bool>
    var results: Driver<[RepoCellViewModel]>
    
    init(provider: MoyaProvider<Github>) {
        self.provider = provider
        let activityIndicator = ActivityIndicator()
        self.executing = activityIndicator.asDriver().distinctUntilChanged()
        
        results = Variable<[RepoCellViewModel]>([]).asDriver() // init
        
//        results = triggerRefresh.startWith(())
//            .flatMapLatest {
//                provider.request(.trendingReposSinceLastWeek, completion: { (Result<Response, Error>) in
//
//                })
//            }
        
        
    }
    
    /*
    // Input
    var triggerRefresh = PublishSubject<Void>()
    var searchText = Variable("")
    var selectedItem = PublishSubject<NSIndexPath>()
    
    // Output
    let results: Driver<RepoSearchViewModelResult>
    let executing: Driver<Bool>
    let selectedViewModel: Observable<RepositoryViewModel>
    let title = "Search"
    
    private let repoModels: Variable<[Repo]>
    private let provider: MoyaProvider<Github>
    
    init(provider: MoyaProvider<Github>) {
        self.provider = provider
        
        let activityIndicator = ActivityIndicator()
        self.executing = activityIndicator.asDriver().distinctUntilChanged()
        
        let repoModels = Variable<[Repo]>([])
        self.repoModels = repoModels
        
//        results = triggerRefresh.startWith(()).flatMapLatest {
//            return provider.request(.trendingReposSinceLastWeek, completion: { (result) in
//                return result
//            })
//        }
        
        
        let searchTextObservable = searchText.asObservable()
   
        let queryResultsObservable = searchTextObservable
            .throttle(0.3, scheduler: MainScheduler.instance)
            .filter { $0.characters.count > 0 }
            .flatMapLatest { query in
                provider.request(repoSearch, completion: <#T##Completion##Completion##(Result<Response, Error>) -> ()#>)
                provider.request(Github.repoSearch(query: query))
                    .retry(3)
                    .trackActivity(activityIndicator)
                    .observeOn(MainScheduler.instance)
            }
            .mapToModels(Repo.self, arrayRootKey: "items")
            .doOnNext { models in
                repoModels.value = models
            }
            .mapToRepoCellViewModels()
            .map { viewModels -> RepoSearchViewModelResult in
                viewModels.isEmpty ? .QueryNothingFound : .Query(viewModels)
            }
            .asDriver(onErrorJustReturn: .QueryNothingFound)
 
        
        let noResultsObservable = searchTextObservable
            .filter { $0.characters.isEmpty }
            .map { _ -> RepoSearchViewModelResult in
                .empty
            }
            .asDriver(onErrorJustReturn: .empty)
        
        results = Driver.of(queryResultsObservable, noResultsObservable).merge()
 
        selectedViewModel = selectedItem
            .withLatestFrom(repoModels.asObservable()) { indexPath, models in
                models[indexPath.row]
            }
            .map { model in
//                RepositoryViewModel(provider: provider, repo: model)
            }
            .shareReplay(1)
    }
 
 */
 
}
