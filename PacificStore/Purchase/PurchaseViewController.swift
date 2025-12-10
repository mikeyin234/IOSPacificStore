//
//  PurchaseViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/19.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import UIKit
import WebKit


class PurchaseViewController: BaseViewController,WKUIDelegate {
    
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
        m_ViewContent.addSubview(m_AboutWebView)
        
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
        let myURL = URL(string:ConfigInfo.PURCHASE_SITE)
        
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
        if let url = URL(string: "http://w3.pacific-mall.com.tw/infoQA") {
            UIApplication.shared.open(url, options: [:])
        }
        //self.navigationController?.popViewController(animated: true);
    }
    
    
    
    
    
}
