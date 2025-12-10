//
//  FPChangePasswordViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/2/19.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class FPChangePasswordViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var m_textPassword:UITextField!
    @IBOutlet weak var m_textConfirmPassword:UITextField!
    var   m_strAccount = "";
    
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
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
        
        NotificationCenter.default.addObserver(self, selector:#selector(didChangePasswordResult), name:NSNotification.Name(rawValue: kDCForgetPasswordChange), object: nil)
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
    }
    
    
    
    @IBAction func onAccCodeVerifyClick(_ sender:UIButton)
    {
        if(m_textPassword.text?.count == 0)
        {
            ShowAlertControl(Message: "密碼不能為空");
            return;
        }
        
        if(m_textPassword.text != m_textConfirmPassword.text)
        {
            ShowAlertControl(Message: "密碼與確認密碼不同!");
            return;
        }
        
        MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        
        DCUpdater.shared()?.forgetPasswordChange(m_strAccount, andNewPassword: m_textPassword.text)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
        
    }
    
    
    
}
