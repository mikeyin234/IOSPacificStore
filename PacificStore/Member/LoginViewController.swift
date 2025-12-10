//
//  LoginViewController.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/15.
//  Copyright © 2019年 greatsoft. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var m_textAccount: UITextField!
    @IBOutlet weak var m_textPassword: UITextField!
    @IBOutlet weak var m_SavePassword:UISwitch!
    
    @IBOutlet weak var m_imageView:UIImageView!
    
    
    var  m_strUserID = "";
    var  m_strReplaceID = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ConfigInfo.m_bIsViewMemberLogin = false;
        
        
        let toolBarAccount = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonAccount))
        toolBarAccount.tintColor = UIColor.blue
        m_textAccount.inputAccessoryView = toolBarAccount
        
        let toolBarPassword = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonPassword))
        m_textPassword.inputAccessoryView = toolBarPassword
        m_textPassword.tintColor = UIColor.blue
        let myUserDefaults = UserDefaults.standard;
        
        if(isKeyPresentInUserDefaults(key: "UserID"))
        {
            m_strUserID =  myUserDefaults.string(forKey: "UserID")!;
            
            let startIndex = m_strUserID.count/4
            var subString1 = m_strUserID;
            let  len = startIndex + m_strUserID.count/2;
            
            for i in startIndex...(len-1) {
                 subString1 = (subString1 as NSString).replacingCharacters(in: NSMakeRange(i,1), with: "*")
            }
            
            m_strReplaceID = (m_strUserID as NSString).substring(with: NSMakeRange(startIndex,m_strUserID.count/2))
            
            m_textAccount.text? = subString1;
        }
        
        if(isKeyPresentInUserDefaults(key: "IsSave"))
        {
            m_SavePassword.isOn = myUserDefaults.bool(forKey: "IsSave");
        }
        
        if(m_SavePassword.isOn)
        {
            if(isKeyPresentInUserDefaults(key: "Password"))
            {
               m_textPassword.text  =  myUserDefaults.string(forKey: "Password")!;
            }
        }
        
