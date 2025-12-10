//
//  PointGiftViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/4/2.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

/////////////////////////////////////////////////////////
//點數換好禮
/////////////////////////////////////////////////////////
class PointGiftViewController: BaseViewController , UITableViewDelegate,UITableViewDataSource {
    
    
    var m_ListDetailInfo:[NSDictionary] =  [];
    var m_imageCache  = NSMutableDictionary();
    
    
    @IBOutlet weak var mTableview: UITableView!
    let   TITLE_WIDTH:CGFloat  =  120.0;
    
    var    BUTTON_TYPE =  0;
    var   m_buttonObject:[UIButton] = [];
    
    static  var  m_iAllPoint =  0;
    static  var  m_iThisPoint =  0;
    static  var  m_iNextPoint =  0;
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
    }
    
    
    func isNsnullOrNil(object : AnyObject?) -> Bool
    {
        if (object is NSNull) || (object == nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:PointGiftTableViewCell!;
        let cell: PointGiftTableViewCell = PointGiftTableViewCell(style: .default, reuseIdentifier: "Imagecell")
        
        
        //let url2 = URL(string: "http://125.227.197.21/images/test.png");
//============================================================//
        let  dicImage =  m_ListDetailInfo[indexPath.row];
//============================================================//
        var  strURL = "";
        if(!(dicImage.object(forKey: "img_url") is NSNull))
        {
            if((dicImage.object(forKey:"img_url") as! String).count > 0)
            {
                strURL = "\(ConfigInfo.IMAGES_SITE)/\((dicImage.object(forKey:"img_url") as! String))"
            }
        }
        
       
            
            let strURL2  = (dicImage.object(forKey:"img_url") as! String);
            
            if   let cachedImage = m_imageCache.object(forKey: strURL2)
            {
                  cell.LoadData(image: cachedImage as! UIImage)
            }else
            {
                var image:UIImage! = nil
                if( strURL.count > 0)
                {
                    let url  = URL(string: strURL)!
                    let data = try? Data(contentsOf: url)
                    if(data != nil)
                    {
                        image = UIImage(data: data!)!
                        m_imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    }
                }
                
                let strTitle  = m_ListDetailInfo[indexPath.row].object(forKey:"schedule_name")as! String
                var strStartDate  = m_ListDetailInfo[indexPath.row].object(forKey:"start_date")as! String
                strStartDate  = ConfigInfo.FormatDateStirng(strDate: strStartDate);
                
                var strEndDate  = m_ListDetailInfo[indexPath.row].object(forKey:"close_date")as! String
                strEndDate  = ConfigInfo.FormatDateStirng(strDate: strEndDate);
                
                cell.LoadDataPointGift(image:  image,
                                       strTitle: strTitle, strDate: "活動期限：\(strStartDate) -\(strEndDate)")
                
            }
        
        
        
       
        Mycell = cell;
        
        return Mycell
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        // Do any additional setup after loading the view.
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        
      
        
        DCUpdater.shared()?.queryCanChangeEVoucher(ConfigInfo.m_strAccessToken);
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        SetTitleColor()
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetCanChangeEVoucherResult), name:NSNotification.Name(rawValue: kDCQueryCanChangeEVoucher), object: nil)
        
        self.startTimeTick();
        
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        RemoveTitleBar()
        
        self.stopTimeTick();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_CHANGE_GIFT), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(PointGiftTableViewCell.MainHeight);
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btPointChangePrize
                   = StoryBoard.instantiateViewController(withIdentifier: "PointChangePrizeList") as! PointCHPrizeListViewController
        
        btPointChangePrize.m_dicData  = m_ListDetailInfo[indexPath.row];
        
        self.navigationController?.pushViewController(btPointChangePrize, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    
    
    @objc func didGetCanChangeEVoucherResult(notification: NSNotification){
        
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            
            m_ListDetailInfo.removeAll();
            m_imageCache.removeAllObjects();
            
            if(Int(strCode) == 0)
            {
                let dicData = dic.object(forKey: "Data") as! NSDictionary;
                
               
                ConfigInfo.IMAGES_SITE = (dic.object(forKey: "ImageSite") as! String)
                
                
                PointGiftViewController.m_iAllPoint = dicData.object(forKey: "all_point") as! Int
                PointGiftViewController.m_iThisPoint = dicData.object(forKey: "this_point") as! Int
                PointGiftViewController.m_iNextPoint = dicData.object(forKey: "next_point") as! Int
                
                
                let dataArray = dicData.object(forKey: "schedule") as! NSArray
                
                for DataDic  in dataArray
                {
                    let dicData  = DataDic as! NSDictionary
                    m_ListDetailInfo.append(dicData)
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
    
    
    
}
