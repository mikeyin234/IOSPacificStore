//
//  VideoListViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/12/16.
//  Copyright © 2019 greatsoft. All rights reserved.
///////////////////////////////////////////////////////

import UIKit
import AVKit
import AVFoundation

class VideoListViewController: BaseViewController  , UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var mTableview: UITableView!
    @IBOutlet weak var mScrollView: UIScrollView!
    
    var    BUTTON_TYPE =  0;
    let   TITLE_WIDTH:CGFloat  =  120.0;
    var   m_buttonObject:[UIButton] = [];
    var m_ListTitleInfo:[NSDictionary] =  [];
    var m_ListDetailInfo:[NSDictionary] =  [];
    var m_imageCache  = NSMutableDictionary();
   // var m_videoPlayerViewController:XCDYouTubeVideoPlayerViewController!
    
//==================================================//
    func StarPlayYoutube(identifier:String)
    {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btSubNavBrandMain
                   = StoryBoard.instantiateViewController(withIdentifier: "Youtube") as! WKYoutubeViewController;
        
        btSubNavBrandMain.m_strVideoID = identifier;
        self.navigationController?.pushViewController(btSubNavBrandMain, animated: true)
        
    }
    
    func moviePlayerPlayBackDidFinish(notification: NSNotification)
    {
        print("moviePlayerPlayBackDidFinish")
        //self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func moviePlayerNowPlayingMovieDidChange(notification: NSNotification)
    {
        print("moviePlayerNowPlayingMovieDidChange")
    }
    
    func moviePlayerLoadStateDidChange(notification: NSNotification)
    {
        
    }
    
    func moviePlayerPlaybackDidChange(notification: NSNotification)
    {
      
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:VideoTableViewCell!;
        let strType = m_ListDetailInfo[indexPath.row].object(forKey:"Type") as! String
        
        
        Mycell = VideoTableViewCell(style: .default, reuseIdentifier: "Imagecell")
        Mycell.m_labelText.text  = (m_ListDetailInfo[indexPath.row].object(forKey:"Name") as!
            String);
        
        Mycell.m_labelViewText.text = "觀看次數:\((m_ListDetailInfo[indexPath.row].object(forKey:"Count") as! String))次"
        let strVideo = (m_ListDetailInfo[indexPath.row].object(forKey:"Video") as!
            String)
        
        
        var url = URL(string:"https://img.youtube.com/vi/\(strVideo)/0.jpg");
        if (strType == "1")
        {   
            let strImageName = (m_ListDetailInfo[indexPath.row].object(forKey:"ImageName") as!
                String);
            url = URL.initPercent(string: strImageName);
        }
        
        
        if  let cachedImage = m_imageCache.object(forKey: url!.absoluteString as NSString)
        {
            Mycell.m_imageView.image = (cachedImage as! UIImage)
        }else
        {
            
            fetchImage(from: url!.absoluteString) { image in
                // IMPORTANT: Update UI on the main thread
                DispatchQueue.main.async { [weak imageView = Mycell.m_imageView] in
                    
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
                 Mycell.m_imageView.image = image
             }*/
         }
        
        Mycell.m_labelText.font = UIFont.systemFont(ofSize: 20.0);
        Mycell.m_labelViewText.font = UIFont.systemFont(ofSize: 20.0);
        return Mycell
        
    }
    
    
    
    @objc func MoviePlayerPlaybackDidFinish(_ notification: NSNotification)
    {
    
        print("Movie ends.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        //mScrollView
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        
        DCUpdater.shared()?.getVideoTypes()
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
        let strType = m_ListDetailInfo[indexPath.row].object(forKey:"Type") as! String
        let strVideo = m_ListDetailInfo[indexPath.row].object(forKey: "Video");
        
        
        if (strType == "0")
        {
            let iID = m_ListDetailInfo[indexPath.row].object(forKey: "id") as! String;
            
            DCUpdater.shared()?.addVideoClickLog(Int32(iID)!, andAccessToken: ConfigInfo.m_strAccessToken)
            
            StarPlayYoutube(identifier: strVideo as! String);
        }else
        {
            UIApplication.shared.open(URL(string: strVideo as! String as! String)!, options:[:],completionHandler: nil);
        }
        
    }
    
    
   
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        mScrollView.showsHorizontalScrollIndicator = false;
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetVideoTypesResult), name:NSNotification.Name(rawValue: kDCGetVideoTypes), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetVideoDetailResult), name:NSNotification.Name(rawValue: kDCGetVideoDetail), object: nil)
        
         self.SetTitleColor();
         
//=====================================================//
         self.startTimeTick();
         
    }
    
    
    
    
    func AddButtonToScrollView(strTitle:String,iIndex:Int)
    {
        //put your code here
        let iLeft = CGFloat(iIndex) * TITLE_WIDTH;
        
        let button = UIButton.init(frame: CGRect(x: iLeft, y: 0, width: TITLE_WIDTH, height: self.mScrollView.frame.size.height))
        
        button.setTitle(strTitle, for: UIControl.State.normal)
        button.tag = iIndex;
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        ;
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
        
        DCUpdater.shared()?.getVideoDetail(idType);
        
    }
    
    
    
    
    @objc func didGetVideoTypesResult(notification: NSNotification){
        
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
                    DCUpdater.shared()?.getVideoDetail(idType);
                }else
                {
                     MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
                }
            }else
            {
                 MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////
    //
    //
    func AddFBVideoToScrollView(strFBURL:String, iIndex:Int)
       {
                    //put your code here
               
           /*
                    let iLeft = CGFloat(iIndex) * UIScreen.main.bounds.width;
           
           
           
                    //viewVideo.backgroundColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                   
                    self.m_scrollView.addSubview(fbWebView);
                    self.m_scrollView.addSubview(viewVideo);
            */
       }
    
    
    
    
    
    @objc func didGetVideoDetailResult(notification: NSNotification){
        
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
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_VIDEO_VIEW), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
        
    }
    
    
    
}
