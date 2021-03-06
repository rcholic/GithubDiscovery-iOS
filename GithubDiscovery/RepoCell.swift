//
//  RepoCell.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 10/28/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var repoName: UILabel!
    
    @IBOutlet weak var repoDesc: UILabel!

    @IBOutlet weak var author: UILabel!
   
    @IBOutlet weak var stars: UILabel!
    
    @IBOutlet weak var language: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCellUI() {
        contentView.backgroundColor = CELL_SEPARATOR_COLOR
        //        containerView.snp.makeConstraints { (make) in
        //            make.top.right.left.equalTo(self.contentView)
        //            make.bottom.equalTo(self.contentView.snp.bottom)
        //        }
        //        containerView.clipsToBounds = true
    }
    
    func bind(repo: Repository) {
        let authorName = repo.owner == nil ? "Unknown" : repo.owner!.name
        self.repoName.text = "\(repo.fullName)"
        self.repoDesc.text = "Description: \(repo.description)"        
        self.author.text = "Author: \(authorName)"
        self.stars.text = "\(repo.stars) stars"
        self.language.text = repo.language 
    }
}
