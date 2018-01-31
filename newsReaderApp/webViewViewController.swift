//
//  webViewViewController.swift
//  newsReaderApp
//
//  Created by Mohamed on 1/4/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit

class webViewViewController: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!
    
    var url:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(URLRequest(url: URL(string: url!)!))
        
    }

   

}
