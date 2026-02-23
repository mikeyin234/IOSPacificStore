//
//  DMViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/9.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit


class DMViewController: BaseViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mPageControl:UIPageControl!
    
     var m_ListTitleInfo:[NSDictionary] =  [];
   
     var m_imageCache  = NSMutableDictionary();
    
    var m_ImageDownloadIndex:[Int] =  [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.AddOnTouchClick(vTouch: mScrollView,action: #selector(self.onImageViewClick));
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getDMTypes();
        
        
    }
    
    
    @objc func  onImageViewClick(gesture: UITapGestureRecognizer)
    {
        
        if(mPageControl.currentPage < m_ListTitleInfo.count)
        {
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            
            let  btDMOnLineDetail
                = StoryBoard.instantiateViewController(withIdentifier: "DMOnLineDetail") as! DMDetailViewController;
        
            //let dataDic = m_ListTitleInfo[(gesture.view?.tag)!];
            let dataDic = m_ListTitleInfo[mPageControl.currentPage];
        
            btDMOnLineDetail.m_strTypeID  = dataDic.object(forKey: "id") as! String
        
            self.navigationController?.pushViewController(btDMOnLineDetail, animated: true)
        }
    }
    
    
    
  
    
   
        
        
    
    func AddImageToScrollView(image:UIImage,iIndex:Int)
    {
       
            let iLeft = CGFloat(iIndex) * UIScreen.main.bounds.width;
            
            let imageView = UIImageView.init(frame: CGRect(x: iLeft, y: 0, width: UIScreen.main.bounds.width, height: self.mScrollView.frame.size.height))
        
            imageView.image = image
            imageView.contentMode = UIView.ContentMode.scaleAspectFit;
            imageView.tag = iIndex;
        
            self.mScrollView.addSubview(imageView)        
    }
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView.isEqual(mScrollView) {
            
            let width = mScrollView.frame.size.width
            
            
            let currentPage:Int  = Int(((scrollView.contentOffset.x - width / 2) / width) + 1)
            
            mPageControl.currentPage = currentPage
            
            
            
            
        }
    }
    
    
    
    @objc func didGetDMTypesResult(notification: NSNotification){
        
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            self.mPageControl.numberOfPages  = 0;
            
            
            m_ImageDownloadIndex.removeAll()
            
            if(Int(strCode) == 0)
            {               
                let DataArray = dic.object(forKey: "Data") as! NSArray;
                
                var i = 0;
                for DataDic  in DataArray
                {
                    let dicData  = DataDic as! NSDictionary
                    m_ListTitleInfo.append(dicData)
                    let  imageName = dicData.object(forKey: "ImageName");
                    let url = URL(string:imageName as! String);
                    m_ImageDownloadIndex.append(i)
                    
                    
                    fetchImage(from: url!.absoluteString) { image in
                        // IMPORTANT: Update UI on the main thread
                        DispatchQueue.main.async { [index =  self.m_ImageDownloadIndex[0]] in
                            self.AddImageToScrollView(image: image!,iIndex: index);
                            self.m_ImageDownloadIndex.remove(at: 0)
                        }
                    }
            
                    i += 1;
                }
                
                
                
                self.mPageControl.numberOfPages  = m_ListTitleInfo.count;
                
                let fWidth  =  UIScreen.main.bounds.width * CGFloat(m_ListTitleInfo.count);
                
                self.mScrollView.contentSize = CGSize(width: fWidth, height: self.mScrollView.frame.size.height)
                mScrollView.showsHorizontalScrollIndicator = false;
                
            }else
            {
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
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_ONLIE_DM), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
    }
    
    
  
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        mScrollView.showsHorizontalScrollIndicator = false;
        
        SetTitleColor()
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetDMTypesResult), name:NSNotification.Name(rawValue: kDCGetDMTypes), object: nil)
        
        self.startTimeTick();
    }
    
    
    
}
