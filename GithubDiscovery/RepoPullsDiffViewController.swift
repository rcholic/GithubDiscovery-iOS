//
//  RepoPullsDiffViewController.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 11/7/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import SnapKit

class RepoPullsDiffViewController: UIViewController {

    var diffUrlString: String?
    var commitDiffView: GitDiffView?
    let closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let diffUrl = diffUrlString else {
            close()
            return
        }
        commitDiffView = GitDiffView(diffUrlString: diffUrl)
        self.view.addSubview(commitDiffView!)
        commitDiffView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        closeButton.contentMode = .center
        closeButton.setImage(cancelImage, for: .normal)
        closeButton.tintColor = CLOSE_BTN_TINT
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-2)
            make.width.equalTo(40)
        }
    }
    
    // MARK: dismiss the view
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
