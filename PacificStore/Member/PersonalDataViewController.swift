//
//  PersonalDataViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2023/7/30.
//  Copyright © 2023 greatsoft. All rights reserved.
//

import UIKit


////////////////////////////////////////////////
//個人資料使用條款
class PersonalDataViewController: BaseViewController,WKUIDelegate,WKNavigationDelegate {

    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    public static var   m_strPolicySite  = "";
    @IBOutlet     weak var   m_btnClose:UIButton!;
    
    var m_finalRegisterViewController:FinalRegisterViewController!;
    
    var m_modifyMemberViewController:ModifyMemberViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearCache();
        
        m_btnClose.setTitle("", for: UIControl.State.normal)
        
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
    
    @IBAction func onCloseClick(_ sender:UIButton)
    {
        
        if(m_modifyMemberViewController != nil)
        {
            m_modifyMemberViewController.onHidePolicy()
        }else
        {
            m_finalRegisterViewController.onHidePolicy()
        }
        
    }
    
    
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        var   poliwebFrame = m_ViewContent.frame;
        poliwebFrame.origin.y = 0;
        
        m_PolicyWebView = WKWebView(frame:   poliwebFrame, configuration: webConfiguration)
        
        m_PolicyWebView.uiDelegate = self
        m_PolicyWebView.navigationDelegate = self
        
        
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    override func  viewDidAppear(_ animated: Bool) {
        
        InitWebView();
        // Do any additional setup after loading the view.
        
        
       
        
    }
    
   func LoadPage()
    {
        
        if(m_modifyMemberViewController != nil)
        {
            if(ModifyMemberViewController.m_strPolicySite.count > 0)
            {
                let myURL = URL(string:ModifyMemberViewController.m_strPolicySite)
                
                let myRequest = URLRequest(url: myURL!)
                m_PolicyWebView.load(myRequest)
            }
            
        }else
        {
            if(FinalRegisterViewController.m_strPolicySite.count > 0)
            {
                let myURL = URL(string:FinalRegisterViewController.m_strPolicySite)
                
                let myRequest = URLRequest(url: myURL!)
                m_PolicyWebView.load(myRequest)
            }
        }
        
        
    }
    
   override  func viewWillDisappear(_ animated: Bool) {
       
       
   }

    
}
