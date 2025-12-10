//
//  RewardGameViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/5/26.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import UIKit

class RewardGameViewController: GameBaseViewController {

    @IBOutlet weak var mBackGroundview: UIView!
    @IBOutlet weak var mAlertview: UIView!
    
    //===========================================
    @IBOutlet var m_labelContent : UILabel!
    
    var  m_bIsPoint = false;
    @IBOutlet var m_PrizeTitle : UILabel!
    @IBOutlet var m_btnCusponOrPoints : UIButton!
    
    @IBOutlet var m_btnEnd : UIButton!
    @IBOutlet var m_btnContinue : UIButton!
    
//=========================================//
    @IBOutlet var m_labelChance : UILabel!
    @IBOutlet var m_imageCircle : UIImageView!
    
    @IBOutlet var m_imageFlower : UIImageView!
    @IBOutlet var m_imagePrize : UIImageView!
    
//================================================//
    @IBOutlet var m_btnAgain : UIButton!
    
    
    func ShowAlert(isShow:Bool)
       {
        
           if(ConfigInfo.m_gameInfo.PointEnough == 1 &&
              ConfigInfo.m_gameInfo.bIsSecondPlay)
           {
               m_labelContent.text = "是否確定，\n扣\(ConfigInfo.m_gameInfo.strSecondPerPoint)點再玩一次？";            
           }else
           {
              if(ConfigInfo.m_gameInfo.bIsSecondPlay)
              {
                  m_labelContent.text = "點數已用盡\n謝謝您";
              }else
              {
                   m_labelContent.text = "遊戲一天只有一次，\n今天已無免費機會，\n謝謝您。";
              }
            
            
              m_btnContinue.isHidden  = true;
           }
           
           mBackGroundview.isHidden = !isShow;
           mAlertview.isHidden = !isShow;
       }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearCache();
        
        // Do any additional setup after loading the view.
        ShowAlert(isShow: false);
        
        m_PrizeTitle.text  = ConfigInfo.m_gameInfo.strPrizeName;
        
        //m_PrizeContent.text  = "200點";
        
        m_labelChance.layer.cornerRadius =  5;
        m_labelContent.layer.cornerRadius =  5;
        if(ConfigInfo.m_gameInfo.iAwardsType == 0)
        {
            m_btnCusponOrPoints.setBackgroundImage(UIImage(named: "goto_point"), for: UIControl.State.normal)
            m_bIsPoint =  true;            
        }
        
        self.playSound(strFileName: "prize", strExtName: "mp3",iLoop: 0);
        
        
//==========================================================================//
        let string = NSMutableAttributedString(string: m_labelChance.text!)
        string.setColorForText("0", with: UIColor.red)
        m_labelChance.attributedText = string
        
    }
    
    
    override func viewDidLayoutSubviews() {
         InitializeLayout();
    }
    
    
    func  InitializeLayout()
    {
        var yStart =  m_labelChance.frame.origin.y;
        yStart = yStart +  m_labelChance.frame.size.height;
        let yEnd = m_btnAgain.frame.origin.y;
        
        
        m_imageCircle.frame.origin.y = yStart + 20;
        
        var  vWidth = yEnd - yStart;
        if((yEnd - yStart) > UIScreen.main.bounds.width)
        {
            vWidth = UIScreen.main.bounds.width;
        }
        
        m_imageCircle.frame.size.height = vWidth - 100;
        m_imageCircle.frame.size.width  = m_imageCircle.frame.size.height;
        
        
        m_imageCircle.frame.origin.x  = (UIScreen.main.bounds.width - m_imageCircle.frame.size.width) / 2;

//=======================================================================//
        
        m_PrizeTitle.frame.origin.y = m_imageCircle.frame.origin.y +
            ((m_imageCircle.frame.size.height - m_PrizeTitle.frame.size.height)/2);
        m_PrizeTitle.frame.origin.x = (UIScreen.main.bounds.width - m_PrizeTitle.frame.size.width) / 2;
        
        
        m_imagePrize.frame.origin.y = m_imageCircle.frame.origin.y + m_imageCircle.frame.size.height - 100;
        m_imagePrize.frame.size.width  = m_imageCircle.frame.size.width - 40;
       // m_imagePrize.frame.size.height  = m_imagePrize.frame.size.width;
        
        m_imagePrize.frame.origin.x = (UIScreen.main.bounds.width - m_imagePrize.frame.size.width) / 2 - 20;                
        m_imageFlower.frame.origin.y = m_imageCircle.frame.origin.y + m_imageCircle.frame.size.height - 120;
         m_imageFlower.frame.size.width  = m_imageCircle.frame.size.width;
        m_imageFlower.frame.origin.x = (UIScreen.main.bounds.width - m_imageFlower.frame.size.width) / 2;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onPlayAgainClick(_ sender:UIButton)
      {
          ShowAlert(isShow: true);          
      }
    
    
    @IBAction func onEndClick(_ sender:UIButton)
    {
        onHomeClick(sender)
    }
    
    @IBAction func onContinueClick(_ sender:UIButton)
    {
        //////////////////////////////////////////////
        //修正無免費機會......
        ConfigInfo.m_gameInfo.iFreeCount  = 0;
        
        self.popBack(3);
    }
    
    @IBAction func onCloseAlert(_ sender: AnyObject) {
               ShowAlert(isShow: false);
             
        }
    
    @IBAction func onPointOrCusponClick(_ sender:UIButton)
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        
        //
        var  btBoard = StoryBoard.instantiateViewController(withIdentifier: "Cuspon");
        
        if(m_bIsPoint)
        {
            //點數
            btBoard  =  StoryBoard.instantiateViewController(withIdentifier: "PointQuery");
                     
        }
        self.navigationController?.pushViewController(btBoard, animated: true)
    }
    
    
    
}
