//
//  PushDetailViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/4/9.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import WebKit

class PushDetailViewController: BaseViewController, WKUIDelegate{

    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    
    @IBOutlet weak var m_textTitle: UILabel!
    @IBOutlet weak var m_textContent: UILabel!
    @IBOutlet weak var m_textDate: UILabel!
    
//=========================================================//
   
    
    
    var  m_strTitle = "";
    var  m_strContent = "";
    var  m_strWebPage = "";
    var  m_strID = "";
    var  m_strDate = "";
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        var   poliwebFrame = m_ViewContent.frame;
        
        m_PolicyWebView  = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: poliwebFrame.size.height), configuration: WKWebViewConfiguration())
        
        m_PolicyWebView.uiDelegate = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        m_textTitle.text  =  m_strTitle;
         self.clearCache();
        
        m_textDate.text = m_strDate;
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        // Do any additional setup after loading the view.
        if(m_strWebPage.count>0)
        {
           InitWebView();
            m_textContent.isHidden = true;
           let myURL = URL(string: m_strWebPage)
           let myRequest = URLRequest(url: myURL!)
           m_PolicyWebView.load(myRequest)
        }else
        {
            m_ViewContent.isHidden = true;
            m_textContent.text  = m_strContent;
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
    
    
}
