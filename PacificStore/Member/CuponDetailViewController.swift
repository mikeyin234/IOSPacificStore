//
//  CuponDetailViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/4/4.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import WebKit


class CuponDetailViewController: BaseViewController,WKUIDelegate {
    
    @IBOutlet weak var mlabelTitle: UILabel!
    @IBOutlet weak var mbarCodeImage: UIImageView!    
    @IBOutlet weak var mButtonScan: UIButton!
    
    var  m_strTitle =  "";
    var  m_strImagePath =  "";
    var   m_PolicyWebView : WKWebView!
    var   m_iType = 0;
    var   m_strVolumeCode = "";
    var   m_strID = "";
    var   m_strIsUsed = false;
    static  var   m_strUseDate = "";
    
    
    @IBOutlet     weak var   m_ViewContent:UIView!;
    var   m_strWebPage = "";
    @IBOutlet     weak var   m_ViewExcluOfferView:UIView!;
    
    @IBOutlet weak var mlabeExcluceOfferDate:UILabel!
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        var   poliwebFrame = m_ViewContent.frame;        
       poliwebFrame.origin.y = 0;
        //poliwebFrame.size.height += m_ViewContent.frame.origin.y;
        
        m_PolicyWebView  = WKWebView(frame:poliwebFrame, configuration: webConfiguration)
        
        m_PolicyWebView.uiDelegate = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //mlabelTitle.text  = m_strTitle;
        self.clearCache();
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
        if( ConfigInfo.m_bChangeOfferStatus)
        {
            m_strIsUsed = true;
            ConfigInfo.m_bChangeOfferStatus = false;
            
            let alert = UIAlertController(title: "系統資訊", message: "兌換成功!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:  "確定", style: .default, handler: { (UIAlertAction) in
            }))
            self.present(alert, animated: true)
        }
        
        
        ///////////////////////////////////////////////
        //m_iType == 10   遊戲兌換卷
        if(m_iType == 0)
        {
            mbarCodeImage.downloaded(from: m_strImagePath);
            mButtonScan.isHidden = true;
            m_ViewExcluOfferView.isHidden  = true;            
        }else if(m_iType == 1 ||  m_iType == 10)
        {
            if(m_strIsUsed)
            {   
                mButtonScan.isHidden = true;
                m_ViewExcluOfferView.isHidden  = false;
                mlabeExcluceOfferDate.text = CuponDetailViewController.m_strUseDate
            }else
            {
                m_ViewExcluOfferView.isHidden  = true;
            }
            mbarCodeImage.isHidden =  true;
        }
        
        self.SetTitleColor();
        
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
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
            = StoryBoard.instantiateViewController(withIdentifier: "MemberCode");
        
        self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }
    
    @IBAction func onQRCodeScan(_ sender: AnyObject) {
        
         let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
         let  btQRCodeScan
             = StoryBoard.instantiateViewController(withIdentifier: "QRCodeScan") as!   QRCodeScanViewController;
        
         btQRCodeScan.m_strID = m_strID;
         btQRCodeScan.m_iType = self.m_iType;
         
         self.navigationController?.pushViewController(btQRCodeScan, animated: true)
    }
    
}

