//
//  AccCodeCardViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/2.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class AccCodeCardViewController: BaseViewController {
    
    @IBOutlet weak var m_textMessage:UILabel!
    @IBOutlet weak var m_textOtpCode:UITextField!
    var m_strPhoneNumber  = "";
    
    @IBOutlet weak var  m_buttonSend:UIButton!
    
    var  m_timer:Timer!;
    var m_iCounter = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let toolBarAccCode = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonAccCode))
        
        m_textOtpCode.inputAccessoryView = toolBarAccCode
        
        
        let strDisplayNumber = "\( m_strPhoneNumber.prefix(4))****\(m_strPhoneNumber.suffix(2))";
        
        m_textMessage.text  = "將發送簡訊到行動電話\(strDisplayNumber)，若您所留電話錯誤或無法收到簡訊時，請與貴賓廳聯繫變更事宜。貴賓廳服務專線:04-2529-2222或04-2529-1111轉580~582";
        
        
    }
    
    
    @objc func doneButtonAccCode()
    {
        m_textOtpCode.resignFirstResponder() // To resign the inputView on clicking done.
        
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
    
    
    
    @IBAction func onAccCodeVerifyClick(_ sender:UIButton)
    {
        if(m_textOtpCode.text?.count != 6)
        {
            ShowAlertControl(Message: "驗証碼需為6碼");
            return;
        }
        
        MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        
        DCUpdater.shared()?.cardVerifyOTP(m_strPhoneNumber, andCode: m_textOtpCode.text,andAccount: ConfigInfo.m_strUserID)
        
        
    }
    
    
    @IBAction func onGetAccCodeClick(_ sender:UIButton)
    {
        if(m_iCounter==0)
        {           
           MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
           DCUpdater.shared()?.getCardOTPCode(m_strPhoneNumber)
        }
        
    }
    
    
    
    
    @objc func didGetOTPResult(notification: NSNotification){
        
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
                ShowAlertControl(Message: "驗証碼已送出");
                
                m_timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
                
                
            }else if(Int(strCode) == -34)
            {
                ShowAlertControl(Message: "輸入錯誤，請與貴賓廳連繫");                
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
    
    
    
    @objc func didVerityOTPResult(notification: NSNotification){
        
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
                ConfigInfo.m_strPhone = m_strPhoneNumber;
                
                let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                ConfigInfo.m_iMemberType  = 1;
                
                ConfigInfo.m_strName = DataDic.object(forKey: "Name") as! String;
                ConfigInfo.m_strBirthday = DataDic.object(forKey: "Birthday") as! String;
                
                ConfigInfo.m_strZip = DataDic.object(forKey: "ZIP") as! String;
                ConfigInfo.m_strAddr = DataDic.object(forKey: "ADDR") as! String;
                ConfigInfo.m_strSex = DataDic.object(forKey: "Sex") as! String;
                
                
                ConfigInfo.m_strCity = DataDic.object(forKey: "City") as! String;
                ConfigInfo.m_strArea = DataDic.object(forKey: "Region") as! String;
                
                
                ConfigInfo.m_strCardNumber = DataDic.object(forKey: "CardNumber") as! String;
                
                GotoFinalRegisterVirify();
            }else
            {                
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    func GotoFinalRegisterVirify()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btFinalRegister
            = StoryBoard.instantiateViewController(withIdentifier: "FinalRegister") as!  FinalRegisterViewController
        
        btFinalRegister.m_bResiterType = ConfigInfo.CAR_MEMBER;
        
        self.navigationController?.pushViewController(btFinalRegister, animated: true)
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetOTPResult), name:NSNotification.Name(rawValue: kDCGetCardOTP), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didVerityOTPResult), name:NSNotification.Name(rawValue: kDCCardVerifyOTP), object: nil)
    }
    
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
    }
    
    
    @objc func updateTimer() {
        
        m_iCounter += 1;
        
        if(m_iCounter >= 60)
        {
            m_timer.invalidate();
            m_iCounter = 0;
            
            m_buttonSend.setTitle("取得驗証碼", for: UIControl.State.normal);
            m_buttonSend.isEnabled = true;
        }else
        {
            m_buttonSend.isEnabled = false;
            let remainSecond = 60 - m_iCounter;
            m_buttonSend.setTitle("\(remainSecond)秒", for: UIControl.State.normal);
        }
    }
    
    
    
}