//=========================================//
        
        
        
    }
    
   
    
    
    
    @objc func doneButtonAccount()
    {
        m_textAccount.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    @objc func doneButtonPassword()
    {
        m_textPassword.resignFirstResponder() // To resign the inputView on clicking done.
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
    
    
    @IBAction func onLoginClick(_ sender:UIButton)
    {
        MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        
        let string = String(repeating: "*", count: m_strReplaceID.count)
        
        ConfigInfo.m_strUserID = (m_textAccount.text?.replacingOccurrences(of: string, with:m_strReplaceID))!
       
        DCUpdater.shared()?.didLogin(withAccount: ConfigInfo.m_strUserID, password: m_textPassword.text, pushToken: ConfigInfo.FCM_DEVICE_TOKEN, os: "i")
        
        
    }
    
    
    @IBAction func onForgetPasswordClick(_ sender:UIButton)
    {
        
    }
    
    
    @IBAction func onRegisterClick(_ sender:UIButton)
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)        
        let  btPurchaseDevice
            = StoryBoard.instantiateViewController(withIdentifier: "Register");
        self.navigationController?.pushViewController(btPurchaseDevice, animated: true)
    }
    
    
    @IBAction func onPolicyClick(_ sender:UIButton)
    {
        
    }
    
    @objc func didLoginResult(notification: NSNotification){
        
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
                ConfigInfo.m_bMemberLogin =  true;
                let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                
                
                
                
                ConfigInfo.m_SerialNo = DataDic.object(forKey: "SerialNo") as! String;
                ConfigInfo.m_strAccessToken = DataDic.object(forKey: "AccessToken") as! String;
                ConfigInfo.m_iMemberType = Int(DataDic.object(forKey: "MemberType") as! String)!;
                
                ConfigInfo.m_strName = DataDic.object(forKey: "Name") as! String
                ConfigInfo.m_strBirthday = DataDic.object(forKey: "Birthday") as! String;
                
                ConfigInfo.m_strZip = DataDic.object(forKey: "ZIP") as! String;
                
                
//=======================================================================//
                
                ConfigInfo.m_strArea = DataDic.object(forKey: "Area") as! String;
                ConfigInfo.m_strCity = DataDic.object(forKey: "City") as! String;
                
                ConfigInfo.m_strAddr = DataDic.object(forKey: "ADDR") as! String;
                ConfigInfo.m_strSex = Int(DataDic.object(forKey: "Sex") as! String) == 1 ? "男" : "女";
                
                ConfigInfo.m_strPhone  = DataDic.object(forKey: "PhoneNumber") as! String
                
                ConfigInfo.m_iCardType = Int(DataDic.object(forKey: "CardType") as! String)!;
                
                ConfigInfo.m_strCardNumber  = DataDic.object(forKey: "CardNumber") as! String
                ConfigInfo.m_strPassword = m_textPassword.text!;
                
                SaveToUserLoginInfo();
                
//=================================================================================//
                let deviceId = UIDevice.current.identifierForVendor?.uuidString
                
                if(ConfigInfo.FCM_DEVICE_TOKEN.count > 0)
                {                    
                    DCUpdater.shared()?.updatePushToken(deviceId, pushToken: ConfigInfo.FCM_DEVICE_TOKEN, accessToken: ConfigInfo.m_strAccessToken);
                }
                
                gotoMemberCenter();
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    func   gotoMemberCenter()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btMemberCenter
                = StoryBoard.instantiateViewController(withIdentifier: "MemberCenter");
        
        self.navigationController?.replaceTopViewController(with: btMemberCenter, animated: true)
        
    }
    
    
    func SaveToUserLoginInfo()
    {
        let myUserDefaults = UserDefaults.standard;
        
        
        myUserDefaults.set(ConfigInfo.m_strUserID, forKey: "UserID");
        myUserDefaults.set(m_SavePassword.isOn, forKey: "IsSave")
        
        if(m_SavePassword.isOn)
        {
            myUserDefaults.set(m_textPassword.text, forKey: "Password");
        }else
        {
            myUserDefaults.set("", forKey: "Password");
        }
        
    
        myUserDefaults.set(ConfigInfo.m_SerialNo , forKey: "SerialNo")
        myUserDefaults.set(ConfigInfo.m_strAccessToken , forKey: "AccessToken")
        myUserDefaults.set(ConfigInfo.m_iMemberType , forKey: "MemberType")
        myUserDefaults.set(ConfigInfo.m_strName , forKey: "Name")
        myUserDefaults.set(ConfigInfo.m_strBirthday , forKey: "Birthday")
        myUserDefaults.set(ConfigInfo.m_strZip , forKey: "ZIP")
        myUserDefaults.set(ConfigInfo.m_strAddr , forKey: "ADDR")
        
        myUserDefaults.set(ConfigInfo.m_strSex , forKey: "Sex")
        myUserDefaults.set(ConfigInfo.m_strPhone , forKey: "PhoneNumber")
        myUserDefaults.set(ConfigInfo.m_iCardType , forKey: "CardType")
        myUserDefaults.set(ConfigInfo.m_strCardNumber , forKey: "CardNumber")
        myUserDefaults.set(ConfigInfo.m_bMemberLogin , forKey: "IsLogin")
        
//=====================================================================//
        myUserDefaults.set(ConfigInfo.m_strCity , forKey: "City")
        myUserDefaults.set(ConfigInfo.m_strArea , forKey: "Area")
        
        
        myUserDefaults.synchronize();
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didLoginResult), name:NSNotification.Name(rawValue: kDCLogin), object: nil)
        
        super.viewWillAppear(animated)
        
        //m_imageView.frame.size.height = 200
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //m_imageView.frame.size.height = 200
        
    }
    
    
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCLogin), object: nil)
        
        RemoveTitleBar()
        
    }
    
}
