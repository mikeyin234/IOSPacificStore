//
//  ForgetPasswordViewController.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/18.
//  Copyright © 2019年 greatsoft. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: BaseViewController {

    @IBOutlet weak var m_textAccount:UITextField!
    @IBOutlet weak var m_textOtpCode:UITextField!
    
    @IBOutlet weak var  m_buttonSend:UIButton!
    
    var  m_timer:Timer!;
    var m_iCounter = 0;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let toolBarAccount = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonAccount))
        m_textAccount.inputAccessoryView = toolBarAccount
        
        let toolBarOTPCode = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonOTP))
        m_textOtpCode.inputAccessoryView = toolBarOTPCode
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
    
    
    
    
    @objc func doneButtonAccount()
    {
        m_textAccount.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    @objc func doneButtonOTP()
    {
        m_textOtpCode.resignFirstResponder()   //To resign the inputView on clicking done.
        
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
    
    @IBAction func onGetAccCodeClick(_ sender:UIButton)
    {
        if(m_iCounter==0)
        {
           MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
           DCUpdater.shared()?.forgetPasswordOTPCode(m_textAccount.text)
        }
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
        NotificationCenter.default.addObserver(self, selector:#selector(didGetForgetPasswordOTPResult), name:NSNotification.Name(rawValue: kDCGetForgetPasswordOTPCode), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didVerityOTPResult), name:NSNotification.Name(rawValue: kDCVerifyForgetPwdOTP), object: nil)
    }
    

    
    @objc func didGetForgetPasswordOTPResult(notification: NSNotification){
        
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
                //Goto Password Result
                GotoChangePassword();
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
    
    
    
    @IBAction func onAccCodeVerifyClick(_ sender:UIButton)
    {
        if(m_textOtpCode.text?.count != 6)
        {
            ShowAlertControl(Message: "驗証碼需為6碼");
            return;
        }
        
        MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        DCUpdater.shared()?.verifyForgetPwdOTP(m_textAccount.text, andCode: m_textOtpCode.text)
        
    }
    
    
    func GotoChangePassword()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btForgetPwModify
            = StoryBoard.instantiateViewController(withIdentifier: "ForgetPWModify") as! FPChangePasswordViewController;
        
        btForgetPwModify.m_strAccount = m_textAccount.text!;
        
    self.navigationController?.pushViewController(btForgetPwModify, animated: true)
        
    }
    
}
