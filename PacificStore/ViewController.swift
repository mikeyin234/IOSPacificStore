//
//  ViewController.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/11.
//  Copyright © 2019年 greatsoft. All rights reserved.
//
import UIKit
import FirebaseMessaging
import AVFoundation


class ViewController: BaseSliderViewController,UIScrollViewDelegate ,
UITableViewDelegate,UITableViewDataSource{
    
    var m_imageBigMain:[NSDictionary] =  [];
    var m_imageSmallMain:[NSDictionary] =  [];
    var m_imageCache  = NSMutableDictionary();
    
//======mike add at 2019  12  25====================//
    @IBOutlet weak var m_textUnReadCount: UILabel!
    @IBOutlet var m_btnCardCode : UIButton!
    
    var m_MainHSCrollTableViewCell: MainHScrollTableViewCell! = nil;
    
//===============================================//
    @IBOutlet weak var m_uiPopupADBG:UIView!
    @IBOutlet weak var m_uiPopupAD:UIView!
    
    @IBOutlet weak var m_uiImageClose:UIImageView!
    @IBOutlet weak var m_uiImageAD:UIImageView!
    @IBOutlet weak var mTableview: UITableView!
    
    
    
    var  m_iId = -1;
    var  m_strImageName = "";
    var  m_iDayDisplayCount = 0;
    var  m_iJumpPage = 0;
    var  m_strPageName =  "";
    
    
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return m_imageSmallMain.count + 1;
    }
    
    
    func downloaded(from url: URL,cell: ImageTableViewCell) {
        
        fetchImage(from: url.absoluteString) { image in
            // IMPORTANT: Update UI on the main thread
            DispatchQueue.main.async {[] in
                self.m_imageCache.setObject(image!, forKey: url.absoluteString as NSString)
                cell.LoadData(image: image!);
            }
        }                
       }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:UITableViewCell!;
        
        if(indexPath.row == 0)
        {
            Mycell  = tableView.dequeueReusableCell(withIdentifier: "HScrollcell")
            
            if( Mycell == nil)
            {
                let cell:MainHScrollTableViewCell  = MainHScrollTableViewCell(style: .default, reuseIdentifier: "HScrollcell")
                
                 Mycell = cell;
            }
            
            let MyCell2 = Mycell as! MainHScrollTableViewCell;
            MyCell2.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
            MyCell2.LoadData(dataArray: m_imageBigMain)
            
            
            MyCell2.m_ParentViewController = self;
            
            m_MainHSCrollTableViewCell = MyCell2;
            
            self.AddOnTouchClick(vTouch: MyCell2.m_scrollView,action: #selector(self.onMainImageViewClick));
            
        }else
        {
            
            let cell: ImageTableViewCell = ImageTableViewCell(style: .default, reuseIdentifier: "Imagecell")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
           
            let  dataDir  = m_imageSmallMain[indexPath.row-1]
            let url = URL(string:dataDir.object(forKey: "ImageName") as! String);
            
            if  let cachedImage = m_imageCache.object(forKey: url!.absoluteString as NSString)
            {
                cell.LoadData(image: cachedImage as! UIImage);
            }else
            {
                
                downloaded(from: url!,cell: cell);
                
            }
         
            Mycell = cell;
        }
        
        return Mycell
        
    }
    
    
    @objc func  onMainImageViewClick(_ sender: UITapGestureRecognizer)
    {
        let iTag  = sender.view?.tag;
        
        if(m_imageBigMain.count > 0)
        {
            let iType = Int32(m_imageBigMain[iTag!].object(forKey: "UploadType") as! String);
            if(iType == 1)
            {
                let strYoutubeID = m_imageBigMain[iTag!].object(forKey: "YoutubeID") as! String
                
                ////////////////////////////////////////////////
                //有String 才會去play......
                if(strYoutubeID.count > 0)
                {
                     m_MainHSCrollTableViewCell.LoadPlayer(strYoutubeID: strYoutubeID);
                }
                
            }else if(iType == 2)  //FB PLAYER
            {
                let strYoutubeID = m_imageBigMain[iTag!].object(forKey: "YoutubeID") as! String
                
                UIApplication.shared.open(URL(string: strYoutubeID)!, options:[:],completionHandler: nil);
                
            }
            else
            {
                 let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                 let  btSubNavBrandMain
                            = StoryBoard.instantiateViewController(withIdentifier: "MainAd") as! MainADViewController;
                
                btSubNavBrandMain.m_strWebPage   = m_imageBigMain[iTag!].object(forKey: "WebPage") as! String
                btSubNavBrandMain.m_strTitle   = m_imageBigMain[iTag!].object(forKey: "Name") as! String
                self.navigationController?.pushViewController(btSubNavBrandMain, animated: true)
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //return UITableViewAutomaticDimension
        if(indexPath.row == 0)
        {
            return CGFloat(MainHScrollTableViewCell.MainHeight);
        }
        return CGFloat(ImageTableViewCell.MainHeight);        
    }
    
    
    
    
    //@IBOutlet weak var mScrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        //let strDateStart = ConfigInfo.funcDateAddMonth(iMonth: 6);
        // Do any additional setup after loading the view, typically from a nib.
        //
        LoadToUserInfo();
        
        if(!isKeyPresentInUserDefaults(key: "IsFirstIn"))
        {
            let myUserDefaults = UserDefaults.standard;
            
            myUserDefaults.set(false , forKey: "IsFirstIn")
            myUserDefaults.synchronize();
            
            ConfigInfo.m_bIsViewMemberLogin = true;
            
            goMemberCenter();
            
        }else
        {
            //RefershMainPage();
            ConfigInfo.m_bIsViewMemberLogin = false;
        }
        
        m_textUnReadCount.layer.cornerRadius = m_textUnReadCount.frame.width/2
        
        
        /*
        if(Messaging.messaging().fcmToken != nil)
        {
            ConfigInfo.FCM_DEVICE_TOKEN = Messaging.messaging().fcmToken!;
        }
        */
        DCUpdater.shared()?.checkUpdateType();
        
        
        m_uiPopupADBG.isHidden = true;
        m_uiPopupAD.isHidden = true;
        
        AddOnTouchClick(vTouch: m_uiImageClose, action: #selector(onCloseAdClick));
        
        AddOnTouchClick(vTouch: m_uiImageAD, action: #selector(onNotifyAdClick));
        
        //=======================================
        //add at
        DCUpdater.shared()?.queryADInterval();
        
        /////////////////////////////////////////////////////////
        //for test 2023/07/30
        //GotoFinalRegisterVirify();
        
        
   }
    
   func LoadNotifyAD()
   {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       if(appDelegate.m_bCanLoadAD)
       {
           
           DCUpdater.shared()?.checkNotifyPage(appDelegate.m_PageViewInfo.m_PageViewInfoArray);
           
           appDelegate.m_bCanLoadAD  = false;
       }
       
   }
    
    
    @objc func  onCloseAdClick(_ sender: UITapGestureRecognizer)
    {
        m_uiPopupADBG.isHidden = true;
        m_uiPopupAD.isHidden = true;
    }
    
    func RefershMainPage()
    {
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getMainHomePageExt();
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        ////////////////////////////
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.m_bFirstRun =  false;
        
        if(appDelegate.m_bClickPushAlert)
        {
            //只有在 APP 關掉時，才用這個。
            ConfigInfo.m_strSendTime =  appDelegate.m_strSendTime;
            ConfigInfo.m_bIsClickPush = appDelegate.m_bClickPushAlert;
            appDelegate.m_bClickPushAlert  = false;
            
            GotoMemberCenter();
            
            return ;            
        }
        
        if(ConfigInfo.m_bIsViewMemberLogin) {return;}
        
        if(m_imageBigMain.count == 0 )
        {
            RefershMainPage();
        }
        
        GetUnReadMessageCount();
        
        SetTitleColor()
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetMainResult), name:NSNotification.Name(rawValue: kDCGetMainHomePageExt), object: nil)
        
        
         NotificationCenter.default.addObserver(self, selector:#selector(didGetUnReadMessageResult), name:NSNotification.Name(rawValue: kDCGetUnReadMessage), object: nil)
        
        
         NotificationCenter.default.addObserver(self, selector:#selector(didGetUpdateTypeResult), name:NSNotification.Name(rawValue: kDCGetUpdateType), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didCheckNotifyPageResult), name:NSNotification.Name(rawValue: kDCCheckNotifyPage), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryMainAdInterval), name:NSNotification.Name(rawValue: kDCQueryMainAdInterval), object: nil)
        
        
        
        
        m_btnCardCode.isHidden =  ConfigInfo.m_bMemberLogin ? false : true;
        
        if(ConfigInfo.m_bMemberLogin)
        {
           
            let deviceId = UIDevice.current.identifierForVendor?.uuidString
            
           if(ConfigInfo.FCM_DEVICE_TOKEN.count > 0)
           {
                DCUpdater.shared()?.updatePushToken(deviceId, pushToken: ConfigInfo.FCM_DEVICE_TOKEN, accessToken: ConfigInfo.m_strAccessToken);            
           }
        }
        
        
        self.startTimeTick();
        
        GotoMemberCenter();
        
        
        
        
        ConfigInfo.m_bAlreadyRun = true;
       
    }
    
    
    func GotoMemberCenter()
    {
        if(ConfigInfo.m_bIsClickPush)
        {
            if(ConfigInfo.m_bMemberLogin)
            {
                let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                
                let  btMemberCenter
                    = StoryBoard.instantiateViewController(withIdentifier: "MemberCenter");
                
                self.navigationController?.pushViewController(btMemberCenter, animated: false)
            }else
            {
                //////////////////////////////////
                //add at 2021   10   30
                LoadNotifyAD();
            }
        }else
        {
            //////////////////////////////////////
            //add at 2021   10   30
            LoadNotifyAD();
        }
    }
    
    @objc func didGetUpdateTypeResult(notification: NSNotification){
           
           //do stuff
           let userInfo = notification.userInfo as NSDictionary?;
           let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
           if(strSuccess.isEqual(to: "YES"))
           {
               let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
               let  strCode = dic.object(forKey: "ReturnCode") as! String;
               
               if(Int(strCode) == 0)
               {
                    let   dataArray  = dic.object(forKey: "Data") as! NSArray;
                    let valueDic = dataArray.object(at: 0) as! NSDictionary
                
                    let Value = valueDic.object(forKey: "Value") as! String
                    if(needsUpdate())
                    {
                        if(Int32(Value) == 0)
                        {
                            self.ShowUpdateControl(strTitle: "版本更新提示",strMessage: "發現有新版本，是否要立即更新!");
                        }else
                        {   
                            self.ShowForceUpdateControl(strTitle: "版本更新提示",strMessage: "發現有新版本，是否要立即更新!");
                        }
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
    
    
    //didGetUpdateType
    @objc func didGetMainResult(notification: NSNotification){
        
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        
        m_imageBigMain.removeAll();
        m_imageSmallMain.removeAll();
        m_imageCache.removeAllObjects();
        
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            if(Int(strCode) == 0)
            {               
                let DataArray = dic.object(forKey: "Data") as! NSArray;
                
                for DataDic  in DataArray
                {
                    let strType  = Int((DataDic as! NSDictionary).object(forKey: "Type") as! String);
                    
                    if(strType == 0)
                    {
                        m_imageBigMain.append(DataDic as! NSDictionary);
                    }else
                    {
                        m_imageSmallMain.append(DataDic as! NSDictionary);
                    }
                }
                mTableview.reloadData();
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
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCGetMainHomePageExt), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCGetUnReadMessage), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCGetUpdateType), object: nil)
        self.RemoveTitleBar();
        
        
//================================================================================//
        self.stopTimeTick();
        
        RemoveTitleBar();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_MAIN_HOME), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.m_PageViewInfo.Save();
        
        
        
        /////////////////////////////////////////////////////
        //2022/05/11
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
    }
    
    
    @IBAction func sliderClick(_ sender: AnyObject) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    
    
    func goMemberCenter()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        if(!ConfigInfo.m_bMemberLogin)
        {
            let  btPurchaseDevice
                = StoryBoard.instantiateViewController(withIdentifier: "Login");
            
            self.navigationController?.pushViewController(btPurchaseDevice, animated: true)
        }else
        {
            
            let  btMemberCenter
                = StoryBoard.instantiateViewController(withIdentifier: "MemberCenter");
            
            self.navigationController?.pushViewController(btMemberCenter, animated: true)
            
        }
    }
    
    //======onMemberCenter=================================
    @IBAction func onMemberCenter(_ sender: AnyObject) {
        
        goMemberCenter();
        
    }
    
    
    @IBAction func onNavBrandCenter(_ sender: AnyObject) {
        
        ShowNavBrandCenter();
        
    }
    
    func ShowNavBrandCenter()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btNavBrandMain
            = StoryBoard.instantiateViewController(withIdentifier: "NavBrandMain");
        
        self.navigationController?.pushViewController(btNavBrandMain, animated: true)
    }
    
    @IBAction func onNews(_ sender: AnyObject) {
        
        ShowNews();
        
    }
    
    
    func  ShowNews()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btNavBrandMain
            = StoryBoard.instantiateViewController(withIdentifier: "NewsList");
        
        self.navigationController?.pushViewController(btNavBrandMain, animated: true)
    }
    
    @IBAction func onFoods(_ sender: AnyObject) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btFoodList
            = StoryBoard.instantiateViewController(withIdentifier: "FoodList");
        
        self.navigationController?.pushViewController(btFoodList, animated: true)
        
    }
    
    
    
   
    
    
    @IBAction func onDMInfo(_ sender: AnyObject) {
        
        ClickDMInfo();
        
    }
    
    func ClickDMInfo()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btDMOnline
            = StoryBoard.instantiateViewController(withIdentifier: "DMOnLine");
        
        self.navigationController?.pushViewController(btDMOnline, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0)
        {
            
        }
        else if(indexPath.row >= 1 )
        {
            let iType = Int32(m_imageSmallMain[indexPath.row-1].object(forKey: "UploadType") as! String);
            
            if(iType == 0)
            {
                
                let IsJumpFloor   = m_imageSmallMain[indexPath.row-1].object(forKey: "IsJumpFloor") as! String
               
                if(IsJumpFloor == "1")
                {
                    let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                    
                    let  btNavBrandMain
                               = StoryBoard.instantiateViewController(withIdentifier: "NavBrandMain") as! NavMainViewController;
                    self.navigationController?.pushViewController(btNavBrandMain, animated: true)
                }else
                {
                
                   let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                    
                   let  btSubNavBrandMain
                       = StoryBoard.instantiateViewController(withIdentifier: "MainAd") as! MainADViewController;
                
                   btSubNavBrandMain.m_strWebPage   = m_imageSmallMain[indexPath.row-1].object(forKey: "WebPage") as! String
                
                   btSubNavBrandMain.m_strTitle   = m_imageSmallMain[indexPath.row-1].object(forKey: "Name") as! String
                 
                   self.navigationController?.pushViewController(btSubNavBrandMain, animated: true)
                    
                }
            }else
            {
                let strYoutubeID =  m_imageSmallMain[indexPath.row-1].object(forKey: "YoutubeID") as! String
                UIApplication.shared.open(URL(string: strYoutubeID)!, options:[:],completionHandler: nil);
            }
        }
    }
    
    
    
    
    @IBAction func onParkingInfo(_ sender: AnyObject) {
        
        let fortest  = true;
        
        if(!fortest)
        {
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            let  btParkingInfo
                          = StoryBoard.instantiateViewController(withIdentifier: "PurchaseView");
            self.navigationController?.pushViewController(btParkingInfo, animated: true)
        }else
        {
            if let url = URL(string: ConfigInfo.PURCHASE_SITE) {
                UIApplication.shared.open(url, options: [:])
            }
        }
           
          
            
    }
    
    
    @IBAction func onFaceBookClick(_ sender:UIButton)
    {
        //OnGameLink()
        
        if let url = URL(string:ConfigInfo.FB_SITE) {
            UIApplication.shared.open(url, options: [:])
        }
        
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_FACEBOOK), andDuration: Int32(2), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
    }
    
    
    @IBAction func onLineClick(_ sender:UIButton)
    {

        /*
        if let url = URL(string: "https://goo.gl/AoMrQG") {
            UIApplication.shared.open(url, options: [:])
        }*/
        
    }
    
    
    @IBAction func onMemberCardInfo(_ sender: AnyObject) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "MemberCode");
        
        self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }
    
    
    func LoadToUserInfo()
    {
        let myUserDefaults = UserDefaults.standard;
        
        ConfigInfo.m_bMemberLogin  = myUserDefaults.bool(forKey:  "IsLogin")
        
        if(isKeyPresentInUserDefaults(key: "UserID"))
        {
             ConfigInfo.m_strUserID =  myUserDefaults.string(forKey: "UserID")!;
        }
       
        if(isKeyPresentInUserDefaults(key: "Password"))
        {
            ConfigInfo.m_strPassword =  myUserDefaults.string(forKey: "Password")!;
        }
        
        if(ConfigInfo.m_bMemberLogin)
        {
            ConfigInfo.m_SerialNo =  myUserDefaults.string(forKey: "SerialNo")!;
            ConfigInfo.m_strAccessToken =  myUserDefaults.string(forKey: "AccessToken")!;
            
            ConfigInfo.m_strName =  myUserDefaults.string(forKey: "Name")!;
            
            ConfigInfo.m_strPhone =  myUserDefaults.string(forKey: "PhoneNumber")!;
            ConfigInfo.m_strCardNumber =  myUserDefaults.string(forKey: "CardNumber")!;
            
            ConfigInfo.m_strBirthday =  myUserDefaults.string(forKey: "Birthday")!;
            ConfigInfo.m_strZip =  myUserDefaults.string(forKey: "ZIP")!;
            
            ConfigInfo.m_strAddr =  myUserDefaults.string(forKey: "ADDR")!;
            ConfigInfo.m_strSex =  myUserDefaults.string(forKey: "Sex")!;
            
            ConfigInfo.m_iMemberType =  myUserDefaults.integer(forKey:  "MemberType");
            ConfigInfo.m_iCardType =  myUserDefaults.integer(forKey: "CardType");
            
            
            if(isKeyPresentInUserDefaults(key: "City"))
            {
               ConfigInfo.m_strCity =  myUserDefaults.string(forKey: "City")!;
               ConfigInfo.m_strArea =  myUserDefaults.string(forKey: "Area")!;
            }
            
            
        }
    }
    
    
  
    
    func GetUnReadMessageCount()
    {
         if(ConfigInfo.m_strAccessToken.count > 0 )
         {
            DCUpdater.shared()?.getUnReadMsgCount(ConfigInfo.m_strAccessToken)
         }
    }
    
    
    @objc func  didGetUnReadMessageResult(notification: NSNotification)
    {
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            if(Int(strCode) == 0)
            {
                ConfigInfo.m_iUnReadMsgCount = Int(dic.object(forKey: "Count") as! Int64);
            }else
            {
                ConfigInfo.m_iUnReadMsgCount = 0;
            }
            
            m_textUnReadCount.text  = "\(ConfigInfo.m_iUnReadMsgCount)";
            
            if(ConfigInfo.m_iUnReadMsgCount == 0)
            {
                m_textUnReadCount.isHidden =  true;
            }else
            {
                 m_textUnReadCount.isHidden =  false;
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
        
    }
    
    @IBAction  func OnVideoListLink()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btVideoListBank
            = StoryBoard.instantiateViewController(withIdentifier: "VideoList");
        
        self.navigationController?.pushViewController(btVideoListBank, animated: true)
        
    }
    
    
    func needsUpdate() -> Bool {
        
        let infoDictionary = Bundle.main.infoDictionary
        let appID = infoDictionary!["CFBundleIdentifier"] as! String
        
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID)")
        
        guard let data = try? Data(contentsOf: url!) else {
          print("There is an error!")
          return false;
        }
        
        let lookup = (try? JSONSerialization.jsonObject(with: data , options: [])) as? [String: Any]
        
        if let resultCount = lookup!["resultCount"] as? Int, resultCount == 1 {
            if let results = lookup!["results"] as? [[String:Any]] {
                if let appStoreVersion = results[0]["version"] as? String{
                    let currentVersion = infoDictionary!["CFBundleShortVersionString"] as? String
                    
                    if (appStoreVersion > currentVersion!)
                    {
                        return true
                    }
                    
                    //Remark Later......
                    //return true;
                }
            }
        }
        return false
    }
    
    
    @objc func ExitApplication() {
        exit(0);
    }
    
