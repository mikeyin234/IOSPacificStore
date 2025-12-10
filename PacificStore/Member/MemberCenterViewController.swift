//
//  MemberCenterViewController.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/18.
//  Copyright © 2019年 greatsoft. All rights reserved.
//

import UIKit
import Mute


class MemberCenterViewController: BaseViewController ,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var tblMenuOptions : UITableView!
    
    let  APP_CARD_POLICY  = 0
    
    let  ACTIVITY_GAME    = 1
    let  MESSAGE_CENTRE   = 2
    let  POINT_QUERY      = 3
    //let  EXCLUSIVE_OFFER  = 2 //專屬優惠
    
    let  ELECTRON_VOUCHER   = 4   //我的電子贈卷
    
    
    let  QPOINT_LOTTERY  = 5                 //Q點/摸彩券
    
    let  CHANGE_GIFT_RECORD  = 6                 //點數換好禮/活動禮
    
    let  BILL_RESIGN  = 7                 //發票補登
    
    
    let  EXCHANGE_QUERY   = 8
    
    let  EXCLUSIVE_OFFER   = 9     //專屬優惠券
    
    let  MEMBER_INFO_MODIFY   = 10
    let  MODIFY_PASSWORD      = 11
    let  POLICY_CENTER        = 12
    let  LOGOUT      = 13
    
    
    /*
    let  POINT_QUERY      = 0
    let  MEMBER_INFO_MODIFY   = 1
    let  MODIFY_PASSWORD      = 2
    let  POLICY_CENTER        = 3
    let  LOGOUT      = 4
    */
    
    /*let m_menuOption = ["訊息中心","會員點數查詢","專屬優惠","全部兌換券查詢","會員資料修改",
                       "密碼修改","會員權益/隱私政策","登出"];*/
    
    //消費積點紀錄查詢   會員點數，  消費紀錄，
    var  m_menuOption = ["專屬福利","小遊戲-美人魚幸運籤","訊息中心","消費積點紀錄查詢","我的電子贈券","Q點/摸彩券", "點數換好禮/活動禮",
                        "發票補登", "全部兌換券查詢","專屬優惠券","會員資料修改",
                        "密碼修改","會員權益/隱私政策","登出"];
    
    //let m_menuOption = ["會員點數查詢","會員資料修改",
      //                  "密碼修改","會員權益/隱私政策","登出"];
    
//===============================================/
     @IBOutlet var m_labelName : UILabel!
     @IBOutlet var m_labelCardType : UILabel!
     @IBOutlet var m_imageViewCard : UIImageView!
    
    
//=================================================//
    @IBOutlet var m_uiView1 : UIView!
    @IBOutlet var m_uiView2 : UIView!
    @IBOutlet var m_uiView3 : UIView!
    @IBOutlet var m_uiView4 : UIView!
    
    
//==================================================//
    @IBOutlet var m_labelCurPoint : UILabel!  //點數
    @IBOutlet var m_labelEVoucher : UILabel!      //電子禮卷
    @IBOutlet var m_labelECVoucher : UILabel!      //電子抵用卷
    @IBOutlet var m_labelDiscountVoucher : UILabel!      //優惠卷
    var  m_strCardWebSite = "";
    
    
//=================================================//
    @IBOutlet var m_uiCardPolicyView : UIView!
    
    @IBOutlet var m_uiCardPolicyViewBG : UIView!
    
    
