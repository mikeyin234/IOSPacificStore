//
//  MainGameViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/30.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import UIKit
import AVFoundation




class MainGameViewController: GameBaseViewController,WKUIDelegate {

    @IBOutlet weak var mImageview: UIImageView!
    
//===============================================
    @IBOutlet weak var mBackGroundview: UIView!
    @IBOutlet weak var mAlertview: UIView!
    
    
    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    var m_WaterBubble = WaterBubble();
    var m_timerBubbleTick:Timer!;
    @IBOutlet weak var mBGImageView: UIImageView!
    
//=======================================================//
    @IBOutlet weak var mFishImageView: UIImageView!
    
//=======================================================//
    var m_timerTick:Timer!
    var m_iStartFishIndex = 0;
    var m_bIsDown = true;
    
    
//=======================================================//
    @IBOutlet weak var m_MsgImageView: UIImageView!
    @IBOutlet weak var m_MsgView: UIView!
    @IBOutlet weak var m_MsgLabel: UILabel!
    
    
//========================================================//
    @IBOutlet weak var mTitleImageView: UIImageView!
    @IBOutlet weak var mContentImageView: UIImageView!
    
//=======================================================//
    @IBOutlet weak var m_btClose: UIButton!
    @IBOutlet weak var m_BottomImageView: UIImageView!
    
//=======================================================//
    @IBOutlet weak var m_btContinue: UIButton!
    
    
    @IBOutlet weak var m_btOpenCloseVoice: UIButton!
    
    
    
    func InitWebView() {
        
        _ = WKWebViewConfiguration()
        let poliwebFrame = m_ViewContent.frame;
        
        m_PolicyWebView  = WKWebView(frame: CGRect(x: 0, y: 0,
                                     width: poliwebFrame.size.width, height: poliwebFrame.size.height), configuration: WKWebViewConfiguration())
        
        m_PolicyWebView.uiDelegate = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    
    
    
    func ShowAlert(isShow:Bool)
    {
        mBackGroundview.isHidden = !isShow;
        mAlertview.isHidden = !isShow;
        
        m_MsgImageView.isHidden = true;
        m_MsgView.isHidden = true;
        
//===============================================//
        m_ViewContent.isHidden = false;
        mTitleImageView.isHidden = false;
        mContentImageView.isHidden = false;
        m_btClose.isHidden = false;
        m_BottomImageView.isHidden = false;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearCache();
        
        // Do any additional setup after loading the view.
        ShowAlert(isShow: false);
        
        
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
        
        mFishImageView.frame.origin.x = (UIScreen.main.bounds.width - mFishImageView.frame.width) / 2 + 30;
        
        mFishImageView.frame.origin.y = (UIScreen.main.bounds.height - mFishImageView.frame.height) / 2;
        
        self.m_timerTick  = Timer.scheduledTimer(timeInterval: TimeInterval(0.1)
                              , target: self, selector: #selector(updateTickTimer),
                              userInfo: nil, repeats: true);
        
//=================================================================================//
        m_MsgImageView.isHidden  = true;
        m_MsgView.isHidden  = true;
        
       
            
       
       self.m_btOpenCloseVoice.setBackgroundImage(ConfigInfo.m_bOpenVoice ? UIImage(named: "open_voice") :
                      UIImage(named: "close_voice"), for: UIControl.State.normal)
        
        //ConfigInfo.m_bOpenVoice
        
    }
    
    @objc  func updateTickTimer(dt:Timer)
    {
        let CenterY = (UIScreen.main.bounds.height - mFishImageView.frame.height) / 2;
        
        if(m_bIsDown)
        {
            m_iStartFishIndex += 1;
        }else
        {
            m_iStartFishIndex -= 1;
        }
        
        if(m_iStartFishIndex>100)
        {
            m_iStartFishIndex = 100;
            m_bIsDown  = false;
        }else if(m_iStartFishIndex < 0)
        {
            m_bIsDown  = true;
            m_iStartFishIndex = 0;
        }
        
        mFishImageView.frame.origin.y = CenterY + CGFloat(m_iStartFishIndex);
        
    }
    
    
    @objc  func BubbleTickTimer(dt:Timer)
    {
        m_WaterBubble.createBubble(self.view);
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        SetTitleColorExt(color: UIColor.black)
        
        self.playSound(strFileName: "fish", strExtName: "mp3",iLoop: -1);
        
        self.m_timerBubbleTick  = Timer.scheduledTimer(timeInterval: TimeInterval(0.5)
             , target: self, selector: #selector(BubbleTickTimer),
             userInfo: nil, repeats: true);
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
                           InitWebView();
                           
        let  m_WebPage = ConfigInfo.m_gameInfo.strWebPage;
        if(m_WebPage.count>0)
        {
            let myURL = URL(string: m_WebPage)
            let myRequest = URLRequest(url: myURL!)
            m_PolicyWebView.load(myRequest)            
        }
        
        
        
    }
    
    
    
    ///離開後填入。
    override func viewWillDisappear(_ animated: Bool) {
        player?.stop();
        
//=======================================//
        self.m_timerBubbleTick.invalidate();
//==================================================//
        self.m_timerTick.invalidate();
        
        
        self.stopTimeTick();
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_GAME), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
    }
    
   
    
