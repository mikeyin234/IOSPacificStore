//
//  TradeCodeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/3/15.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class MobileEditCodeViewController: BaseViewController , UITextFieldDelegate{

    
    @IBOutlet weak var m_MobileCodeTF:UITextField!
    
    var  m_iTotalSeconds  = 0;
    var timer: Timer?
    
    var   m_strMobileBarcode = "";
    let   MAX_PHONE_CODE_LENGTH = 8;
    
    //kDCQueryBarcode
    override func viewDidLoad() {
        super.viewDidLoad()

        
        m_MobileCodeTF.text  =  m_strMobileBarcode;
        
        m_MobileCodeTF.delegate = self;
       
        
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        //=====================================//
        
    }
    

    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    //Save
    @IBAction func onCloseClick(_ sender:UIButton)
    {
        //零欄位
        if(m_MobileCodeTF.text?.count == 0 ||  isValidMobileBarcode(Barcode: m_MobileCodeTF.text!))
        {
            MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
            
            DCUpdater.shared()?.updateMobileCode(m_MobileCodeTF.text, andAccessToken: ConfigInfo.m_strAccessToken);
            
        }else
        {
            ShowAlertControl(Message: "手機條碼格式不附")
        }
    }
    
    
    //返回兩層
    @IBAction func onMemberTradeCodeClick(_ sender:UIButton)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
       
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryBarcode), name:NSNotification.Name(rawValue: kDCUpdateMobileCode), object: nil)
        
       
        self.SetTitleColor();
        super.viewWillAppear(animated)
        
//==================================================//
        self.startTimeTick();
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        return newText.count <= MAX_PHONE_CODE_LENGTH;
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
         guard let text = textField.text else { return true }
        
         let newLength = text.count + string.count - range.length
        
         return newLength <= MAX_PHONE_CODE_LENGTH
        
    }
    
    
    ///////////////////
    ///消費記錄
    @objc func didQueryBarcode(notification: NSNotification)
    {
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
                self.navigationController?.popViewController(animated: true);
                
            }else  if(Int(strCode) == -15)
            {
                let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                let  btPurchaseDevice  =  StoryBoard.instantiateViewController(withIdentifier: "Login");
                self.navigationController?.replaceTopViewController(with: btPurchaseDevice, animated: true)
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
        
    }
    
   
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
      return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    
    
    static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
           let dateFormatter = DateFormatter.init()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let date = dateFormatter.date(from: string)
           return date!
    }
        
    
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            
            filter.setValue(data, forKey: "inputMessage")
            
            
            let transform = CGAffineTransform(scaleX: 4, y: 4)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        RemoveTitleBar()
        
        self.timer?.invalidate();
        
    }
    
    
    
    func isValidMobileBarcode(Barcode: String) -> Bool {
        
        
        if(Barcode.count != 8 || Barcode.prefix(1) != "/")
        {
            return false;
        }
        
        
        let strBarcodeEnd = Barcode.suffix(7);
        let mobileBarcodeRegEx1 = "^.*[a-z]+.*$";
        let mobileBarcodeRegEx2 = "^.*[~`!@#$%^&*()_={}'\";:<>,?/]+.*$";
        
        let mobileBarcodePred1 = NSPredicate(format:"SELF MATCHES %@", mobileBarcodeRegEx1);
        let mobileBarcodePred2 = NSPredicate(format:"SELF MATCHES %@", mobileBarcodeRegEx2);
        
        if(mobileBarcodePred1.evaluate(with: strBarcodeEnd) ||
           mobileBarcodePred2.evaluate(with: strBarcodeEnd))
        {
            return  false;
        }
        
        return  true;
        
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
