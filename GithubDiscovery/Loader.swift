//
//  Loader.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 11/2/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import MBProgressHUD

class Loader: NSObject {
    class func show(message: String = "Loading...", delegate: UIViewController) {
        var load: MBProgressHUD = MBProgressHUD()
        load = MBProgressHUD.showAdded(to: delegate.view, animated: true)
        load.mode = MBProgressHUDMode.indeterminate
        
        if (message.characters.count > 0) {
            load.labelText = message
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    class func hide(delegate: UIViewController) {
        MBProgressHUD.hide(for: delegate.view, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
