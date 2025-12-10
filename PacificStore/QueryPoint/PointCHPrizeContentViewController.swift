//
//  QueryPointViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/3.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

/////////////////////////////////////////////
//會員點數查詢
class PointCHPrizeContentViewController: BaseViewController{
                    
    
    @IBOutlet var m_labelName : UILabel!
    @IBOutlet var m_labelCardType : UILabel!
    @IBOutlet var m_labelCurPoint : UILabel!
//======================================================//
    @IBOutlet weak var m_textQueryDate:UITextField!
    
//===================================================
    var m_ListConsumeInfo:[NSDictionary] =  [];
    var m_ListCollectInfo:[NSDictionary] =  [];
    
//================================
    var m_iType = 0;  //0 = 消費 1 = 收
    var m_iCurrentSelect = 0;
    var m_iCounter = 1;
    @IBOutlet var m_labelCounter : UILabel!
    @IBOutlet var m_scrollviewCupon : UIScrollView!
    
    var   m_dicData:NSDictionary!
    var   m_strScheduleID = "";
    
    
    
    var   m_iExchangePoint =  0;
    var   m_iGiftQty =  0;
    
    
    var  m_bIsFirstCall = true;
    
    @IBOutlet var m_ValidPointView : UIView!
    
    @IBOutlet var m_btnQueryPointValidDate : UIButton!
    
    @IBOutlet var m_blackBGView : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        m_ValidPointView.isHidden =  true
        m_blackBGView.isHidden =  true
        
        
        m_labelCounter.layer.borderWidth  = 2;
        m_labelCounter.layer.borderColor = UIColor.black.cgColor
        
      
        m_btnQueryPointValidDate.layer.cornerRadius = 10;
        
        //===========================//
        m_labelCurPoint.text  =  "\(PointGiftViewController.m_iAllPoint)";
        
        
        m_ValidPointView.layer.cornerRadius = 20
        m_ValidPointView.clipsToBounds = true
        
        
    }
    
    
     
    
    override func viewDidLayoutSubviews() {
        if(m_bIsFirstCall)
        {
            AddCuponDetail();
            m_bIsFirstCall = false;
            
        }
        
    }
    
    
  
    func AddCuponDetail()
    {
        //359 ....
        let iWidth  = self.m_scrollviewCupon.frame.size.width;
        let iHeight  = iWidth / ConfigInfo.m_fImageRatio;
        
        //put your code here
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 20, width: self.m_scrollviewCupon.frame.size.width,
            height: iHeight))
        
        
        let strURL = "\(ConfigInfo.IMAGES_SITE)/\((m_dicData.object(forKey:"img_url") as! String))"
        let url = URL(string: strURL)!
        let data = try? Data(contentsOf: url) //make sure your image in this url does exist,
        if(data != nil)
        {
            imageView.contentMode = .scaleAspectFit
            imageView.image  = UIImage(data: data!)!
            self.m_scrollviewCupon.addSubview(imageView);
        }
        
        //
