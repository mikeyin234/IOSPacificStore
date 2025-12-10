//
//  ModifyPasswordViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/2/19.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class ModifyPasswordViewController: BaseViewController, UITextFieldDelegate{

    @IBOutlet weak var m_textOldPassword:UITextField!
    @IBOutlet weak var m_textPassword:UITextField!
    @IBOutlet weak var m_textConfirmPassword:UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
        
        NotificationCenter.default.addObserver(self, selector:#selector(didChangePasswordResult), name:NSNotification.Name(rawValue: kDCChangePassword), object: nil)
        
        
        self.startTimeTick();
    }
    
    
    @objc func didChangePasswordResult(notification: NSNotification){
        
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
                let alert = UIAlertController(title: "系統資訊", message: "密碼修改成功!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (UIAlertAction) in
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }))
                
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
        
        
//============================================
        self.stopTimeTick();
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_PASSOWRD_CHANGE), andDuration: Int32(self.durationSeconds()),
                                           andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
    }
    
    
    
    @IBAction func onModifyPasswordClick(_ sender:UIButton)
    {
        if(m_textOldPassword.text?.count == 0)
        {
            ShowAlertControl(Message: "舊密碼不能為空");
            return;
        }
        
        if(m_textPassword.text?.count == 0)
        {
            ShowAlertControl(Message: "新密碼不能為空");
            return;
        }
        
        
        if(m_textPassword.text != m_textConfirmPassword.text)
        {
            ShowAlertControl(Message: "新密碼與確認密碼不同!");
            return;
        }
        
        
        if((m_textPassword.text?.count)! < 4 ||
            (m_textPassword.text?.count)! > 12)
        {
            ShowAlertControl(Message: "密碼長度須為4 - 12碼");
            return;
        }
        
        
       
        MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        
        DCUpdater.shared()?.modifyPassword(ConfigInfo.m_strAccessToken, andOldPassword: m_textOldPassword.text, andNewPassword: m_textPassword.text)
        
    }
    

    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
            textField.resignFirstResponder()
            return false
       
    }
    
    
}
