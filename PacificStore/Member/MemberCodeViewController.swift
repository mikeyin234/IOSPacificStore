//
//  MemberCodeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/26.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class MemberCodeViewController: BaseViewController {

    @IBOutlet var m_labelCard : UILabel!
    
    var  m_ShareCode = "";
    var  m_DownLoadSite = "";
    var  m_ShareText = "";
    //var  m_fDefaultBright:CGFloat = 0.0;
    
    
    @IBOutlet var m_imageViewQrcode : UIImageView!
    @IBOutlet var m_imageViewBarCode : UIImageView!
    
    @IBOutlet var m_labelShareCode : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        m_labelCard.layer.masksToBounds = true
        m_labelCard.layer.cornerRadius =  10;
        
        //kDCQueryCardCode
        MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        
        DCUpdater.shared()?.getCardCode(ConfigInfo.m_strAccessToken)
        
        
        ConfigInfo.m_fDefaultBright = UIScreen.main.brightness;
        
        print("Brightness = \(ConfigInfo.m_fDefaultBright)")
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
        UIScreen.main.brightness = ConfigInfo.m_fDefaultBright;
        
        
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction override func onHomeClick(_ sender:UIButton)
    {
        
        UIScreen.main.brightness = ConfigInfo.m_fDefaultBright;
        self.navigationController?.popToRootViewController(animated: true)
        
        //mike add at 22/04/26
        let  viewController  =  UIApplication.topViewController()  as!  ViewController;
        viewController.RefershMainPage();
        
    }
    
   
    
    
    
    
    @IBAction func onShareClick(_ sender:UIButton)
    {
        let textToShare  =  m_ShareText;
        
        let objectsToShare = [textToShare] as [Any]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        
        activityVC.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.copyToPasteboard ]
        
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didMemberCardCodeResult), name:NSNotification.Name(rawValue: kDCQueryCardCode), object: nil)
        super.viewWillAppear(animated)
        self.SetTitleColor();
        
        
       
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIScreen.main.brightness = CGFloat(0.9)
        
    }
    
   
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self);
        
        RemoveTitleBar()
        
        
    }
    
    
    
    @objc func didMemberCardCodeResult(notification: NSNotification){
        
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
                let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                
                m_ShareCode  = DataDic.object(forKey: "ShareCode") as! String;
                
                m_labelShareCode.text = "好友分享碼：" + m_ShareCode;
                m_DownLoadSite  = DataDic.object(forKey: "IOS_DownloadSite") as! String;
                
                ConfigInfo.m_strCardNumber = DataDic.object(forKey: "CardNumber") as! String;
                
                
                let  strQrcode  = DataDic.object(forKey: "Qrcode") as! String;
                //m_imageViewQrcode.downloaded(from: strQrcode)
                fetchImage(from: strQrcode) { image in
                    // IMPORTANT: Update UI on the main thread
                    DispatchQueue.main.async { [weak imageView = self.m_imageViewQrcode] in
                        imageView?.image = image!
                    }
                }
                
                let   strBarCode  = DataDic.object(forKey: "BarCode") as! String;
                fetchImage(from: strBarCode) { image in
                    // IMPORTANT: Update UI on the main thread
                    DispatchQueue.main.async { [weak imageView = self.m_imageViewBarCode] in
                        imageView?.image = image!
                    }
                }

                
              //m_imageViewBarCode.downloaded(from: strBarCode)
                m_labelCard.text = "卡號：" + ConfigInfo.m_strCardNumber;
                
                
                m_ShareText  = DataDic.object(forKey: "ShareText") as! String;
            }
            else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    @IBAction func onTradeCodeClick(_ sender:UIButton)
    {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btPTradeCodeInfo
            = StoryBoard.instantiateViewController(withIdentifier: "TradeCode");
        
        self.navigationController?.pushViewController(btPTradeCodeInfo, animated: true)
        
        
    }
    
    
}