//===============================================//
    static var  m_bAlowModifyData = false
    static var  m_iEverydayCheckCount = 10
    static var  m_strAlertPersonalPolicy  = ""
    
    
    var m_bCheckAllowData  = true;
    
    //點數換好禮
    @objc func  onViewClick1(gesture: UITapGestureRecognizer)
    {
        onPointGift();
    }
   
    
    //電子禮卷
    @objc func  onViewClick2(gesture: UITapGestureRecognizer)
    {
        onElectronVoucher(iType: 1);
    }
    
    //電子抵用卷
    @objc func  onViewClick3(gesture: UITapGestureRecognizer)
    {
        onElectronVoucher(iType: 0);
    }
    
    //全部兌換卷查詢
    @objc func  onViewClick4(gesture: UITapGestureRecognizer)
    {
        onCuponCenter();
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
       
        
        m_uiCardPolicyView.isHidden = true
        m_uiCardPolicyViewBG.isHidden = true
        
        
       // Notify every 2 seconds
       Mute.shared.checkInterval = 1.0
       
       // Always notify on interval
       Mute.shared.alwaysNotify = true

       // Update label when notification received
       Mute.shared.notify = { [weak self] m in
           
           Mute.shared.alwaysNotify = false;
           ConfigInfo.m_bOpenVoice  = !m;
        
           //self!.SetPlayMute();
           
       }
        
       addRightBorder(view: m_uiView1, with: UIColor.gray, andWidth: 1)
       addRightBorder(view: m_uiView2, with: UIColor.gray, andWidth: 1)
       addRightBorder(view: m_uiView3, with: UIColor.gray, andWidth: 1)

        self.AddOnTouchClick(vTouch: m_uiView1,action: #selector(self.onViewClick1));
        self.AddOnTouchClick(vTouch: m_uiView2,action: #selector(self.onViewClick2));
        self.AddOnTouchClick(vTouch: m_uiView3,action: #selector(self.onViewClick3));
        self.AddOnTouchClick(vTouch: m_uiView4,action: #selector(self.onViewClick4));
        
//================================================//
        if(ConfigInfo.m_iNeedJumpPage !=  -1)
        {
            JumpToPage();
        }
    }
    
    func JumpToPage()
    {
        if(ConfigInfo.m_iNeedJumpPage == 0 )
        {
            onPointGift();
        }else if(ConfigInfo.m_iNeedJumpPage == 1)
        {
            onExclusiveOffer();
        }
        ConfigInfo.m_iNeedJumpPage = -1;        
    }
    
    
    
    func addTopBorder(view:UIView, with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: borderWidth)
        view.addSubview(border)
    }

    func addBottomBorder(view:UIView,with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: view.frame.size.height - borderWidth, width: view.frame.size.width, height: borderWidth)
        view.addSubview(border)
    }

    func addLeftBorder(view:UIView,with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: view.frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        view.addSubview(border)
    }

    func addRightBorder(view:UIView,with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: view.frame.size.width - borderWidth, y: 0, width: borderWidth, height: view.frame.size.height)
        view.addSubview(border)
    }
    
    
    
    func SetCardType()
    {
        //1  2  3  4  5 6
        let CardImage:[String] = ["jinli_card","sliver_card","golden_card","black_card","app_card","jinli_card","jinli_card"];
        
        if(ConfigInfo.m_iCardType <= 0)
        {
            ConfigInfo.m_iCardType  = 5;
        }
        //ConfigInfo.m_iCardType  = 4;
        
        let strCardType  = ConfigInfo.CardType[ConfigInfo.m_iCardType-1];
        //m_menuOption[0] = m_strCardNameTitle;
        
        
        m_imageViewCard.image =  UIImage(named: CardImage[ConfigInfo.m_iCardType-1]);
        
        
//===================================================//
        //m_labelName.text =  ConfigInfo.m_strName;
        //m_labelCardType.text =  "";
        
        //==============================
        let font = UIFont.systemFont(ofSize: 20)
        let firstAttributes: [NSAttributedString.Key: Any] =
        [
            .font: font,
            .foregroundColor: UIColor.gray
        ]
        
        
        let  NormalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let firstString = NSMutableAttributedString(string: strCardType, attributes: firstAttributes)
        
        let secondString = NSAttributedString(string: "\(ConfigInfo.m_strName)", attributes: NormalAttributes)
        
        
        let thirdString = NSAttributedString(string: "貴賓您好", attributes: firstAttributes)
        
        
        
        firstString.append(secondString)
        
        firstString.append(thirdString)
        
        m_labelName.attributedText = firstString;
        
    }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "CardPolicy")
        {
            let cardPolicyViewController =  segue.destination as!  CardPolicyViewController
            cardPolicyViewController.m_memberCenterViewController = self
        }
    }
    
    func onHideCardPolicy()
    {
        
        m_uiCardPolicyView.isHidden = true
        m_uiCardPolicyViewBG.isHidden = true
        
        
    }
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_menuOption.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MemberCenterCell")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        lblTitle.text =  m_menuOption[indexPath.row];
        
        ConfigInfo.m_DefaultTableCellColor = lblTitle.textColor;
        
        
        let lblTitleCount : UILabel = cell.contentView.viewWithTag(102) as! UILabel
        if(indexPath.row == 2)
        {
            lblTitleCount.text = "\(ConfigInfo.m_iUnReadMsgCount)";
            lblTitleCount.isHidden = false;
            if(ConfigInfo.m_iUnReadMsgCount == 0)
            {
                 lblTitleCount.isHidden = true;
            }
        }else
        {
            lblTitleCount.isHidden = true;
        }
        
        
        return cell        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch(indexPath.row)
        {
        case APP_CARD_POLICY:
              
            m_uiCardPolicyView.isHidden = false
            m_uiCardPolicyViewBG.isHidden = false
            
            break;
        case ACTIVITY_GAME:
            MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
            DCUpdater.shared()?.queryActivityGame(ConfigInfo.m_strAccessToken);
            break;
        case MESSAGE_CENTRE:    //訊息中心
            onMessageCenter();            
            break;
        case POINT_QUERY:
            gotoPointQueryCenter();//消費記錄查詢
            break;
        case ELECTRON_VOUCHER:    //我的電子贈卷
            onElectronVoucher(iType: 0);
             break;
        case QPOINT_LOTTERY:  //Q點摸彩卷
            onQLottery();            
            break;
        case CHANGE_GIFT_RECORD:
            onPointGift();  //點數換好禮
            break;
        case BILL_RESIGN: //發票補登
            onInvoiceSupplement();
            break;
        case EXCHANGE_QUERY:   //全部卷換卷查詢
            onCuponCenter();
            break;
        case EXCLUSIVE_OFFER: //專屬優惠券
            onExclusiveOffer();
            break;
        case MEMBER_INFO_MODIFY://會員資料修改
            gotoModifyMember();            
            break;
        case MODIFY_PASSWORD://密碼修改
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            
            let  btModifyPassword
                = StoryBoard.instantiateViewController(withIdentifier: "PasswordModify");
            
            self.navigationController?.pushViewController(btModifyPassword, animated: true)
            
            break;
        case POLICY_CENTER:  //會員權益
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            let  btPurchaseDevice
                = StoryBoard.instantiateViewController(withIdentifier: "MemberPolicy");
            self.navigationController?.pushViewController(btPurchaseDevice, animated: true)
            break;
        case LOGOUT:
            Logout(IsDirectLogout: false);
            break;
        default:
            break;
        }
    }
    
    
    func onInvoiceSupplement()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btInvoiceSupplement
            = StoryBoard.instantiateViewController(withIdentifier: "InvoiceSupplement");
        
        self.navigationController?.pushViewController(btInvoiceSupplement, animated: true)
        
    }
    
    
    
    func onQLottery()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btElectronVoucher
            = StoryBoard.instantiateViewController(withIdentifier: "QLottery");
        
        self.navigationController?.pushViewController(btElectronVoucher, animated: true)
        
    }
    
    func onElectronVoucher(iType:Int)
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        
        let  btElectronVoucher
            = StoryBoard.instantiateViewController(withIdentifier: "ElectronVoucher") as! ElectronVoucherViewController;
        
        btElectronVoucher.m_iType  = iType;
        
        self.navigationController?.pushViewController(btElectronVoucher, animated: true)
    }
    
    func OnGameLink()
    {
        let  StoryBoard = UIStoryboard(name: "game" , bundle: nil)
        
        let  btMainGame
           = StoryBoard.instantiateViewController(withIdentifier: "MainGame")
        
        self.navigationController?.pushViewController(btMainGame, animated: true)
        
    }
    
    
    
    func  Logout(IsDirectLogout:Bool)
    {
        
        if(IsDirectLogout)
        {
            
            ConfigInfo.m_bMemberLogin = false;
            self.ResetUserLoginInfo();
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            let  btLoginBoard
                = StoryBoard.instantiateViewController(withIdentifier: "Login");
            self.navigationController?.replaceTopViewController(with: btLoginBoard, animated: true)
            
        }else
        {
            let alert = UIAlertController(title: "系統資訊", message: "確定要登出嗎？", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:  "確定", style: .default ) { (UIAlertAction) in
                
                ConfigInfo.m_bMemberLogin = false;
                self.ResetUserLoginInfo();
                let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                let  btLoginBoard
                    = StoryBoard.instantiateViewController(withIdentifier: "Login");
                self.navigationController?.replaceTopViewController(with: btLoginBoard, animated: true)
                
            });
            alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func ResetUserLoginInfo()
    {
        let myUserDefaults = UserDefaults.standard;
        
        let isSave = myUserDefaults.bool(forKey: "IsSave");
        
        if(isSave)
        {
            myUserDefaults.set(ConfigInfo.m_strPassword, forKey: "Password");
        }else
        {
            myUserDefaults.set("", forKey: "Password");
        }
        
        myUserDefaults.set("" , forKey: "SerialNo")
        myUserDefaults.set("" , forKey: "AccessToken")
        myUserDefaults.set("" , forKey: "Name")
        myUserDefaults.set("" , forKey: "Birthday")
        myUserDefaults.set("" , forKey: "ZIP")
        myUserDefaults.set("", forKey: "ADDR")
        myUserDefaults.set("" , forKey: "PhoneNumber")
        myUserDefaults.set("" , forKey: "CardNumber")
        myUserDefaults.set(ConfigInfo.m_bMemberLogin , forKey: "IsLogin")
        
        myUserDefaults.synchronize();
    
    }
    
    
    @IBAction func onExclusiveOffer() {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "ExclusiveOffer");
        
        self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }
    
    
    
    func   gotoPointQueryCenter()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        let  btPointQuery
            
            = StoryBoard.instantiateViewController(withIdentifier: "PointQuery");
        
           self.navigationController?.pushViewController(btPointQuery, animated: true)
        
    }
    
    func   gotoModifyMember()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btPointQuery
            = StoryBoard.instantiateViewController(withIdentifier: "ModifyMember");
        
        self.navigationController?.pushViewController(btPointQuery, animated: true)
        
    }
    
    
    
    @IBAction func onMemberCardInfo(_ sender: AnyObject) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "MemberCode");
        
        self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }
    
    
    @IBAction func onPointGift() {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "PointGift");
        
        self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }
    
    
     func onExpensesRecords()
     {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btExpensesRecord
                   = StoryBoard.instantiateViewController(withIdentifier: "ExpensesRecord");
        
        self.navigationController?.pushViewController(btExpensesRecord, animated: true)
        
     }
    
    @IBAction func onMessageCenter() {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "PushMessage");
        
        self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }
    
    
    
    //全部卷換卷查詢
    @IBAction func onCuponCenter() {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "Cuspon");
        
        self.navigationController?.pushViewController(btParkingInfo, animated: true)
        
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
                
                ConfigInfo.m_strName = DataDic.object(forKey: "Name") as! String
                ConfigInfo.m_strBirthday = DataDic.object(forKey: "Birthday") as! String;
                ConfigInfo.m_strZip = DataDic.object(forKey: "ZIP") as! String;
                
                ConfigInfo.m_strAddr = DataDic.object(forKey: "ADDR") as! String;                
                ConfigInfo.m_strSex = Int(DataDic.object(forKey: "Sex") as! String) == 1 ? "男" : "女";
                
