//
//  TradeCodeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/3/15.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class TradeCodeViewController: BaseViewController {

    
    @IBOutlet weak var m_labelTime:UILabel!
    @IBOutlet weak var m_imageBarcodeImage:UIImageView!
    @IBOutlet weak var m_labelBarcode:UILabel!
    
    
    var  m_iTotalSeconds  = 0;
    
    
    var timer: Timer?
    
    
    @IBOutlet var m_imageViewCard : UIImageView!
    
    
    
    //kDCQueryBarcode
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        
        
//=====================================//
        m_labelTime.text  =  "";
        m_labelBarcode.text  = "";
        
        DCUpdater.shared()?.getMemberInfo(ConfigInfo.m_strAccessToken)
        
    }
    
    
    func SetCardType()
    {
        //1  2  3  4  5 6
        let CardImage:[String] = ["jinli_card","sliver_card","golden_card","black_card","app_card","jinli_card","jinli_card"];
        if(ConfigInfo.m_iCardType <= 0)
        {
            ConfigInfo.m_iCardType  = 5;
        }
        let strCardType  = ConfigInfo.CardType[ConfigInfo.m_iCardType-1];
        //m_menuOption[0] = m_strCardNameTitle;
        m_imageViewCard.image =  UIImage(named: CardImage[ConfigInfo.m_iCardType-1]);
        
    }
    
    
    @objc func didMemberInfoResult(notification: NSNotification){
        
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
                
                //Remark later
                ConfigInfo.m_iCardType = Int(DataDic.object(forKey: "CardLevel") as! String)!;
                
            }
            
            SetCardType();
            
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
       
        self.navigationController?.popViewController(animated: true);
    }
    
    
   
    
    
    
    
    @IBAction func onCloseClick(_ sender:UIButton)
    {
        
        UIScreen.main.brightness = ConfigInfo.m_fDefaultBright;
        
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btPTradeCodeInfo
            = StoryBoard.instantiateViewController(withIdentifier: "MobileCode");
        
        self.navigationController?.pushViewController(btPTradeCodeInfo, animated: true)
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
       
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryBarcode), name:NSNotification.Name(rawValue: kDCQueryBarcode), object: nil)
        
       
        
        NotificationCenter.default.addObserver(self, selector:#selector(didMemberInfoResult), name:NSNotification.Name(rawValue: kDCGetMemberInfo), object: nil)
        
        
        
        self.SetTitleColor();
        super.viewWillAppear(animated)
        
//==================================================//
        self.startTimeTick();
        
        
        //mike move on load code to here
        m_labelTime.text  =  "";
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.queryBarcode(ConfigInfo.m_strAccessToken);
        
       
        UIScreen.main.brightness = CGFloat(0.9)
        
    }
    
    
    @IBAction override func onHomeClick(_ sender:UIButton)
    {
        
        UIScreen.main.brightness = ConfigInfo.m_fDefaultBright;
        
        
        
        
        self.navigationController?.popToRootViewController(animated: true)
        
        //mike add at 22/04/26
        let  viewController  =  UIApplication.topViewController()  as!  ViewController;
        viewController.RefershMainPage();
        
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
                let dicData =  dic.object(forKey: "Data") as! NSDictionary;
                let  strRferrerCode  = dicData.object(forKey: "member_token") as! String;
                if(strRferrerCode.count > 0 )
                {
                    let  strDateExpire  = dicData.object(forKey: "exp_datetime") as! String
                    
                    let endDate = TradeCodeViewController.stringConvertDate(string: strDateExpire, dateFormat: "yyyy-MM-dd HH:mm:ss")
                    let diffComponents = Calendar.current.dateComponents([.minute, .second], from: Date(), to: endDate)
                    
                    let minute = diffComponents.minute
                    let second = diffComponents.second
                    
                    m_iTotalSeconds = minute! * 60 + second!;
                    m_imageBarcodeImage.image  = generateBarcode(from: strRferrerCode);
                    m_labelBarcode.text  = strRferrerCode;
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                }
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
    
    @objc func timerAction(){
        
        m_iTotalSeconds = m_iTotalSeconds - 1;
        if(m_iTotalSeconds <= 0)
        {
            m_iTotalSeconds = 0 ;
            self.timer?.invalidate();
        }
        
        
//===============================//
        let iMinuteSeconds  = secondsToHoursMinutesSeconds(seconds: m_iTotalSeconds);
//=====================================================================
        m_labelTime.text  = "\(String(format: "%02d", iMinuteSeconds.0)):\( String(format: "%02d", iMinuteSeconds.1))"
        
       
        
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
