//
//  RepoDetailViewController.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 11/2/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON
import ObjectMapper

class RepoDetailViewController: UIViewController {
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDesc: UILabel!
    @IBOutlet weak var spacerView: UIView!    
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var ownerAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var curRepo: Repository?
    var commits: [Commit] = []
    var pulls: [PullRequest] = []
    let cellIdentifier = "CommitPullCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        populateFields()
        loadData()
    }
    
    private func setupUI() {
        spacerView.backgroundColor = CELL_SEPARATOR_COLOR
        
    }
    
    private func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.none // no default cell separator
        // register cell template
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView() // remove separator in empty cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40.0 // ??
//        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func populateFields() {
        
        guard let repo = curRepo else { return }
        
        repoName.text = repo.fullName
        repoDesc.text = repo.description
        starLabel.text = "Stars: \(repo.stars)"
        forksLabel.text = "Forked: \(repo.forks)"
        langLabel.text = "\(repo.language)"
        if let owner = repo.owner {
            if let avatarUrl = owner.avartarUrl {
                if let url = NSURL(string: avatarUrl) {
                    if let data = NSData(contentsOf: url as URL) {
                        ownerAvatar.image = UIImage(data: data as Data)
                    }
                }
            }
        }
    }
    
    private func loadData() {
        
        guard let repo = curRepo else { return }
        guard let owner = repo.owner else { return }
        let ownerName = owner.name // "magicalpanda" // TODO: owner.name
        let repoName = repo.name // "MagicalRecord" // TODO: repo.name
        print("repo full name: \(repo.fullName), ownername: \(owner.name)")
        let context = Context() // mapping context
        
        GithubProvider.request(.pulls(owner: ownerName, repo: repoName)) { result in
            
            result.analysis(ifSuccess: { res in
                let data = try! res.mapJSON()
//                print("result.data: \(data)")
                let resWrapper = JSON(data)
//                print("pulls resWrapper: \(resWrapper)")
                self.pulls = resWrapper.arrayValue.map {
                    return Mapper<PullRequest>(context: context).map(JSON: $0.dictionaryObject!)!
                }
                self.tableView.reloadData()
                self.pulls.forEach {
                    print("pulls' title: \($0.title)")
                }
                }, ifFailure: { err in
                    print("error: \(err)")
            })
        }
        
        GithubProvider.request(.commits(owner: ownerName, repo: repoName)) { result in

            result.analysis(ifSuccess: { res in
                let data = try! res.mapJSON()
//                print("result.data: \(data)")
                let resWrapper = JSON(data)
//                print("commits resWrapper: \(resWrapper)")
                
                self.commits = resWrapper.arrayValue.map {
                    return Mapper<Commit>(context: context).map(JSON: $0.dictionaryObject!)!
                }
                self.tableView.reloadData()
                }, ifFailure: { err in
                    print("error: \(err)")
            })
            
        }
    }
}

extension RepoDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pulls.count
            
        case 1:
            return commits.count
            
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CommitPullCell
            cell.bind(model: pulls[indexPath.row])
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CommitPullCell
            cell.bind(model: commits[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pull Requests: \(self.pulls.count)"
        }
        return "Commits: \(self.commits.count)"
    }

}
