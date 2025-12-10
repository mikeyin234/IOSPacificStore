//
//  StartGameViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/30.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import UIKit
import AVFoundation

class StartGameViewController: GameBaseViewController,WKUIDelegate {

    var m_timerTick:Timer!
    let  m_sign  = ["sign1","sign2","sign3","sign2"];
    
    
    @IBOutlet var m_btnSign : UIButton!
    @IBOutlet var m_labelContent : UILabel!
    
    var  m_iCount = 0;
    var  m_iRount = 0;
    
    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    @IBOutlet weak var mBackGroundview: UIView!
    @IBOutlet weak var mAlertview: UIView!
    
    var   m_bStartGame = false;
    
    @IBOutlet var m_btnActivity : UIButton!
    @IBOutlet var m_btnHome : UIButton!
    
    
//==========================================//
    var m_WaterBubble = WaterBubble();
    var m_timerBubbleTick:Timer!;

//=====================================================//
    @IBOutlet weak var m_MsgImageView: UIImageView!
    @IBOutlet weak var m_MsgView: UIView!
    @IBOutlet weak var m_MsgLabel: UILabel!
    
//======================================================//
    var   m_strErrorMessage = "";
    
    @IBOutlet weak var m_btClose: UIButton!
    @IBOutlet weak var m_BottomImageView: UIImageView!
    
    
    func ShowAlert(isShow:Bool)
       {
           mBackGroundview.isHidden = !isShow;
           mAlertview.isHidden = !isShow;
           
           m_ViewContent.isHidden = !isShow;
           m_btClose.isHidden = !isShow;
           m_BottomImageView.isHidden = !isShow;
       }
    
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        let poliwebFrame = m_ViewContent.frame;
        
        m_PolicyWebView  = WKWebView(frame: CGRect(x: 0, y: 0,
                                     width: poliwebFrame.size.width, height: poliwebFrame.size.height), configuration: webConfiguration)
        
        m_PolicyWebView.uiDelegate = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearCache();
        
        ShowAlert(isShow: false);
        
        // Do any additional setup after loading the view.
        //self.playSound(strFileName: "fish", strExtName: "mp3",iLoop: -1);
        
        m_labelContent.layer.cornerRadius = 5;
       
        
//=========================================================//
        m_MsgImageView.isHidden = true;
        m_MsgView.isHidden = true;
        
        //ConfigInfo.m_gameInfo.iFreeCount =  1;
        //m_labelContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
          InitWebView();
          
          let  m_WebPage = ConfigInfo.m_gameInfo.strWebPage;
          //let  m_WebPage = "http://tw.yahoo.com";
        
          let myURL = URL(string: m_WebPage)
         
          let myRequest = URLRequest(url: myURL!)
        
          m_PolicyWebView.load(myRequest)
           
       }
    
    
    
    //m_gameInfo    
    override func viewWillAppear(_ animated: Bool) {
        
        m_bStartGame =  false;
        m_btnActivity.isEnabled = true;
        m_btnHome.isEnabled = true;
        
        //m_btnSign.setBackgroundImage(UIImage(named:"sign_text"), for: UIControl.State.normal)
        //kDCQueryGameResult
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryGameResult), name:NSNotification.Name(rawValue: kDCQueryGameResult), object: nil)
        
        
        self.m_timerBubbleTick  = Timer.scheduledTimer(timeInterval: TimeInterval(0.5)
                   , target: self, selector: #selector(BubbleTickTimer),
                   userInfo: nil, repeats: true);
        
        m_labelContent.text  = "今天還有\(ConfigInfo.m_gameInfo.iFreeCount)次免費機會";
        
        let string = NSMutableAttributedString(string: m_labelContent.text!)
               string.setColorForText("\(ConfigInfo.m_gameInfo.iFreeCount)", with: UIColor.red)
               m_labelContent.attributedText = string
        
    }
    
    
    
   
    @objc  func BubbleTickTimer(dt:Timer)
    {
           m_WaterBubble.createBubble(self.view);
    }
    
    
