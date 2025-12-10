//
//  DMDetailViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/9.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit


class DMDetailViewController: BaseViewController,ImageScrollViewDelegate
                  
{

    @IBOutlet weak var mScrollView: ImageScrollView!
    
    @IBOutlet weak var mSmallScrollView: UIScrollView!
    let   TITLE_WIDTH:CGFloat  =  80.0;
    var  m_strTypeID = "0";
    var m_ListTitleInfo:[NSDictionary] =  [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DCUpdater.shared()?.getDMsDetail(m_strTypeID);
        
       
        
        mScrollView.setup()
        mScrollView.imageScrollViewDelegate = self
        mScrollView.imageContentMode = .aspectFit
        mScrollView.initialOffset = .center
        
        mSmallScrollView.delegate  = self;
        self.AddOnTouchClick(vTouch: mSmallScrollView,action: #selector(self.onImageViewClick));
    }
    
   
    @objc func  onImageViewClick( _ sender: UITapGestureRecognizer)
    {
        
        let touchPoint =  sender.location(in: mSmallScrollView);
        let iPos = touchPoint.x  / (TITLE_WIDTH + 10);
        let iSelect = Int(iPos);
        
         ShowImage(iSelect: iSelect);
        
    }
    
    func ShowImage(iSelect:Int)
    {
        if(iSelect < m_ListTitleInfo.count)
        {
            let dataDic = m_ListTitleInfo[iSelect];
            let  imageName = dataDic.object(forKey: "ImageName");
            
            let url = URL(string:imageName as! String);
            
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
            let image = UIImage(data: data!)!
            mScrollView.display(image:  image)            
        }
    }
    
    func AddImageToScrollView(image:UIImage,iIndex:Int)
    {
        var iLeft = CGFloat(iIndex) * TITLE_WIDTH;
        iLeft += (CGFloat(iIndex) * 10);
        
        
        let imageView = UIImageView.init(frame: CGRect(x: iLeft, y: 0, width: TITLE_WIDTH, height: self.mSmallScrollView.frame.size.height))
        
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        imageView.tag = iIndex;
        imageView.isUserInteractionEnabled = true;
        
        self.mSmallScrollView.addSubview(imageView)
    }
    
    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
      
        
        mScrollView.showsHorizontalScrollIndicator = false;
        
        SetTitleColor()
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetDMDetailResult), name:NSNotification.Name(rawValue: kDCGetDMsDetail), object: nil)
        
    }
    
    
    @objc func didGetDMDetailResult(notification: NSNotification){
        
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
                let DataArray = dic.object(forKey: "Data") as! NSArray;
                
                var i = 0;
                for DataDic  in DataArray
                {
                    let dicData  = DataDic as! NSDictionary
                    m_ListTitleInfo.append(dicData)
                    
                    let  imageName = dicData.object(forKey: "SmallImageName");
                    let url = URL(string:imageName as! String);
                    
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
                    let image = UIImage(data: data!)!
                    
                    self.AddImageToScrollView(image: image,iIndex: i);
                    
                    i += 1;
                }
                
                
                var fWidth  =  TITLE_WIDTH * CGFloat(m_ListTitleInfo.count);
                let fSpace =  10 *  CGFloat(m_ListTitleInfo.count);
                fWidth += fSpace;
                
                self.mSmallScrollView.contentSize = CGSize(width: fWidth, height: self.mSmallScrollView.frame.size.height);
                
                mSmallScrollView.showsHorizontalScrollIndicator = false;
                
                if(m_ListTitleInfo.count > 0)
                {
                    ShowImage(iSelect: 0);
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
        
    }
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        RemoveTitleBar()
    }
    
  
  
    
}

