//
//  AccCodeVerifyViewController.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/15.
//  Copyright © 2019年 greatsoft. All rights reserved.
//

import UIKit


class AccCodeVerifyViewController: BaseViewController {

    @IBOutlet weak var m_textPhone:UITextField!    
    @IBOutlet weak var m_textOtpCode:UITextField!
    
    @IBOutlet weak var  m_buttonSend:UIButton!
    
//=================================================//
    var  m_strName = "";
    var  m_strZip = "";
    var  m_strAddr = "";
    var  m_strPhoneNumber = "";
    
    var  m_iVerityType = 0;
    var  m_timer:Timer!;
    var m_iCounter = 0;
//======================================//
    var  m_strCity = "";
    var  m_strArea = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Do any additional setup after loading the view.
        let toolBarAccCode = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonAccCode))
        
        m_textOtpCode.inputAccessoryView = toolBarAccCode
     
        
        
        let toolBarPhone = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonPhone))
        m_textPhone.inputAccessoryView = toolBarPhone
        
        if(m_iVerityType == 1)
        {
            m_textPhone.text = m_strPhoneNumber;
            m_textPhone.isEnabled  = false;            
        }
    }
    
    @objc func doneButtonPhone()
    {
        m_textPhone.resignFirstResponder() // To resign the inputView on clicking done.
        
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
        
        DCUpdater.shared()?.verifyOTP(m_textPhone.text, andCode: m_textOtpCode.text)
        
    }
    
    
    @IBAction func onGetAccCodeClick(_ sender:UIButton)
    {
        if(m_iCounter==0)
        {
           MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
           DCUpdater.shared()?.getOTPCode(m_textPhone.text);
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
                
            }else
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
                ConfigInfo.m_strPhone = m_textPhone.text!;
                if(m_iVerityType == 0)
                {
                     GotoFinalRegisterVirify();
                }else
                {
                    //Modify Member......
                    MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
                    
                    //Modify At 
                    DCUpdater.shared()?.modifyMember(ConfigInfo.m_strAccessToken,
                                                      andName: m_strName
                                                     , andPhone: m_strPhoneNumber,
                                                       andPostCode: m_strZip,
                                                       andAddress: m_strAddr,
                                                     andCity: m_strCity,
                                                     andArea: m_strArea,
                                                     andAllowModifyData: false
                            );               
                }
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
            = StoryBoard.instantiateViewController(withIdentifier: "FinalRegister");
        
        self.navigationController?.pushViewController(btFinalRegister, animated: true)
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
         super.viewWillAppear(animated)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetOTPResult), name:NSNotification.Name(rawValue: kDCGetOTP), object: nil)
        
         NotificationCenter.default.addObserver(self, selector:#selector(didVerityOTPResult), name:NSNotification.Name(rawValue: kDCVerifyOTP), object: nil)
        
          NotificationCenter.default.addObserver(self, selector:#selector(didModifyResult), name:NSNotification.Name(rawValue: kDCModifyUser), object: nil)
        self.SetTitleColor();
        
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
    
    
 
    
    @objc func didModifyResult(notification: NSNotification){
        
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
                ConfigInfo.m_strName  = m_strName;
                ConfigInfo.m_strZip   = m_strZip;
                ConfigInfo.m_strAddr  = m_strAddr;
                ConfigInfo.m_strPhone = m_strPhoneNumber;
                
                ConfigInfo.m_strCity  = m_strCity;
                ConfigInfo.m_strArea  = m_strArea;
                
                
                self.popBack(3);
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
}
