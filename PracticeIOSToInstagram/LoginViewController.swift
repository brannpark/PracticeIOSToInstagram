//
//  LoginViewController.swift
//  PracticeIOSToInstagram
//
//  Created by brannpark on 2017. 2. 24..
//  Copyright © 2017년 Masher Shin. All rights reserved.
//

import Foundation
import UIKit
import InstagramKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authUrl = InstagramEngine.shared().authorizationURL(for: [.comments, .followerList, .likes, .publicContent, .relationships])
        webView.loadRequest(URLRequest(url: authUrl))
    }
    
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        do {
            try InstagramEngine.shared().receivedValidAccessToken(from: request.url!)
            dismiss(animated: true, completion: nil)
        } catch {
            print(error)
//            let alertController = UIAlertController(title: "Instagram", message: "사용자의 액세스 토큰을 가져오지 못했습니다.", preferredStyle: .alert)
//            present(alertController, animated: true) {
//                
//            }
        }
        
        return true
    }
    
    
}