//===========================================================================================//
                ConfigInfo.m_strCity = DataDic.object(forKey: "City") as! String;
                ConfigInfo.m_strArea = DataDic.object(forKey: "Area") as! String;
//===========================================================================================//
                
                //Remark later
                ConfigInfo.m_iCardType = Int(DataDic.object(forKey: "CardLevel") as! String)!;
                
                
                m_labelCurPoint.attributedText = FormatString(strNumber: (DataDic.object(forKey: "m_point_qty") as! String), strUnit: "點");
                
                
                
                m_labelEVoucher.attributedText = FormatString(strNumber: (DataDic.object(forKey: "c_point_amt") as! String), strUnit: "元");
                
                m_labelECVoucher.attributedText = FormatString(strNumber: (DataDic.object(forKey: "l_point_amt") as! String), strUnit: "元");
                
                m_labelDiscountVoucher.attributedText = FormatString(strNumber: (DataDic.object(forKey: "p_point_qty") as! String), strUnit: "張");
                
                //ConfigInfo.m_iCardType  = 1 ;
                ConfigInfo.m_strPhone  = DataDic.object(forKey: "PhoneNumber") as! String
                
                m_strCardWebSite  = DataDic.object(forKey: "CardPolicyPage") as! String
                
                print("CardSite = " + m_strCardWebSite + "\n");
                
                
                ModifyMemberViewController.m_strPolicySite  = DataDic.object(forKey: "MemberPolicyPage") as! String
                
                
                MemberCenterViewController.m_bAlowModifyData = Int(DataDic.object(forKey: "AlowModifyData") as! String) == 1 ? true : false
                
                MemberCenterViewController.m_iEverydayCheckCount = Int(DataDic.object(forKey: "EverydayCheckCount") as! String)!
                
                MemberCenterViewController.m_strAlertPersonalPolicy = DataDic.object(forKey: "AlertPersonalPolicy") as! String
               
                
                m_menuOption[0]  =  DataDic.object(forKey: "CardNameTitle") as! String
                
               
                CheckAllowData();
                
                
                
                CardPolicyViewController.m_strCardPolicySite = m_strCardWebSite
            }else
            {
                if(Int(strCode) == -15)
                {
                    ShowAlertControlLogout(Message:  dic.object(forKey: "ReturnMessage") as! String);
                }else
                {
                    ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
                }
            }
            SetCardType();
            tblMenuOptions.reloadData();
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    func CheckAllowData()
    {
        if(m_bCheckAllowData)
        {
            m_bCheckAllowData = false            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let dirAD  = appDelegate.m_UserPolicyCount.GetDictionary();
            var ViewCount = 1;
            if(dirAD.count > 0)
            {
                ViewCount = dirAD.value(forKey: "UserCheckCount") as! Int;
                ViewCount += 1;
                dirAD.setValue(ViewCount, forKey:  "UserCheckCount")
            }else
            {
                dirAD.setValue(ViewCount, forKey:  "UserCheckCount")
                dirAD.setValue(ConfigInfo.GetCurDate(), forKey: "day")
            }
            
            
            if(!MemberCenterViewController.m_bAlowModifyData)
            {
                print(("Current Count =\(ViewCount)"));
                
                if(ViewCount <= MemberCenterViewController.m_iEverydayCheckCount)
                {
                    gotoModifyMember();
                }
            }
        }
    }
    
    func ShowAlertControlLogout(Message:String)
    {
        
        let alert = UIAlertController(title: "系統資訊", message: Message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { [self] (UIAlertAction) in
            
            Logout(IsDirectLogout: true);
            
        }));
        
        
        self.present(alert, animated: true)
    }
    
    
    
    func  FormatString(strNumber:String , strUnit:String ) -> NSMutableAttributedString
    {
        
        let  NormalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        let firstString = NSMutableAttributedString(string: strNumber, attributes: NormalAttributes)
        
        let  WhiteAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let blankString = NSMutableAttributedString(string: " ", attributes: WhiteAttributes)
        firstString.append(blankString)
        
        
        let  BlackAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let secondString = NSAttributedString(string: strUnit, attributes: BlackAttributes)
        firstString.append(secondString)
        
        return firstString;
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        if(ConfigInfo.m_bIsClickPush)
        {
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            
            let  btParkingInfo
                = StoryBoard.instantiateViewController(withIdentifier: "PushMessage");
            
            self.navigationController?.pushViewController(btParkingInfo, animated: false)
        }else
        {
            
            DCUpdater.shared()?.getUnReadMsgCount(ConfigInfo.m_strAccessToken);
            
            NotificationCenter.default.addObserver(self, selector:#selector(didMemberInfoResult), name:NSNotification.Name(rawValue: kDCGetMemberInfo), object: nil)
            
            MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
            
            DCUpdater.shared()?.getMemberInfo(ConfigInfo.m_strAccessToken)
            
            
            NotificationCenter.default.addObserver(self, selector:#selector(didGetUnReadMessageResult), name:NSNotification.Name(rawValue: kDCGetUnReadMessage), object: nil)
            
            
//=======================did Get Activity Game Result============================//
            NotificationCenter.default.addObserver(self, selector:#selector(didGetActivityGameResult), name:NSNotification.Name(rawValue: kDCGameActivity), object: nil)
            
            
        }
        
        self.SetTitleColor();
        self.startTimeTick();
        
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
            
            tblMenuOptions.reloadData();
            
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCGetMemberInfo), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCGameActivity), object: nil)
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCGetUnReadMessage), object: nil)
        
        
        RemoveTitleBar()
        
        
        //================================================================================//
        self.stopTimeTick();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_MEMBER), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
        
       
    }
    
    
    
    @objc func didGetActivityGameResult(notification: NSNotification){
           
           //do stuff
           let userInfo = notification.userInfo as NSDictionary?;
           let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
           
           MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
           
           if(strSuccess.isEqual(to: "YES"))
           {
               let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
               let  strCode = dic.object(forKey: "ReturnCode") as! String;
               ConfigInfo.m_gameInfo.iGameStartType = Int(strCode)!;
               
               
               if(Int(strCode) == 0)
               {
                   ConfigInfo.m_bMemberLogin =  true;
                   let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                   
                   ConfigInfo.m_gameInfo.strID = Int(DataDic.object(forKey: "id") as! String)!
                   ConfigInfo.m_gameInfo.strName  = DataDic.object(forKey: "Name") as! String;
                   ConfigInfo.m_gameInfo.strWebPage  = DataDic.object(forKey: "WebPage") as! String;
                   ConfigInfo.m_gameInfo.iFreeCount  = Int(DataDic.object(forKey: "FreeCount") as! String)!;
                
//===============================================================================================//
                  if(dic.object(forKey: "ReturnMessage") != nil)
                  {
                      ConfigInfo.m_gameInfo.strGameResult = dic.object(forKey: "ReturnMessage") as! String;
                    
                      self.OnGameLink();                                                                 
                  }else
                  {
                      self.OnGameLink();
                  }
                 
               }else if(ConfigInfo.m_gameInfo.iGameStartType == -36)  //INFO NO FOUND
               {
                   let ReturnMsg = dic.object(forKey: "ReturnMessage") as! String;
                   ShowAlertControlWithTitle(Message: ReturnMsg,strTitle: "親愛的用戶您好"); 
               }else
               {
                   let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                   ConfigInfo.m_gameInfo.strWebPage  = DataDic.object(forKey: "WebPage") as! String;
                   ConfigInfo.m_gameInfo.strGameResult = dic.object(forKey: "ReturnMessage") as! String;
                   self.OnGameLink();
               }
           }else
           {
               ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
           }
       }
       
    
    
}
