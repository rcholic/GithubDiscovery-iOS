//
//  RepoListViewController.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON
import ObjectMapper

class RepoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    var repos: [Repository] = []
    
    // constants
    private let repoCellId = "RepoCell"
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleHeader()
        loadData()
        setupTableView()
    }
    
    private func styleHeader() {
        // set up nav bar
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0, green: 0.24, blue: 0.45, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Github Discovery"
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        textShadow.shadowOffset = CGSize(width: 0, height: 1)
        let fontAttr = UIFont(name: "HelveticaNeue-CondensedBlack", size: 25)
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(objects: [UIColor.white, textShadow, fontAttr!], forKeys: [NSForegroundColorAttributeName as NSCopying, NSShadowAttributeName as NSCopying, NSFontAttributeName as NSCopying]) as? [String : AnyObject]
    }
    
    private func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none // no default cell separator
        // register cell template
        tableView.register(UINib(nibName: repoCellId, bundle: nil), forCellReuseIdentifier: repoCellId)
        tableView.tableFooterView = UIView() // remove separator in empty cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0 // ??
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadData() {
       
        Loader.show(message: "Loading Trending Repositories...", delegate: self)
        GithubProvider.request(.trendingReposSinceLastWeek) { result in
            let context = Context() // mapping context
            result.analysis(ifSuccess: { res in
                let data = try! res.mapJSON()
//                print("result.data: \(data)")
                let resWrapper = JSON(data)
                
                self.repos = resWrapper["items"].arrayValue.map {
                    return Mapper<Repository>(context: context).map(JSON: $0.dictionaryObject!)!
                }
                self.tableView.reloadData()
                Loader.hide(delegate: self)
            }, ifFailure: { err in
                    print("error: \(err)")
                Loader.hide(delegate: self)
            })
        }
    }
}

extension RepoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoCell
        cell.bind(repo: repos[indexPath.row])
        
        return cell
    }
}

extension RepoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "RepoDetailBoard") as! RepoDetailViewController
        detailVC.curRepo = repos[indexPath.row]        
        self.present(detailVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
