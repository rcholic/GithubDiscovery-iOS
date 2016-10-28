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
    
    func bind(num: Int) {
        self.repoName.text = "repo \(num)"
        self.repoDesc.text = "Description \(num)"
        self.author.text = "author: \(num)"
        self.stars.text = "\(num) stars"
        self.language.text = "Java"
    }
    
}
