//
//  GitDiffView.swift
//  GithubDiscovery
//
//  Created by Guoliang Wang on 11/7/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import WebKit
import Mustache

class GitDiffView: UIView {
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    weak var view: UIView!
    var diffUrlString: String?
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.sizeToFit()
        return webView
    }()
    
    init(diffUrlString: String) {
        super.init(frame: CGRect.null)
        self.diffUrlString = diffUrlString
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        addSubview(view)
        view.bringSubview(toFront: activityView)
        activityView.isHidden = false
        activityView.hidesWhenStopped = true
        activityView.center = view.center
        activityView.startAnimating()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight] // subview autoresize to fit its superview
        addSubview(view);
        loadWebView(diffUrlString: self.diffUrlString!)
        view.addSubview(webView)
        
        return view
    }
    
    private func loadWebView(diffUrlString: String) {

        let htmlPath = Bundle.main.path(forResource: "diff_view", ofType: "html")
        guard let filePath = htmlPath else { return }
        let htmlURL = URL(fileURLWithPath: filePath)
        var html = ""
        do {
            html = try NSString(contentsOf: htmlURL, encoding: String.Encoding.utf8.rawValue) as String
            webView.loadHTMLString(html, baseURL: nil)
        } catch {
            print("error loading HTML file!")
        }
    }
}

extension GitDiffView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let altDiffFile = "https://github.com/RedBearLab/iOS/pull/12.diff" // in case diffFile is nil, use this as a backup
        let diffJsPath = Bundle.main.path(forResource: "diff", ofType: "js")
        if let jsFilePath = diffJsPath {
            var jsContent = try! String.init(contentsOfFile: jsFilePath)
            let funcToExec = "smartDraw('\(self.diffUrlString ?? altDiffFile)')"
            
            jsContent = jsContent.replacingOccurrences(of: "//replaced//", with: funcToExec)
            webView.evaluateJavaScript(String.init(jsContent), completionHandler: { (result, error) in
            })
        }
        
        webView.evaluateJavaScript("document.body.offsetHeight") { (result, error) in
            if let _ = result {
                let frame = webView.frame
                webView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 35, width: frame.width, height: frame.height)
                self.activityView.stopAnimating()
            }
        }

    }
}
