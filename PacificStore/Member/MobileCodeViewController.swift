//
//  TradeCodeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/3/15.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class MobileCodeViewController: BaseViewController {

    
    @IBOutlet weak var m_labelNoMobileCode:UILabel!
    
    
    @IBOutlet weak var m_imageBarcodeImage:UIImageView!
    @IBOutlet weak var m_labelBarcode:UILabel!
    
    var  m_iTotalSeconds  = 0;
    var timer: Timer?
    
    var   m_strMobileBarcode = "";
    
    var  m_fDefaultBright:CGFloat = 0.0;
    
    
    //kDCQueryBarcode
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        m_labelNoMobileCode.isHidden  = true;
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func onCloseClick(_ sender:UIButton)
    {
        
        UIScreen.main.brightness = ConfigInfo.m_fDefaultBright;
        
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btMobileEditCode
            = StoryBoard.instantiateViewController(withIdentifier: "MobileEditCode") as! 
        MobileEditCodeViewController
        
        btMobileEditCode.m_strMobileBarcode =  m_strMobileBarcode;
        
        self.navigationController?.pushViewController(btMobileEditCode, animated: true)
    }
    
    
    @IBAction override func onHomeClick(_ sender:UIButton)
    {        
        UIScreen.main.brightness = ConfigInfo.m_fDefaultBright;
        
        self.navigationController?.popToRootViewController(animated: true)
        
        //mike add at 22/04/26
        let  viewController  =  UIApplication.topViewController()  as!  ViewController;
        viewController.RefershMainPage();
        
    }
    
    
    
    @IBAction func onMemberTradeCodeClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
        
    }
    
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
       
        m_imageBarcodeImage.isHidden = true;
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryBarcode), name:NSNotification.Name(rawValue: kDCQueryMobileCode), object: nil)
        
       
        self.SetTitleColor();
        super.viewWillAppear(animated)
        
//==================================================//
        self.startTimeTick();
        
        
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.queryMobileCode(ConfigInfo.m_strAccessToken);
        m_labelBarcode.text  = "";
        
        
        UIScreen.main.brightness = CGFloat(0.9)
        
        
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
                
                m_labelNoMobileCode.isHidden  =  true;
                m_imageBarcodeImage.isHidden  =  false;
                
                m_strMobileBarcode =  dic.object(forKey: "MobileBarcode") as! String;
                m_imageBarcodeImage.image  = generateBarcode(from: m_strMobileBarcode);
                m_labelBarcode.text  = m_strMobileBarcode;
                
            }else  if(Int(strCode) == -56)
            {
                m_labelNoMobileCode.isHidden  =  false;
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
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
