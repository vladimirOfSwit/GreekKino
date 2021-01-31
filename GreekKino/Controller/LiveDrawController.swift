//
//  LiveDrawController.swift
//  GreekKino
//
//  Created by Vladimir Savic on 1/31/21.
//

import UIKit
import WebKit

class LiveDrawController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        
        let liveDrawUrl = URL(string: "https://ds.opap.gr/web_kino/kinoIframe.html?link=https://ds.opap.gr/web_kino/kino/html/Internet_PRODUCTION/KinoDraw_201910.html&resolution=847x500")
        
        let myRequest = URLRequest(url: liveDrawUrl!)
        
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
        
        
    }
    
    
    
    
}