//=======================================//
    @objc func  didQueryGameResult(notification: NSNotification)
       {
           let userInfo = notification.userInfo as NSDictionary?;
           let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
           
           if(strSuccess.isEqual(to: "YES"))
           {
               let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
               let  strCode = dic.object(forKey: "ReturnCode") as! String;
               
               if(Int(strCode) == 0)
               {
                   let dicData  = dic.object(forKey: "Data") as! NSDictionary;
                    
                   ConfigInfo.m_gameInfo.strSignImage = dicData.object(forKey: "SignImage") as! String
                
                   ConfigInfo.m_gameInfo.strPrizeName = dicData.object(forKey: "PrizeName") as! String
                    
                   ConfigInfo.m_gameInfo.iAwardsType = Int(dicData.object(forKey: "AwardsType") as! String)!
                   
                   ConfigInfo.m_gameInfo.strSecondPerPoint = dicData.object(forKey: "SecondPerPoint") as! String
                   
                   ConfigInfo.m_gameInfo.PointEnough = Int(dicData.object(forKey: "PointEnough") as! String)!
                   
                   ConfigInfo.m_gameInfo.bIsSecondPlay = dicData.object(forKey: "IsSecondPlay") as! String == "1" ? true : false;
                    
                    m_btnActivity.isEnabled = false;
                    m_btnHome.isEnabled = false;
                    
                    self.m_timerTick  = Timer.scheduledTimer(timeInterval: TimeInterval(0.2)
                                          , target: self, selector: #selector(updateTickTimer),
                                          userInfo: nil, repeats: true);
                    
                    self.playSound2(strFileName: "sign", strExtName: "wav",iLoop: -1);
                   //ConfigInfo.m_gameInfo.bIsSecondPlay  = false;
               }else
               {
                   m_strErrorMessage = dic.object(forKey: "ReturnMessage") as! String;
                   ShowMsgCancelControl(isShow: true, strMessage: self.m_strErrorMessage);
                   m_bStartGame = false;                   
            }
           }else
           {
               ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
               m_bStartGame = false;
           }
       }
    
    @objc  func updateTickTimer(dt:Timer)
    {
        m_btnSign.setBackgroundImage(UIImage(named: m_sign[m_iCount]), for: UIControl.State.normal)
        
        m_iCount += 1;
        
        if(m_iCount>3)
        {
            m_iCount = 0;
        }
        
        m_iRount += 1;
        
        
       if(m_iRount>25)
       {
            m_iRount = 0;
            m_iCount = 0;
        
            m_timerTick.invalidate();
            m_timerTick =  nil;
        
            m_labelContent.isHidden  = false;
            m_btnSign.isEnabled =  true;
            player2?.stop();
            
            GotoGameResult();
       }
        
    }
      
    
    override var prefersStatusBarHidden: Bool {
           return true
       }
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
         
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCQueryGameResult), object: nil)
        
        
          if(m_timerTick != nil)
          {
              m_timerTick.invalidate();
              m_timerTick =  nil;
          }
        
          player?.stop();
        
          //=======================================//
          if(self.m_timerBubbleTick != nil)
          {
               self.m_timerBubbleTick.invalidate();
          }
        
       }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onNextClick(_ sender:UIButton)
    {
        
        performSegue(withIdentifier: "ResultGame", sender: nil)
        
    }
    
    
    @IBAction func onShowAlertHelp(_ sender: AnyObject) {
          ShowAlert(isShow: true);
        
    }
    
    
    @IBAction func onCloseHelp(_ sender: AnyObject) {
            ShowAlert(isShow: false);
          
    }
    
//=====================================================//
    @IBAction func onStartGame(_ sender: AnyObject)
    {
        
            if(!m_bStartGame)
            {
                ////////////////////////////////////////////////////////////////////////
                //mike modify at 2020 06  04
                DCUpdater.shared()?.queryGameResult(Int32(ConfigInfo.m_gameInfo.strID), andAccessToken: ConfigInfo.m_strAccessToken)
                
                m_bStartGame = true;
                
            }
    }
    
    
    func GotoGameResult()
    {
        
        let  StoryBoard = UIStoryboard(name: "game" , bundle: nil)
        
        let  btMainGame
                   = StoryBoard.instantiateViewController(withIdentifier: "GameResult");
        
        self.navigationController?.pushViewController(btMainGame, animated: true)
        
    }
    
    
    @IBAction func onCancel(_ sender: AnyObject)
    {
           mBackGroundview.isHidden = true;
           self.mAlertview.isHidden = true;
           m_MsgImageView.isHidden = true;
           m_MsgView.isHidden = true;
    }
    
    
    func ShowMsgCancelControl(isShow:Bool,strMessage:String) {
               
               mBackGroundview.isHidden = !isShow;
               self.mAlertview.isHidden = !isShow;
               
               
               m_MsgLabel.text  = strMessage;
               m_MsgImageView.isHidden = !isShow;
               m_MsgView.isHidden = !isShow;
               
       //====================================================//
               m_ViewContent.isHidden = true;
        
               m_btClose.isHidden = true;
               m_BottomImageView.isHidden = true;
        
               /*
               mTitleImageView.isHidden = true;
               mContentImageView.isHidden = true;
               m_btContinue.isHidden = true;
               */
           }
    
}
