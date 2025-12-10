//
//  NavSubMainViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/5.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class NavSubMainViewController: BaseViewController,
UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var mTableview: UITableView!
    @IBOutlet weak var mlabelTitle: UILabel!
    @IBOutlet weak var mlabelSubTitle: UILabel!
    var  m_strFloor =  "";
    
    
    var  m_strID =  "0";
    var  m_strTitle =  "";
    var  m_strSubTitle =  "";
    var m_ListDetailInfo:[NSDictionary] =  [];
    
    var  m_strBrandType =  "1";
    
    var  m_strName =  "";
    
     var m_imageCache  = NSMutableDictionary();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        
        if(m_strBrandType == "3")
        {
            m_strTitle = "品牌搜尋";
            mlabelTitle.text  =  m_strTitle;
            mlabelSubTitle.text  = "品牌搜尋";
            
            DCUpdater.shared()?.searchBrandDetail(m_strName)
            
        }else
        {
            mlabelTitle.text  =  m_strTitle;
            
            if(m_strFloor.count>0)
            {
              mlabelSubTitle.text  = "\(m_strFloor) - \(m_strSubTitle)";
            }else
            {
                 mlabelSubTitle.text  = m_strSubTitle;                
            }
            
            DCUpdater.shared()?.getBrandDetail(m_strID, andType: m_strBrandType)
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

    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var Mycell:BrandDetailTableViewCell!;
        
        let cell: BrandDetailTableViewCell = BrandDetailTableViewCell(style: .default, reuseIdentifier: "Imagecell")
        
        cell.m_labelText.text  = m_ListDetailInfo[indexPath.row].object(forKey:"Name") as! String;
        
        
        
        
        let url = URL(string:m_ListDetailInfo[indexPath.row].object(forKey:"ImageName")as! String);
        
        if  let cachedImage = m_imageCache.object(forKey: url!.absoluteString as NSString)
        {
            cell.m_imageView.image = (cachedImage as! UIImage)
        }else
        {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
            if(data != nil)
            {
                let image = UIImage(data: data!)!
                m_imageCache.setObject(image, forKey: url!.absoluteString as NSString)
                cell.m_imageView.image = image
            }
        }
        
        let strYoutube  = m_ListDetailInfo[indexPath.row].object(forKey: "YoutubeID") as! String
        if(strYoutube.count>0)
        {
             cell.m_imagePlayView.image = UIImage(named: "VideoView");
             cell.m_imagePlayView.isHidden = false;
        }else
        {
             cell.m_imagePlayView.isHidden = true;
        }
        
        cell.m_labelText.font = UIFont.systemFont(ofSize: 20.0);
        Mycell = cell;
        
        return Mycell
    }
    
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btSubNavBrandMain
            = StoryBoard.instantiateViewController(withIdentifier: "BrandDetail") as! BrandDetailViewController;
        
        btSubNavBrandMain.m_strWebPage   = m_ListDetailInfo[indexPath.row].object(forKey: "WebPage") as! String
        
      
        btSubNavBrandMain.m_strSubTitle = m_ListDetailInfo[indexPath.row].object(forKey: "Name") as! String
        
//================================================//
        btSubNavBrandMain.m_strYoutubeFile = "";
        if( m_ListDetailInfo[indexPath.row].object(forKey: "YoutubeID") != nil)
        {
             btSubNavBrandMain.m_strYoutubeFile = m_ListDetailInfo[indexPath.row].object(forKey: "YoutubeID") as! String
        }
        
       
        
        
        //btSubNavBrandMain.m_strYoutubeFile = "RJAyBkfXKAo";
        
        
        
        if(m_strBrandType == "3")
        {
             btSubNavBrandMain.m_strTitle =  "品牌搜尋";
            
             m_strFloor =  m_ListDetailInfo[indexPath.row].object(forKey: "Floor") as! String
            
             btSubNavBrandMain.m_strSubTitle = m_strFloor + " - " + btSubNavBrandMain.m_strSubTitle;
        }else
        {
             m_strFloor =  m_ListDetailInfo[indexPath.row].object(forKey: "Floor") as! String
             
             btSubNavBrandMain.m_strTitle  =  m_strSubTitle;
             btSubNavBrandMain.m_strSubTitle = m_strFloor + " - " + btSubNavBrandMain.m_strSubTitle;
        }
        
        self.navigationController?.pushViewController(btSubNavBrandMain, animated: true)
        
    }
    
   
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetBrandDetailResult), name:NSNotification.Name(rawValue: kDCGetBrandBuildingDetail), object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetSearchDetailResult), name:NSNotification.Name(rawValue: kDCSearchBrandDetail), object: nil)
        
         self.SetTitleColor();
        
    }
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
        
    }
    
    
    @objc func didGetBrandDetailResult(notification: NSNotification){
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
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
    
    
    
    @objc func didGetSearchDetailResult(notification: NSNotification){
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
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
    
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(NewsTableViewCell.MainHeight);
    }
    
    
}