//=============================================================/high
    func ShowUpdateControl(strTitle:String,strMessage:String)
    {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:  "前往更新", style: .default) { (UIAlertAction) in
            
             Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.ExitApplication), userInfo: nil, repeats: false)
            
            self.OpenAppStore();
            
           
        })
        
        alert.addAction(UIAlertAction(title: "暫不更新", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    func ShowForceUpdateControl(strTitle:String,strMessage:String)
    {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:  "前往更新", style: .default) { (UIAlertAction) in
           
            
             Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.ExitApplication), userInfo: nil, repeats: false)
            
             self.OpenAppStore();
            
        })
        
        alert.addAction(UIAlertAction(title: "取消並離開", style: .cancel) { (UIAlertAction) in
            exit(0);
         });
        
        self.present(alert, animated: true)
    }
    
    
    
    func OpenAppStore()
    {
        let url = URL(string: "https://apps.apple.com/cn/app/%E5%A4%AA%E5%B9%B3%E6%B4%8B%E7%99%BE%E8%B2%A8%E8%B1%90%E5%8E%9F%E5%BA%97/id1344866373")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil);
        
        //exit(0);
    }
    
    
    func OnGameLink()
    {
        let  StoryBoard = UIStoryboard(name: "game" , bundle: nil)
        
        let  btMainGame
            = StoryBoard.instantiateViewController(withIdentifier: "MainGame");
        
        self.navigationController?.pushViewController(btMainGame, animated: true)
        
    }
    
    
    func toggleTorch(on: Bool) {
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                    
                    try? device.setTorchModeOn(level: 1.0)
                    
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    
    
    @objc func didQueryMainAdInterval(notification: NSNotification){
        
           //do stuff
           let userInfo = notification.userInfo as NSDictionary?;
           let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
           if(strSuccess.isEqual(to: "YES"))
           {
               let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
               let  strCode = dic.object(forKey: "ReturnCode") as! String;
               
               if(Int(strCode) == 0)
               {
                   let iInterval  = dic.object(forKey: "Interval") as! Int
                   m_MainHSCrollTableViewCell.ResetTimer(interval: iInterval);
               }
               
           }
       }
    
    
    
    
    @objc func didCheckNotifyPageResult(notification: NSNotification){
           
           //do stuff
           let userInfo = notification.userInfo as NSDictionary?;
           let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
           if(strSuccess.isEqual(to: "YES"))
           {
               let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
               let  strCode = dic.object(forKey: "ReturnCode") as! String;
               
               if(Int(strCode) == 0)
               {
                   let   valueDic  = dic.object(forKey: "Data") as! NSDictionary
                   
//================================================================================//
                   m_iId = Int(valueDic.object(forKey: "id") as! String)!
                   
                   m_strImageName = valueDic.object(forKey: "ImageName") as! String
                   
                   m_iDayDisplayCount = Int(valueDic.object(forKey: "DayDisplayCount") as! String)!
                   
                   m_iJumpPage = Int(valueDic.object(forKey: "JumpPage") as! String)!
                   m_strPageName = valueDic.object(forKey: "PageName") as! String
                   
//======================================================================================//
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   
                   let dirAD  = appDelegate.m_PageViewInfo.GetDictionary(ID: m_iId);
                   if(dirAD.count > 0)
                   {
                       var ViewCount = dirAD.value(forKey: "ViewPageCount") as! Int;
                       ViewCount += 1;
                       dirAD.setValue(ViewCount, forKey:  "ViewPageCount")
                   }else
                   {                       
                       dirAD.setValue(1, forKey:  "ViewPageCount")
                       dirAD.setValue(m_iId, forKey:  "id")
                       dirAD.setValue(ConfigInfo.GetCurDate(), forKey: "day")
                   }
                   
                   
                   let url = URL.initPercent(string: m_strImageName);
                   self.m_uiPopupADBG.isHidden = false;
                   self.m_uiPopupAD.isHidden = false;
                   
                   downloaded(from: url);
               }/*else
               {
                   ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
               }*/
           }else
           {
               ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
           }
           
                 
       }
    
    
    func downloaded(from url: URL) {
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard
                
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                               let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                               let data = data, error == nil,
                               let image = UIImage(data: data)
                   else { return }
            
            
               DispatchQueue.main.async() { [weak self] in
                   
                   self!.m_uiImageAD.image  = image;
                  
                   
               }
           }.resume()
       }
    
    
    
//=====================
    @objc func  onNotifyAdClick(_ sender: UITapGestureRecognizer)
    {
        switch(m_iJumpPage)
        {
            case 0:  //點數換好禮
               ConfigInfo.m_iNeedJumpPage =  0;
               goMemberCenter();
            break;
            case 1:  //小遊戲
               OnGameLink();
            break;
            case 2:  //專屬優惠
                ConfigInfo.m_iNeedJumpPage =  1;
                goMemberCenter();
            break;
            case 3:   //最新消息
               ShowNews();
            break;
            case 4:    //品牌導覽
               ShowNavBrandCenter();
            break;
            case 5:    //線上DM
             ClickDMInfo();
            break;
         default:  //don't do any action
            break;
        }
        
        self.m_uiPopupADBG.isHidden = true;
        self.m_uiPopupAD.isHidden = true;
        
    }
    
    
    func GotoFinalRegisterVirify()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btFinalRegister
            = StoryBoard.instantiateViewController(withIdentifier: "FinalRegister") as!  FinalRegisterViewController
        
        btFinalRegister.m_bResiterType = ConfigInfo.CAR_MEMBER;
        
        self.navigationController?.pushViewController(btFinalRegister, animated: true)
        
    }
    
    
}

