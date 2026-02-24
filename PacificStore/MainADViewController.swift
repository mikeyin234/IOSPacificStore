//
//  MainADViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/12.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import WebKit


class MainADViewController: BaseViewController,WKUIDelegate,WKNavigationDelegate {

    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    var   m_strWebPage = "";
    @IBOutlet     weak var  m_labTitle:UILabel!
    
    var   m_strTitle = "";
    //===================================================//
    func InitWebView() {
        
        _ = WKWebViewConfiguration()
        var   poliwebFrame = m_ViewContent.frame;
        
        poliwebFrame.origin.y = 0;
        
        self.clearCache();
        
        m_PolicyWebView  = WKWebView(frame: CGRect(x: 0, y: 0, width: poliwebFrame.width, height: poliwebFrame.height),
                                    configuration: WKWebViewConfiguration())
        
        
        m_PolicyWebView.uiDelegate = self
        m_PolicyWebView.navigationDelegate = self
        
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        m_labTitle.text = m_strTitle;
        
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
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        InitWebView();
        // Do any additional setup after loading the view.
        let myURL = URL(string:m_strWebPage)
        let myRequest = URLRequest(url: myURL!)
        m_PolicyWebView.load(myRequest)
        
        
    }
    
    
   
    
}
