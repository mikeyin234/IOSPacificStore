//
//  CardPolicyViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2023/7/27.
//  Copyright © 2023 greatsoft. All rights reserved.
//

import UIKit

class CardPolicyViewController: BaseViewController,WKUIDelegate {
    
    
    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    public static var   m_strCardPolicySite  = "";
    
    
    @IBOutlet     weak var   m_btnClose:UIButton!;
    
    
    var m_memberCenterViewController:MemberCenterViewController!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearCache();
        
        m_btnClose.setTitle("", for: UIControl.State.normal)
        
        
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
        
        m_memberCenterViewController.onHideCardPolicy()
        
    }
    
    
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        var   poliwebFrame = m_ViewContent.frame;
        poliwebFrame.origin.y = 0;
        
        m_PolicyWebView = WKWebView(frame:   poliwebFrame, configuration: webConfiguration)
        
        m_PolicyWebView.uiDelegate = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    override func  viewDidAppear(_ animated: Bool) {
        
        InitWebView();
        
        // Do any additional setup after loading the view.
        
        if(CardPolicyViewController.m_strCardPolicySite.count > 0)
        {
            let myURL = URL(string:CardPolicyViewController.m_strCardPolicySite)
            let myRequest = URLRequest(url: myURL!)
            m_PolicyWebView.load(myRequest)
        }
        
    }
    
    
   override  func viewWillDisappear(_ animated: Bool) {
       
       
   }
    
    

}