//===========
        var iTop =  iHeight + 10;
        let labelTitle = UILabel.init(frame: CGRect(x: 20, y: Int(iTop), width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        
        labelTitle.font  = UIFont.systemFont(ofSize: 25.0);
        labelTitle.text  = (m_dicData.object(forKey:"gift_name") as! String);
        self.m_scrollviewCupon.addSubview(labelTitle);
        
        
        iTop +=  40;
        let labelLimit = UILabel.init(frame: CGRect(x: 20, y: Int(iTop), width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelLimit.font  = UIFont.systemFont(ofSize: 20.0);
        
//================
        let date_start = m_dicData.object(forKey: "use_start_date") as! String
        let date_close = m_dicData.object(forKey: "use_close_date") as! String
        
        labelLimit.text  = "兌換期限：\(  ConfigInfo.FormatDateStirng(strDate: date_start))-\( ConfigInfo.FormatDateStirng(strDate: date_close))"
        
        self.m_scrollviewCupon.addSubview(labelLimit);
        
        
        iTop +=  40;
        let labelPoint = UILabel.init(frame: CGRect(x: 20, y: Int(iTop), width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelPoint.font  = UIFont.systemFont(ofSize: 20.0);
        
        
        m_iExchangePoint = (m_dicData.object(forKey:"wallet_qty") as! Int)
        //labelPoint.text  = "兌換點數：\(m_iExchangePoint)點"
        //self.m_scrollviewCupon.addSubview(labelPoint);
        
        let string = NSMutableAttributedString(string: "兌換點數：\(m_iExchangePoint)點")
        string.setColorForText("\(m_iExchangePoint)點", with: UIColor.red)
        labelPoint.attributedText = string
        self.m_scrollviewCupon.addSubview(labelPoint);
        
        
        m_iGiftQty  = (m_dicData.object(forKey:"gift_qty") as! Int)
        
        iTop +=  40;
        let labelAddress = UILabel.init(frame: CGRect(x: 20, y: Int(iTop), width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelAddress.font  = UIFont.systemFont(ofSize: 20.0);
        labelAddress.text  = "兌換地點：\( (m_dicData.object(forKey:"place") as! String))"
        self.m_scrollviewCupon.addSubview(labelAddress);
        
        
        iTop +=  40;
        let labelMark = UILabel.init(frame: CGRect(x: 20, y: Int(iTop), width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelMark.font  = UIFont.systemFont(ofSize: 12.0);
        
        labelMark.text  = "注意事項：\n\( (m_dicData.object(forKey:"remark") as! String))"
        
        
        labelMark.numberOfLines = 0;
        labelMark.lineBreakMode = .byWordWrapping;
        labelMark.sizeToFit();
        labelMark.autoresize();
        
        let iHeightLabelMark = labelMark.frame.height;
        
        
        self.m_scrollviewCupon.addSubview(labelMark);
        
        
        self.m_scrollviewCupon.contentSize = CGSize(width: Int(self.m_scrollviewCupon.frame.size.width), height: Int(iTop) + Int(iHeightLabelMark));
        
        
    }
    
    func SetCardType()
    {            
        m_labelCardType.text  = ConfigInfo.CardType[ConfigInfo.m_iCardType-1];
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        self.SetTitleColor();
        super.viewWillAppear(animated)
//==================================================//
        self.startTimeTick();
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didOnLineChangeEVoucher), name:NSNotification.Name(rawValue: kDCOnLineChangeEVoucher), object: nil)
        
    }
    
    
    
    @objc func didOnLineChangeEVoucher(notification: NSNotification){
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
                ExchangeMessage(strTitle: "兌換成功",strMessage: "1.好禮為\n點數請至會員點數查詢。\n" +
                    "商品抵用券請至我的電子禮券查詢\n" +
                    "贈品兌換券請至全部兌換卷查詢\n" +
                                    "2.請注意兌換卷使用期限。" , bIsNeedClose: true);
                
            }else
            {
                
                let strReturnMsg  = dic.object(forKey: "ReturnMessage") as! String;
                ExchangeMessage(strTitle: "兌換失敗",strMessage: strReturnMsg,bIsNeedClose: false);
                
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self);
        RemoveTitleBar()
        self.stopTimeTick();
        
        
        /*
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_POINT_QUERY), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        */
        
        
    }
    
    
    
    
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "ValidPointView3")
        {
            let validPointViewController =  segue.destination as!  ValidPointViewController
            
            validPointViewController.m_pointCHPrizeContentViewController = self
            
        }
        
    }
    

    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
   
    
    @IBAction func onPlusClick(_ sender:UIButton)
    {
        if((m_iExchangePoint * (m_iCounter + 1)) > PointGiftViewController.m_iAllPoint)
        {
            ShowAlertControl(Message: "已超過目前擁有點數")
        }else if( (m_iCounter + 1) > m_iGiftQty)
        {
            ShowAlertControl(Message: "已超過兌換數量")            
        }
        else
        {
            m_iCounter  =  m_iCounter + 1;
            m_labelCounter.text  = "\(m_iCounter)"
        }
    }
    
    
    @IBAction func onMinusClick(_ sender:UIButton)
    {
        m_iCounter  =  m_iCounter - 1;
        
        if(m_iCounter < 1)
        {
            m_iCounter = 1;
        }
        
        m_labelCounter.text  = "\(m_iCounter)"
        
    }
    
    
    @IBAction func onExchange(_ sender:UIButton)
    {
        if((m_iExchangePoint * m_iCounter) > PointGiftViewController.m_iAllPoint)
        {
            ShowAlertControl(Message: "已超過目前擁有點數 , 請確認點數是否足夠!")
            return;
        }
        
        
        
        let alert = UIAlertController(title: "兌換確認", message:"請確認是否要開始兌換，一經兌換完成後，不得取消兌換。",
                                      preferredStyle: .alert)
        
        
        
        
        let okButton  = UIAlertAction(title: "確認兌換", style: .default, handler: { [self] (UIAlertAction) in
            
            let strGiftID = (self.m_dicData.object(forKey:"gift_id") as! String);
            
            MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
            
            DCUpdater.shared()?.onLineChangeEVoucher(ConfigInfo.m_strAccessToken,
                                                     andGiftID: strGiftID, andScheduleID: m_strScheduleID, andExchangeQty: m_labelCounter.text);
            
        })
        alert.addAction(okButton)
        
        
        
        let cancelButton  =  UIAlertAction(title: "取消兌換", style: .default, handler: { (UIAlertAction) in
            
            
        })
        alert.addAction(cancelButton)
        
        
        okButton.setValue(UIColor.red, forKey: "titleTextColor")
        cancelButton.setValue(UIColor.black, forKey: "titleTextColor")
        
        self.present(alert, animated: true)
        
    }
    
    
    
    func ExchangeMessage(strTitle:String,strMessage:String,bIsNeedClose:Bool)
    {
        let alert = UIAlertController(title: strTitle, message:strMessage,
                                      preferredStyle: .alert)
        
        let okButton  = UIAlertAction(title: "確認", style: .default, handler: { [self] (UIAlertAction) in
            
            if(bIsNeedClose)
            {
                self.navigationController?.popViewController(animated: true);
            }
            
        })
        
        okButton.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(okButton)
        
        
        self.present(alert, animated: true)
    }
    
    
    
    @IBAction func onQueryValidPoint(_ sender:UIButton)
    {
        m_ValidPointView.isHidden =  false
        m_blackBGView.isHidden =  false
    }
    
    @IBAction func HideQueryValidPoint()
    {
        m_ValidPointView.isHidden =  true
        m_blackBGView.isHidden =  true
    }
    
    
    
    
           
}
