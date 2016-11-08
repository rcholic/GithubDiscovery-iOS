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
    
    weak var curRepo: Repository?
    var commits: [Commit] = []
    var pulls: [PullRequest] = []
    let cellIdentifier = "CommitPullCell"
    let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        populateFields()
        loadData()
    }
    
    private func setupUI() {
        spacerView.backgroundColor = CELL_SEPARATOR_COLOR
        cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        cancelButton.contentMode = .center
        
        cancelButton.setImage(cancelImage, for: .normal)
        cancelButton.tintColor = CLOSE_BTN_TINT
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(18)
            make.right.equalTo(self.view).offset(-2)
            make.width.equalTo(40)
        }
    }
    
    private func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.none // no default cell separator
        // register cell template
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView() // remove separator in empty cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40.0 // ??
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func populateFields() {
        
        guard let repo = curRepo else { return }
        
        repoName.text = repo.fullName
        repoDesc.text = repo.description
        starLabel.text = "Stars: \(repo.stars)"
        forksLabel.text = "Forked: \(repo.forks)"
        langLabel.text = "\(repo.language)"
        
        guard let repoOwner = repo.owner else { return }
        guard let avartarUrl = repoOwner.avartarUrl else { return }
        if let url = NSURL(string: avartarUrl) , let data = NSData(contentsOf: url as URL) as? Data {
            ownerAvatar.image = UIImage(data: data)
        }
        
    }
    
    @objc private func cancel() {
        self.dismiss(animated: true) { 
            self.pulls = []
            self.commits = []
        }
    }
    
    private func loadData() {
        
        guard let repo = curRepo else { return }
        guard let owner = repo.owner else { return }
        let ownerName = owner.name
        let repoName = repo.name
        let context = Context()
        Loader.show(message: "Loading Data...", delegate: self)
        GithubProvider.request(.pulls(owner: ownerName, repo: repoName)) { result in
            
            result.analysis(ifSuccess: { res in
                let data = try! res.mapJSON()
                let resWrapper = JSON(data)
                self.pulls = resWrapper.arrayValue.map {
                    return Mapper<PullRequest>(context: context).map(JSON: $0.dictionaryObject!)!
                    }.filter {
                        return $0.state == OPEN_PULLS // only show open pull requests
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
                let resWrapper = JSON(data)                
                self.commits = resWrapper.arrayValue.map {
                    return Mapper<Commit>(context: context).map(JSON: $0.dictionaryObject!)!
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
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CommitPullCell
            cell.bind(model: commits[indexPath.row])
            cell.accessoryType = .none
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Open Pull Requests: \(self.pulls.count)"
        }
        return "Commits: \(self.commits.count)"
    }
}

extension RepoDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            var pull = pulls[indexPath.row]
            print("selected pull number: \(pull.diff_url)")
            
            let targetVC = storyboard?.instantiateViewController(withIdentifier: "DiffViewBoard") as! RepoPullsDiffViewController
            targetVC.diffUrlString = pull.diff_url
            tableView.deselectRow(at: indexPath, animated: true)
//            self.navigationController?.pushViewController(targetVC, animated: true)
            self.present(targetVC, animated: true, completion: nil)
        }
    }
}
