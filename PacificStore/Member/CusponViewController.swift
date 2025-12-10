//
//  CusponViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/4/4.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

//全部兌換卷查詢
class CusponViewController:BaseViewController,
UITableViewDelegate,UITableViewDataSource{
    
    
    
    var m_ListDetailInfo:[NSDictionary] =  [];
    var m_imageCache  = NSMutableDictionary();
    
    
    @IBOutlet weak var mTableview: UITableView!
    @IBOutlet weak var mlabelTitle: UILabel!
    @IBOutlet weak var mlabelSubTitle: UILabel!
    
    
    var  m_strID =  "0";
    var  m_strTitle =  "";
    var  m_strSubTitle =  "";
    //var m_ListDetailInfo:[NSDictionary] =  [];
    
    let m_menuOption = ["ActivitePrize","GamePrize","ProPrize",
                        "RegisterPrize","SharePrize","UsedActivitePrize",
                        "UsedGamePrize", "UsedProPrize",
                        "UsedRegisterPrize","UsedSharePrize"];
    
    
    var   m_buttonObject:[UIButton] = [];
    
    
    var   m_iFirstInfoCount  =  0;
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:PointGiftTableViewCell!;
        
        
        let cell: PointGiftTableViewCell = PointGiftTableViewCell(style: .default, reuseIdentifier: "Imagecell")
        
        
        let dicInfo  = m_ListDetailInfo[indexPath.row];
        let  iType  = Int(m_ListDetailInfo[indexPath.row].object(forKey: "Type") as! String)!;
        
        if( iType != 100)
        {
            
            var  strStartDate  = dicInfo.object(forKey:"StartDate") as! String
            var  strEndDate  = dicInfo.object(forKey:"EndDate") as! String
            
            strStartDate = String(strStartDate.prefix(10));
            strEndDate   = String(strEndDate.prefix(10));
            let strNameTitle = dicInfo.object(forKey:"Name") as! String
            
            ///////////////
            //0  1  2 10
            
            //let iType  = dicInfo.object(forKey:"Type") as! String
            let strUsed  = m_ListDetailInfo[indexPath.row].object(forKey: "IsUsed") as! String;
            
            let  iType  = Int(m_ListDetailInfo[indexPath.row].object(forKey: "Type") as! String)!;
            var  iImageType = 0;
            
            let  bIsUsed  = (strUsed == "True") ? true : false;
            
            
            if(!bIsUsed)
            {
                if(iType == 0)
                {
                    iImageType = 3;
                }else if(iType == 1)
                {
                    iImageType = 2;
                }else if(iType == 2)
                {
                    iImageType = 4;
                }else
                {
                    iImageType = 1;
                }
            }else
            {
                if(iType == 0)
                {
                    iImageType = 8;
                }else if(iType == 1)
                {
                    iImageType = 9;
                }else if(iType == 2)
                {
                    iImageType = 7;
                }else
                {
                    iImageType = 6;
                }
            }
            
            let image = UIImage(named: m_menuOption[iImageType])
            
            //m_imageCache.setObject(image as Any, forKey: url!.absoluteString as NSString)
            cell.LoadData(image: image!,strTitle: strNameTitle , strDate: "兌換期限\(strStartDate) - \(strEndDate)")
            
        }else
        {
            var  strStartDate  = dicInfo.object(forKey:"use_start_date") as! String
            
            var  strEndDate  = dicInfo.object(forKey:"use_close_date") as! String
            
            //===========
            strStartDate.insert("/", at: strStartDate.index(strStartDate.startIndex, offsetBy: 4))
            strStartDate.insert("/", at: strStartDate.index(strStartDate.startIndex, offsetBy: 7))
            
            
            strEndDate.insert("/", at: strEndDate.index(strEndDate.startIndex, offsetBy: 4))
            strEndDate.insert("/", at: strEndDate.index(strEndDate.startIndex, offsetBy: 7))
                        
            let strNameTitle = dicInfo.object(forKey:"gift_name") as! String
            
            
            var image:UIImage!;
            let strUsed  = m_ListDetailInfo[indexPath.row].object(forKey: "IsUsed") as! String;
            let  bIsUsed  = (strUsed == "True") ? true : false;
            if(bIsUsed)
            {
                image = UIImage(named: m_menuOption[5])
            }else
            {
                image = UIImage(named: m_menuOption[0])
            }
            
            //m_imageCache.setObject(image as Any, forKey: url!.absoluteString as NSString)
            cell.LoadData(image: image!,strTitle: strNameTitle , strDate: "兌換期限\(strStartDate) - \(strEndDate)")
            
        }
        
        Mycell = cell;
        return Mycell
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        
        DCUpdater.shared()?.getECusponMessage(ConfigInfo.m_strAccessToken);
        
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        SetTitleColor()
        
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetBrandDetailResult), name:NSNotification.Name(rawValue: GetECusponMessage), object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryExchangeVoucher), name:NSNotification.Name(rawValue: kDCQueryExchangeVoucher), object: nil)
        
        
        
        
        self.startTimeTick();
        
    }
    
    
    @objc func didGetBrandDetailResult(notification: NSNotification){
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
      
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            m_ListDetailInfo.removeAll();
            
            if(Int(strCode) == 0)
            {
                let DataArray = dic.object(forKey: "Data") as! NSArray;
                
                for DataDic  in DataArray
                {
                    let dicData  = DataDic as! NSDictionary
                    m_ListDetailInfo.append(dicData)
                }
                
                m_iFirstInfoCount = m_ListDetailInfo.count;
                
            }
            /*else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }*/
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
        
        
        DCUpdater.shared()?.queryExchangeVoucher(ConfigInfo.m_strAccessToken);
        
        
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
        
        let  iType  = Int(m_ListDetailInfo[indexPath.row].object(forKey: "Type") as! String)!;
        
        if(iType != 100 )
        {
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            
            let  btCuponMain
                = StoryBoard.instantiateViewController(withIdentifier: "CusponDetail") as! CuponDetailViewController;
            
            btCuponMain.m_strWebPage   = m_ListDetailInfo[indexPath.row].object(forKey: "WebPage") as! String
            
            btCuponMain.m_strTitle  =   m_ListDetailInfo[indexPath.row].object(forKey: "Name") as! String
            
            btCuponMain.m_strImagePath  =   m_ListDetailInfo[indexPath.row].object(forKey: "VolumeCodeImage") as! String
            
            
            
            btCuponMain.m_strVolumeCode  =   m_ListDetailInfo[indexPath.row].object(forKey: "VolumeCode") as! String
            
            
             CuponDetailViewController.m_strUseDate  =   m_ListDetailInfo[indexPath.row].object(forKey: "UseDate") as! String
            
            btCuponMain.m_iType  = Int(m_ListDetailInfo[indexPath.row].object(forKey: "Type") as! String)!;
            
            btCuponMain.m_strID  =   m_ListDetailInfo[indexPath.row].object(forKey: "id") as! String
            
            let strUsed  = m_ListDetailInfo[indexPath.row].object(forKey: "IsUsed") as! String;
            
            btCuponMain.m_strIsUsed  =  strUsed == "True"  ? true: false;
            
            self.navigationController?.pushViewController(btCuponMain, animated: true)
        }else
        {
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            
            let  btAllCuponContentViewController
                = StoryBoard.instantiateViewController(withIdentifier: "AllCusponExchange") as! AllCuponContentViewController;
            
            btAllCuponContentViewController.m_dirData  = m_ListDetailInfo[indexPath.row];
            
            self.navigationController?.pushViewController(btAllCuponContentViewController, animated: true)
        }
       
        
    }
    
    
    @objc func didQueryExchangeVoucher(notification: NSNotification){
        
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            
            //m_ListDetailInfo.removeAll();
            //m_imageCache.removeAllObjects();
            
            if(Int(strCode) == 0)
            {
                ConfigInfo.IMAGES_SITE = (dic.object(forKey: "ImageSite") as! String)
                
                
                let dicData  =  dic.object(forKey: "Data") as! NSDictionary;
                let DataArray = dicData.object(forKey: "coupon") as! NSArray;
                
                for DataDic  in DataArray
                {
                    let dicDataCur  = DataDic as! NSMutableDictionary
                    let strStatus  =  dicDataCur.object(forKey: "use_status") as! String
                    //未核銷
                    dicDataCur.setValue(strStatus == "未核銷" ?  "False" : "True", forKey: "IsUsed")
                    
                    dicDataCur.setValue("100", forKey: "Type")
                    
                    m_ListDetailInfo.append(dicDataCur)
                    
                }
                
                
               
                m_ListDetailInfo.sort { (dic1, dic2) -> Bool in
                    
                    let strIsUsed = dic1.object(forKey: "IsUsed") as! String;
                    let strIsUsed2 = dic2.object(forKey: "IsUsed") as! String;
                    
                    return strIsUsed.compare(strIsUsed2) == .orderedAscending
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
