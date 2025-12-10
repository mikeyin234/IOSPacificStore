//
//  ExclusiveOfferDetailViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/5/20.
//  Copyright © 2019 greatsoft. All rights reserved.
//////////////////////////////////////////////////////////

import UIKit
import WebKit

class ExclusiveOfferDetailViewController:  BaseViewController,WKUIDelegate {
    
    @IBOutlet weak var mlabelTitle: UILabel!
    @IBOutlet weak var mbtnChange: UIButton!
    
    
    var   m_strTitle =  "";
    var   m_strImagePath =  "";
    var   m_strID  = "";
    var   m_bAlreadyChange = false;
    
    var   m_PolicyWebView : WKWebView!
    
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    var   m_strWebPage = "";
    
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        var   poliwebFrame = m_ViewContent.frame;
        
        poliwebFrame.origin.y = 0;
        
        m_PolicyWebView  = WKWebView(frame:poliwebFrame, configuration: webConfiguration)
        
        m_PolicyWebView.uiDelegate = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mlabelTitle.text  = m_strTitle;
        
        self.clearCache();
        
        mbtnChange.isHidden = m_bAlreadyChange;
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
        
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveExclusiveOfferResult), name:NSNotification.Name(rawValue: kDCReceiveExclusiveOffer), object: nil)
        
        self.SetTitleColor();
        
    }
    
    @objc func didReceiveExclusiveOfferResult(notification: NSNotification){
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            if(Int(strCode) == 0)
            {
                let strMessage  = dic.object(forKey: "ReturnMessage") as! String
                
                let alert = UIAlertController(title: "領取成功", message: strMessage, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "確定", style: .default) { (UIAlertAction) in
                        self.navigationController?.popViewController(animated: true);
                    }
                )
                self.present(alert, animated: true)
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
        
    }
    
    
    override func  viewDidAppear(_ animated: Bool) {
        
        
        InitWebView();
        
        // Do any additional setup after loading the view.
        let myURL = URL(string:m_strWebPage)
        let myRequest = URLRequest(url: myURL!)
        
        m_PolicyWebView.load(myRequest)
    }
    
    @IBAction func onMemberCardInfo(_ sender: AnyObject) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "MemberCode");                self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }

    
    
    @IBAction func onQRCodeScan(_ sender: AnyObject) {
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.receiveExclusiveOffer(ConfigInfo.m_strAccessToken, andID: m_strID)                        
    }
    
    
}


