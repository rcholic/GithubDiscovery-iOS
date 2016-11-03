//
//  CommitPullCell.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 11/2/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

class CommitPullCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(model: BaseCellData) {
        if let d = model.date {
           date.text = "At \(d)"
        } else {
            date.text = ""
        }
        
        username.text = "By \(model.author)"
        title.text = "\(model.title)"
        
        if (model.author.isEmpty) {
            username.text = ""
        }

    }
}
