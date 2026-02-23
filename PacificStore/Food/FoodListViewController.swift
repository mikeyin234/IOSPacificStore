//
//  FoodListViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/6.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class FoodListViewController: BaseViewController  , UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var mTableview: UITableView!
    @IBOutlet weak var mScrollView: UIScrollView!
    
    var    BUTTON_TYPE =  0;
    
    let   TITLE_WIDTH:CGFloat  =  120.0;
    var   m_buttonObject:[UIButton] = [];
    
    
    var m_ListTitleInfo:[NSDictionary] =  [];
    var m_ListDetailInfo:[NSDictionary] =  [];
    var m_imageCache  = NSMutableDictionary();
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:NewsTableViewCell!;
        
        let cell: NewsTableViewCell = NewsTableViewCell(style: .default, reuseIdentifier: "Imagecell")
        
        cell.m_labelText.text  = (m_ListDetailInfo[indexPath.row].object(forKey:"Name") as! String);
        
        let url = URL(string:m_ListDetailInfo[indexPath.row].object(forKey:"ImageName")as! String);
        if  let cachedImage = m_imageCache.object(forKey: url!.absoluteString as NSString)
        {
            cell.m_imageView.image = (cachedImage as! UIImage)
        }else
        {
            
            
            fetchImage(from: url!.absoluteString) { image in
                // IMPORTANT: Update UI on the main thread
                DispatchQueue.main.async { [weak imageView = cell.m_imageView] in
                    
                    self.m_imageCache.setObject(image!, forKey: url!.absoluteString as NSString)
                    imageView?.image = image!
                }
            }
            
            /*
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
            if(data != nil)
            {
                let image = UIImage(data: data!)!
                m_imageCache.setObject(image, forKey: url!.absoluteString as NSString)
                cell.m_imageView.image = image
            }*/
            
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        //mScrollView
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getFoodTypes();
//
        
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
      
            return CGFloat(NewsTableViewCell.MainHeight);
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let webPage  = ["restaurant.htm","snack.htm","coffee.htm"];
        let strName = m_ListDetailInfo[indexPath.row].object(forKey: "Name");
        let strWebPage = m_ListDetailInfo[indexPath.row].object(forKey: "WebPage");
        
        let strYoutube  = m_ListDetailInfo[indexPath.row].object(forKey: "YoutubeID") as! String
        
        //onGotoFoodDetailBrand(strName: strName as! String,strWebpage: strWebPage as! String);
        
        onGotoFoodDetailBrand(strName: strName as! String,strWebpage: strWebPage as! String,strYoutube: strYoutube);
        
    }
    
    
    func onGotoFoodDetailBrand(strName:String,strWebpage:String,strYoutube:String) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btFoodDetail
            = StoryBoard.instantiateViewController(withIdentifier: "FoodDetail") as! FoodDetailViewController;
        
        btFoodDetail.m_WebPage  = strWebpage;
        btFoodDetail.m_strTitle = m_ListTitleInfo[BUTTON_TYPE].object(forKey: "TypeName") as! String
        btFoodDetail.m_strSubTitle  = strName;
        
        btFoodDetail.m_strYoutubeFile  =  strYoutube;
        //btFoodDetail.m_strYoutubeFile  = "RJAyBkfXKAo"
        
        self.navigationController?.pushViewController(btFoodDetail, animated: true)
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        mScrollView.showsHorizontalScrollIndicator = false;
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetFoodTypesResult), name:NSNotification.Name(rawValue: kDCGetFoodTypes), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetFoodDetailResult), name:NSNotification.Name(rawValue: kDCGetFoodsDetail), object: nil)
        
         self.SetTitleColor();
        
         self.startTimeTick();
         
    }
    
    
    
    
    func AddButtonToScrollView(strTitle:String,iIndex:Int)
    {
        //put your code here
        let iLeft = CGFloat(iIndex) * TITLE_WIDTH;
        
        let button = UIButton.init(frame: CGRect(x: iLeft, y: 0, width: TITLE_WIDTH, height: self.mScrollView.frame.size.height))
        
        button.setTitle(strTitle, for: UIControl.State.normal)
        button.tag = iIndex;
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0);
        button.addTarget(self, action: #selector(SelectFoodType), for: .touchUpInside)
        
        
        if(iIndex != 0 )
        {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        
        m_buttonObject.append(button)
        
        self.mScrollView.addSubview(button);
        
        
    }
    
    
  
  
    @objc func SelectFoodType(sender: UIButton){
        
        for button in m_buttonObject {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        
        BUTTON_TYPE  = sender.tag;
        sender.setTitleColor(UIColor.white, for: UIControl.State.normal)
        let idType = m_ListTitleInfo[BUTTON_TYPE].object(forKey: "id") as! String
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getFoodsDetail(idType);
        
    }

    
    
    
    @objc func didGetFoodTypesResult(notification: NSNotification){
        
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            if(Int(strCode) == 0)
            {              
                let DataArray = dic.object(forKey: "Data") as! NSArray;
                
                var i = 0;
                for DataDic  in DataArray
                {
                    let dicData  = DataDic as! NSDictionary
                    
                    m_ListTitleInfo.append(dicData)
                    
                    let strTypeName  =  dicData.object(forKey: "TypeName") as! String;
                    
                    AddButtonToScrollView(strTitle: strTypeName,iIndex: i)
                    
                    i += 1;
                }
                
                let fWidth  =  TITLE_WIDTH * CGFloat(m_ListTitleInfo.count);
                self.mScrollView.contentSize = CGSize(width: fWidth, height: self.mScrollView.frame.size.height)
                
                if(i>0)
                {
                    let idType = m_ListTitleInfo[0].object(forKey: "id") as! String
                    DCUpdater.shared()?.getFoodsDetail(idType);
                    
                }
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    
    
    @objc func didGetFoodDetailResult(notification: NSNotification){
        
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
                let DataArray = dic.object(forKey: "Data") as! NSArray;
                
                for DataDic  in DataArray
                {
                    let dicData  = DataDic as! NSDictionary
                    m_ListDetailInfo.append(dicData)
                }
                
                mTableview.reloadData();
            }else
            {
                mTableview.reloadData();
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
        
        //================================================================================//
        self.stopTimeTick();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_FOOD), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
    }
    
    
    
}
