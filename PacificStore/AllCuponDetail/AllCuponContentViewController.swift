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
class AllCuponContentViewController: BaseViewController{
    
    @IBOutlet var m_labelName : UILabel!
//===================================================//
    @IBOutlet var m_viewExchange: UIView!
    @IBOutlet var m_viewUsed : UIView!
    @IBOutlet var m_scrollviewCupon : UIScrollView!
    @IBOutlet var m_dirData : NSDictionary!
    
    
//================================================//
    @IBOutlet var m_viewImageTitle: UIImageView!
    
    var m_bIsUsed = false;
    
    var m_addAddCuponDetail  = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //m_labelName.text =  ConfigInfo.m_strName;
        //SetCardType();
        //MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        //DCUpdater.shared()?.getMemberPoints(ConfigInfo.m_strAccessToken)
        let strUsed  = m_dirData.object(forKey: "IsUsed") as! String;
        m_bIsUsed =  strUsed == "True"  ? true: false;
        
        
        
        
        
        m_viewUsed.isHidden  = !m_bIsUsed;
        m_viewExchange.isHidden  = m_bIsUsed;
        //AddCuponDetail();
        
       
       
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        //Protected Double Call
        if(!m_addAddCuponDetail)
        {
            AddCuponDetail();
            m_addAddCuponDetail =  true;
        }
    }
    
    
    
    func AddCuponDetail()
    {
        
        print("AddCuponDetail");
        
        //put your code here
        //put your code here
        let iWidth  = self.m_scrollviewCupon.frame.size.width;
        let iHeight  = iWidth / ConfigInfo.m_fImageRatio;
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 5, width: self.m_scrollviewCupon.frame.size.width,
            height: iHeight))
        
//========================================================================//
        let strURL = "\(ConfigInfo.IMAGES_SITE)/\((m_dirData.object(forKey:"img_url") as! String))"
        let url = URL(string: strURL)!
        let data = try? Data(contentsOf: url) //make sure your image in this url does exist,
        
        
        var iTop =  240;
        if(data != nil)
        {
           let image = UIImage(data: data!)!
           imageView.contentMode = .scaleToFill
           imageView.image = image;
           imageView.contentMode = UIView.ContentMode.scaleAspectFit;
           self.m_scrollviewCupon.addSubview(imageView);
           
        }else
        {
            iTop =  5;
        }
        
        
        let labelTitle = UILabel.init(frame: CGRect(x: 20, y: iTop, width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelTitle.font  = UIFont.systemFont(ofSize: 25.0);
        labelTitle.text  = (m_dirData.object(forKey: "gift_name") as! String)
        self.m_scrollviewCupon.addSubview(labelTitle);
        
        
        iTop +=  40;
        let labelLimit = UILabel.init(frame: CGRect(x: 20, y: iTop, width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelLimit.font  = UIFont.systemFont(ofSize: 20.0);
        
        
        var strCloseDate  = m_dirData.object(forKey: "use_close_date") as! String;
        
        var strStartDate  = m_dirData.object(forKey: "use_start_date") as! String;
        
        strCloseDate.insert("/", at: strCloseDate.index(strCloseDate.startIndex, offsetBy: 4))
        strCloseDate.insert("/", at: strCloseDate.index(strCloseDate.startIndex, offsetBy: 7))
        
        
        strStartDate.insert("/", at: strStartDate.index(strStartDate.startIndex, offsetBy: 4))
        strStartDate.insert("/", at: strCloseDate.index(strStartDate.startIndex, offsetBy: 7))
        
        labelLimit.text  = "兌換期限：\(strStartDate)-\(strCloseDate)"
        self.m_scrollviewCupon.addSubview(labelLimit);
        
        
        iTop +=  40;
        let labelPoint = UILabel.init(frame: CGRect(x: 20, y: iTop, width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelPoint.font  = UIFont.systemFont(ofSize: 20.0);
        
        let string = NSMutableAttributedString(string: "兌換點數：\(m_dirData.object(forKey: "wallet_qty") as! Int64)點")
        string.setColorForText("\(m_dirData.object(forKey: "wallet_qty") as! Int64)點", with: UIColor.red)
        labelPoint.attributedText = string
        self.m_scrollviewCupon.addSubview(labelPoint);
        
        
        iTop +=  40;
        let labelAddress = UILabel.init(frame: CGRect(x: 20, y: iTop, width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        labelAddress.font  = UIFont.systemFont(ofSize: 20.0);
        labelAddress.text  = "兌換地點：\(m_dirData.object(forKey: "place") as! String)"
        self.m_scrollviewCupon.addSubview(labelAddress);
        
       
        
        
        iTop +=  40;
        let labelMark = UILabel.init(frame: CGRect(x: 20, y: iTop, width: Int(self.m_scrollviewCupon.frame.size.width-20),
            height: 30))
        
        labelMark.text  = "注意事項：\n\(m_dirData.object(forKey: "remark") as! String)"
        labelMark.font  = UIFont.systemFont(ofSize: 12.0);
        
        
        labelMark.numberOfLines = 0;
        labelMark.lineBreakMode = .byWordWrapping;
        labelMark.sizeToFit();
        labelMark.autoresize();
        
       // let iHeightLabelMark = labelMark.frame.height;
        
        
        
        self.m_scrollviewCupon.addSubview(labelMark);
        
    }
    
    
   
    
    
    
  
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didMemberPointResult), name:NSNotification.Name(rawValue: kDCGetMemberPoints), object: nil)
        
        self.SetTitleColor();
        super.viewWillAppear(animated)
        
//==================================================//
        self.startTimeTick();
        
    }
    
    
    
    @objc func didMemberPointResult(notification: NSNotification){
        
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
                 let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                
            }
            else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
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
        
        
        if(segue.identifier == "Barcode")
        {           
            let barcodeViewController =  segue.destination as!  BarCodeViewController
            let strUsed  = m_dirData.object(forKey: "IsUsed") as! String;
            barcodeViewController.m_bIsUsed  =  strUsed == "True"  ? true: false;
            barcodeViewController.m_strBarcode  = m_dirData.object(forKey: "barcode") as! String
            
        }else if((segue.identifier?.elementsEqual("usedView")) != nil)
        {
            //m_strExchangeDate
            let usedViewController =  segue.destination as!  UsedViewController            
            //let strUsed  = m_dirData.object(forKey: "IsUsed") as! String;
            //usedViewController.m_strExchangeDate  =  strUsed == "True"  ? true: false;
            usedViewController.m_strExchangeDate  = m_dirData.object(forKey: "trans_date") as! String
        }
        
    }
    

    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
   
    
   
    
    
    @IBAction func onExchange(_ sender:UIButton)
    {
        let alert = UIAlertController(title: "兌換確認", message:"請確認是否要開始兌換，一經兌換完成後，不得取消兌換。",
                                      preferredStyle: .alert)
        
        
        
        
        let okButton  = UIAlertAction(title: "確認兌換", style: .default, handler: { (UIAlertAction) in
        })
        alert.addAction(okButton)
        
        
        
        let cancelButton  =  UIAlertAction(title: "取消兌換", style: .default, handler: { (UIAlertAction) in
        })
        alert.addAction(cancelButton)
        
        
        okButton.setValue(UIColor.red, forKey: "titleTextColor")
        cancelButton.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        self.present(alert, animated: true)
      
        
    }
    
    
    func ExchangeMessage(strTitle:String,strMessage:String)
    {
        let alert = UIAlertController(title: strTitle, message:strMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { (UIAlertAction) in
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
    
   
    
}
