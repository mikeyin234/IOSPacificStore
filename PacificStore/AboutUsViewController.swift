//
//  AboutUsViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/7.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import WebKit



class AboutUsViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate {
    
    var   m_AboutWebView : WKWebView!
    
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    
    //===================================================//
    func InitWebView() {
        
        _ = WKWebViewConfiguration()
        var   poliwebFrame = m_ViewContent.frame;
        
        poliwebFrame.origin.y = 0;
        
        
        
        
        
        
        m_AboutWebView  = WKWebView(frame: CGRect(x: 0, y: 0, width: poliwebFrame.width, height: poliwebFrame.height),
                                    configuration: WKWebViewConfiguration())
        
        m_AboutWebView.uiDelegate = self
        m_AboutWebView.navigationDelegate = self
        
        m_ViewContent.addSubview(m_AboutWebView)
        
    }
    
    
    func webView(_ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        InitWebView();
        // Do any additional setup after loading the view.
        let myURL = URL(string:ConfigInfo.ABOUT_SITE)
        //let myURL = URL(string:"http://fy.pacific-mall.com.tw/about.php")
        let myRequest = URLRequest(url: myURL!)
        m_AboutWebView.load(myRequest)
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
}
