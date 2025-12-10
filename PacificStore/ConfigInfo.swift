//
//  ConfigInfo.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/15.
//  Copyright © 2019年 greatsoft. All rights reserved.
//

import Foundation

//AppleID:pacific.mall.department@gmail.com
//密碼:pacificDEPARTMENT420

struct GAME_INFO {
    
    var strID = -1;
    var strName = "";
    var strWebPage = "" ;
    
    var iFreeCount = 0;
    
    var PointEnough = 1;
    var strSecondPerPoint = "0";
    
    var  strSignImage = "";
    var  strPrizeName = "";
    var  iAwardsType = 0;
    var  bIsSecondPlay = false;
    
    
//========================================//
    var  iGameStartType  = 0;
    var  strGameResult  = "";
}

class ConfigInfo
{
    public static  var  m_fDefaultBright:CGFloat = 0.0;

    
    public static let HOST_SERVER = "https://newapp.pacific-mall.com.tw:8043/";
    //public static let HOST_SERVER = "https://testapp.pacific-mall.com.tw:8043/";
    
    
    public static let  PARKING_SITE = HOST_SERVER + "Upload/Webpages/parking.htm"
    public static let  ABOUT_SITE = HOST_SERVER + "Upload/Webpages/About.htm"
    public static let  CATHAYBK_SITE = HOST_SERVER + "Upload/Webpages/cathaybk.htm"
    
    //public static let  PURCHASE_SITE = "https://pacific.cashier-stage.ecpay.com.tw";
    
    public static let  PURCHASE_SITE = "https://pacific.cashier.ecpay.com.tw/";
    
    
    
    public static let  FB_SITE = "https://www.facebook.com/FengYuanTaiPingYangBaiHuo";
    
    

    
    
    //public static let  PARKING_SITE = HOST_SERVER + "Upload/Webpages/Policy.htm"
    public static let  MEMBER_POLICY = HOST_SERVER +
    "Upload/Webpages/Policy.htm"
    
    //=============兌換  專屬優惠券========================//
    public static  var  m_bChangeOfferStatus = false;
    //public static let  MEMBER_POLICY = "http://newapp.pacific-mall.com.tw/policy/policy.htm"
    public static  var  m_iUnReadMsgCount = 0;
    
    public static var m_bIsViewMemberLogin = false;
    public static var  FCM_DEVICE_TOKEN  = "";  //FCM TOKEN
    public static let  APP_MEMBER = 0;
    public static let  CAR_MEMBER = 1;
    public static let  CHILDREN_CARD_VAILD = -25;
    public static var  m_bIsChildren:Bool = false;
    public static var  m_strUserID = "";
    public static var  m_strPassword = "";
    
    public static var  m_strAccessToken = "";
    public static var  m_SerialNo = "";
    public static var  m_iMemberType = 0; 
    public static var  m_bMemberLogin = false;
    public static var  m_bIsDebug = false;
    
    public static var  m_strPhone = "";
    public static var  m_strName = "";
    public static var  m_strBirthday = "";
    public static var  m_strZip = "";
    
//===============================================//
    public static var  m_strCity = "";
    public static var  m_strArea = "";
    
    
    public static var  m_strAddr = "";
    public static var  m_strSex = "";
    
    //1-一般吉利卡、2-尊榮銀卡、3-尊爵金卡、4-黑卡、5-APP會員卡、6-兒童卡
    public static var  m_iCardType = 5;
    public static var  m_strCardNumber = "";
    
    
    public static let CardType:[String] = ["吉利卡","貴賓銀卡","尊榮金卡","尊爵黑卡","APP會員卡","兒童卡"  ,"好友卡"];
    
//=======================================================//
    public static var  m_bIsClickPush = false;    
    public static var  m_strSendTime = "";
    
    
    public static var  m_bAlreadyRun = false;
    
    
//====================================================//
    //BETA
    public static  var  m_strBetaVersion = "";  //BETA
    
//=====================================================//
    public static var  m_strGameID = "";
    public static var  m_strGameName = "";
    public static   var m_gameInfo = GAME_INFO();
    public static var  m_bOpenVoice = true;
    public static var  m_DefaultTableCellColor = UIColor.red;
    public static var  m_bIsParking = false;
    
    
//==================//
    public static var   IMAGES_SITE = "";
    
    
    
//=================================================//
    public static var  m_fImageRatio:CGFloat =  1.63;
    
    
//================================================================//
    //-1 No Action   0 點數換好禮   1  專屬優惠
    public static  var m_iNeedJumpPage =  -1;  //-1 nojump   0 jump    1 jump
    
    
    static func  FormatDateStirng(strDate:String) -> String
    {
        var strDateFormat  = strDate;
        strDateFormat.insert("/", at: strDateFormat.index(strDate.startIndex, offsetBy: 4))
        strDateFormat.insert("/", at: strDateFormat.index(strDate.startIndex, offsetBy: 7))
        return strDateFormat;
    }
    
    
    static func  FormatTimeStirng(strDate:String) -> String
    {
        var strDateFormat  = strDate;
        strDateFormat.insert(":", at: strDateFormat.index(strDate.startIndex, offsetBy: 2))
        strDateFormat.insert(":", at: strDateFormat.index(strDate.startIndex, offsetBy: 5))
        return strDateFormat;
    }
    
    
    static func  GetCurDate() -> String
    {
        // Create Date
        let date = Date()
        
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd";
        // Convert Date to String
        
        return dateFormatter.string(from: date);
    }
    
    
    static  func  funcDateAddMonth(iMonth:Int)->String
    {
        
        let calendar = Calendar.current
        let resultDate =  calendar.date(byAdding: .month, value: -iMonth, to: Date())
        
        let year = calendar.component(.year, from: resultDate!)
        let month = calendar.component(.month, from: resultDate!)
        let day = calendar.component(.day, from: resultDate!)
        let strDate = String(format: "%04d-%02d-%02d", year,month,day)
        return strDate;
        
    }
    
    
    
    
    
    
}