    @IBAction func onShowAlertHelp(_ sender: AnyObject) {
          ShowAlert(isShow: true);
        
    }
    

    @IBAction func onCloseHelp(_ sender: AnyObject) {
            ShowAlert(isShow: false);
          
      }
    
    
//======================================================//
    @IBAction func onStartGame(_ sender: AnyObject)
    {
        
        if(ConfigInfo.m_gameInfo.iGameStartType == 0)
        {
           if(ConfigInfo.m_gameInfo.strGameResult.count > 0)
           {
              let ReturnMsg = ConfigInfo.m_gameInfo.strGameResult;

              /*
              let alert = UIAlertController(title: "系統資訊", message: ReturnMsg, preferredStyle: .alert)
            
              alert.addAction(UIAlertAction(title:  "是", style: .default) { (UIAlertAction) in
                 self.GotoStartGame();
              });
              alert.addAction(UIAlertAction(title: "否", style: .default, handler: nil))                                  
                                                   self.present(alert, animated: true)
              */
//===============================================================//
              ShowMsgControl(isShow:true,strMessage: ReturnMsg);
               
              //ShowMsgCancelControl(isShow:true,strMessage: ReturnMsg);
           }else
           {
               GotoStartGame();
           }
        }else
        {
            ShowMsgCancelControl(isShow: true, strMessage: ConfigInfo.m_gameInfo.strGameResult);
            
           // ShowAlertControlWithTitle(Message: ConfigInfo.m_gameInfo.strGameResult,strTitle: "親愛的用戶您好");
        }
        
    }
    
    func GotoStartGame()
    {
        self.playSound2(strFileName: "hit", strExtName: "mp3",iLoop: 0);
        let  StoryBoard = UIStoryboard(name: "game" , bundle: nil)
        let  btMainGame = StoryBoard.instantiateViewController(withIdentifier: "StartGame");
        self.navigationController?.pushViewController(btMainGame, animated: true)
    }
    
    
    func ShowMsgControl(isShow:Bool,strMessage:String) {
        
        mBackGroundview.isHidden = !isShow;
        self.mAlertview.isHidden = !isShow;
        
        
        m_MsgLabel.text  = strMessage;
        m_MsgImageView.isHidden = !isShow;
        m_MsgView.isHidden = !isShow;
        
//====================================================//
        m_ViewContent.isHidden = true;
        mTitleImageView.isHidden = true;
        mContentImageView.isHidden = true;
        
        m_btClose.isHidden = true;
        m_BottomImageView.isHidden = true;
        
    }
    
    
    @IBAction func onOK(_ sender: AnyObject)
    {
        self.GotoStartGame();
    }
    
    @IBAction func onCancel(_ sender: AnyObject)
    {
        mBackGroundview.isHidden = true;
        self.mAlertview.isHidden = true;        
        m_MsgImageView.isHidden = true;
        m_MsgView.isHidden = true;
    }
    
//===========================================================//
    func ShowMsgCancelControl(isShow:Bool,strMessage:String) {
            
            mBackGroundview.isHidden = !isShow;
            self.mAlertview.isHidden = !isShow;
            
            
            m_MsgLabel.text  = strMessage;
            m_MsgImageView.isHidden = !isShow;
            m_MsgView.isHidden = !isShow;
            
    //====================================================//
            m_ViewContent.isHidden = true;
            mTitleImageView.isHidden = true;
            mContentImageView.isHidden = true;
            
            m_btClose.isHidden = true;
            m_BottomImageView.isHidden = true;
            m_btContinue.isHidden = true;
            
           
            
        }
    
    
    
    //self.playSound2(strFileName: "sign", strExtName: "wav",iLoop: -1);
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func onOpenCloseVoice(_ sender: AnyObject)
    {
        ConfigInfo.m_bOpenVoice = !ConfigInfo.m_bOpenVoice;
        
        m_btOpenCloseVoice.setBackgroundImage(ConfigInfo.m_bOpenVoice ? UIImage(named: "open_voice") :
            UIImage(named: "close_voice"), for: UIControl.State.normal)
        
        
        self.SetPlayMute();
        
    }
    
}
