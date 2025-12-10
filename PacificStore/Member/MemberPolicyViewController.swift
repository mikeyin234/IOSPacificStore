//
//  MemberPolicyViewController.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/18.
//  Copyright © 2019年 greatsoft. All rights reserved.
//

import UIKit
import WebKit


class MemberPolicyViewController: BaseViewController,WKUIDelegate {
    
    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    
//===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        var   poliwebFrame = m_ViewContent.frame;
        poliwebFrame.origin.y = 0;
        //poliwebFrame.size.height += m_ViewContent.frame.origin.y;
        
        m_PolicyWebView = WKWebView(frame:   poliwebFrame, configuration: webConfiguration)
        
        m_PolicyWebView.uiDelegate = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearCache();
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
       self.SetTitleColor();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        InitWebView();
        
        
        
        // Do any additional setup after loading the view.
        let myURL = URL(string:ConfigInfo.MEMBER_POLICY)
        let myRequest = URLRequest(url: myURL!)
        m_PolicyWebView.load(myRequest)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.stopTimeTick();
        
        self.RemoveTitleBar();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_MEMBER_POLICE), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
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
