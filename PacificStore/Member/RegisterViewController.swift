//
//  RegisterViewController.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/15.
//  Copyright © 2019年 greatsoft. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, UITextFieldDelegate{
    
    @IBOutlet weak var m_textAccount: UITextField!
    @IBOutlet weak var m_textPassword: UITextField!
    @IBOutlet weak var m_textConfirmPassword: UITextField!
    
//===================================================//
    @IBOutlet weak var m_labelTitle: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        let toolBarAccount = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonAccount))
        m_textAccount.inputAccessoryView = toolBarAccount
        
        let toolBarPassword = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonPassword))
        m_textPassword.inputAccessoryView = toolBarPassword
        
        let toolBarConfirmPassword = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonOldPassword))
        m_textConfirmPassword.inputAccessoryView = toolBarConfirmPassword
        
        
        
        self.AddOnTouchClick(vTouch: m_labelTitle, action: #selector(self.onMemberDelete))
        
        
    }
    
    
    @objc func onMemberDelete(gesture: UITapGestureRecognizer) {
        
        if(m_textAccount.text!.count >=  4)
        {
            let alertController = UIAlertController(title: "刪除帳號", message: "", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "請輸入密碼"
            }
            
            let saveAction = UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: { alert -> Void in
                
                let  passwordTextField = alertController.textFields![0] as UITextField
                
                MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
                
                DCUpdater.shared()?.deleteAccount(self.m_textAccount.text,
                                                  andPassword: passwordTextField.text);
                
            })
            
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: {
                
                (action : UIAlertAction!) -> Void in })
            
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }        
    }
    
    
    
    @objc func doneButtonOldPassword()
    {
        m_textConfirmPassword.resignFirstResponder() // To resign the
    }
    
    
    
   
    
    
    @objc func doneButtonAccount()
    {
        m_textAccount.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    @objc func doneButtonPassword()
    {
        m_textPassword.resignFirstResponder()   //To resign the inputView on clicking done.
        
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
 
    
    @IBAction func onRegisterClick(_ sender:UIButton)
    {
        
        if(m_textAccount.text?.count==0)
        {
             ShowAlertControl(Message: "帳號不能為空!");
             return;
        }else if(m_textPassword.text?.count==0)
        {
            ShowAlertControl(Message: "密碼不能為空!");
            return;
        }else if(m_textPassword.text != m_textConfirmPassword.text)
        {
             ShowAlertControl(Message: "密碼與確認密碼不附!");
            return;
        }
        
        if((m_textPassword.text?.count)! < 4 ||
            (m_textPassword.text?.count)! > 12)
        {
            ShowAlertControl(Message: "密碼長度須為4 - 12碼");            
            return;
        }
        
        MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        
        //kDCCheckUser
        DCUpdater.shared()?.checkUserType(m_textAccount.text)
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didCheckResult), name:NSNotification.Name(rawValue: kDCCheckUser), object: nil)
       
        
        NotificationCenter.default.addObserver(self, selector:#selector(didDeleteResult), name:NSNotification.Name(rawValue: kDCDeleteAccount), object: nil)
        
        self.SetTitleColor();
        
        super.viewWillAppear(animated)
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self);
        
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCCheckUser), object: nil)
        RemoveTitleBar()
        
    }
    
    
    @objc func didDeleteResult(notification: NSNotification){
        
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
                ShowAlertControl(Message: "刪除成功");
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
    
    
    
    
    
    
    @objc func didCheckResult(notification: NSNotification){
        
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            if(Int(strCode) == 0)   //帳號己存在
            {
                ShowAlertControl(Message:  "該帳號已是會員不可註冊·");
            }else if(Int(strCode) == -15)
            {
                let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                
                let MemberType  = Int(DataDic.object(forKey: "MemberType") as! String)!;
                
                if(MemberType == ConfigInfo.CAR_MEMBER)
                {
                   let IsChildren = DataDic.object(forKey: "IsChildren") as! String;
                   ConfigInfo.m_bIsChildren = (IsChildren == "1") ? true : false;
                }
                
                
                ConfigInfo.m_strUserID = m_textAccount.text!;
                ConfigInfo.m_strPassword = m_textPassword.text!;
                
                if(Int(MemberType) == ConfigInfo.CAR_MEMBER)
                {
                     //實體會員註冊流程
                     let strMobile = DataDic.object(forKey: "Mobile") as! String;
                    
                    GotoAccCodeCardVirify(strPhone: strMobile);
                    
                }else
                {
                    GotoAccCodeVirify();
                }
            }else if(Int(strCode) == ConfigInfo.CHILDREN_CARD_VAILD)  //
            {
                
                ShowAlertControl(Message: "會員為兒童卡會員，年齡未滿13歲，不可以註冊APP會員。");
            }else if(Int(strCode) == -31)
            {
                let alert = UIAlertController(title: "系統資訊", message: "您輸入的帳號並非身份證字號，請確認是否正確？", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:  "正確", style: .default) { (UIAlertAction) in
                    
                    ConfigInfo.m_strUserID = self.m_textAccount.text!;
                    
                    ConfigInfo.m_strPassword = self.m_textPassword.text!;
                    
                    self.GotoAccCodeVirify();
                 });
                
                alert.addAction(UIAlertAction(title: "不正確", style: .default, handler: nil))
                self.present(alert, animated: true)
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
    
    
    
    func GotoAccCodeVirify()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        let  btAccCode
        = StoryBoard.instantiateViewController(withIdentifier: "AccCodeVerify");
        self.navigationController?.pushViewController(btAccCode, animated: true)
    }
    
    
    func GotoAccCodeCardVirify(strPhone: String )
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btAccCode
            = StoryBoard.instantiateViewController(withIdentifier: "AccCodeCardVerify") as! AccCodeCardViewController;
        
        btAccCode.m_strPhoneNumber  = strPhone;
        
        self.navigationController?.pushViewController(btAccCode, animated: true)
    }
    
    
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if m_textAccount == textField {
            
            //限制只能输入数字，不能输入特殊字符
            if(string.count==0)  {return true;}
            
            //let userName = string.trimmingCharacters(in: CharacterSet.whitespaces)
            let regex =  "^[a-zA-Z0-9]$"
            
            let predicate = NSPredicate(format:"SELF MATCHES %@",regex)
            
            let result = predicate.evaluate(with: string)
            
            return result
        }
        
        return false
    }
    
  
  
    
    
}
