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
class PointCHPrizeListViewController: BaseViewController,
                                UITableViewDelegate,UITableViewDataSource{
                        
    @IBOutlet var m_labelName : UILabel!
    @IBOutlet var m_labelCardType : UILabel!
    @IBOutlet var m_labelCurPoint : UILabel!
    @IBOutlet weak var m_textTable:UITableView!
    
//===================================================
    var m_ListConsumeInfo:[NSDictionary] =  [];
    var m_ListOrgConsumeInfo:[NSDictionary] =  [];
    
//================================
    var  m_iType = 0;  //0 = 消費 1 = 收
    var  m_iCurrentSelect = 0;
    var  m_dicData:NSDictionary!
    var  m_iSortType = 0
    
    @IBOutlet var m_buttonSortType : UIButton!
    @IBOutlet var m_ValidPointView : UIView!
    @IBOutlet var m_btnQueryPointValidDate : UIButton!
    

    @IBOutlet var m_blackBGView : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
        //DCUpdater.shared()?.getMemberPoints(ConfigInfo.m_strAccessToken)
       
        
        m_ValidPointView.isHidden =  true
        m_blackBGView.isHidden =  true
        
        
        m_btnQueryPointValidDate.layer.cornerRadius = 10;
        
        
        
        let giftArray  = m_dicData.object(forKey: "gift") as! NSArray
        for DataDic  in giftArray
        {
            let dicData  = DataDic as! NSDictionary            
            //wallet qty  Compare
            m_ListConsumeInfo.append(dicData)
            m_ListOrgConsumeInfo.append(dicData)
        }
        
        
        
        
        m_ValidPointView.layer.cornerRadius = 20
        m_ValidPointView.clipsToBounds = true
        
        
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
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetCanChangeEVoucherResult), name:NSNotification.Name(rawValue: kDCQueryCanChangeEVoucher), object: nil)
        
        
        DCUpdater.shared()?.queryCanChangeEVoucher(ConfigInfo.m_strAccessToken);
        
    }
    
    
    
    @objc func didGetCanChangeEVoucherResult(notification: NSNotification){
        
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            if(Int(strCode) == 0)
            {
                let dicData = dic.object(forKey: "Data") as! NSDictionary;
                
                PointGiftViewController.m_iAllPoint = dicData.object(forKey: "all_point") as! Int
                PointGiftViewController.m_iThisPoint = dicData.object(forKey: "this_point") as! Int
                PointGiftViewController.m_iNextPoint = dicData.object(forKey: "next_point") as! Int
                
                m_labelCurPoint.text  =  "\(PointGiftViewController.m_iAllPoint)";
                
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
        
        if(segue.identifier == "ValidPointView2")
        {
            let validPointViewController =  segue.destination as!  ValidPointViewController
            
            validPointViewController.m_pointCHPrizeListViewController = self            
        }
        
        
    }
   

    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    
    
    @IBAction func onSortClick(_ sender:UIButton)
    {
        
        let   latestNewPrizeButton = UIAlertAction(title: "最新好禮", style: .default, handler: { [unowned self] _ in
            
                    m_iSortType = 0
                    m_buttonSortType.setTitle("最新好禮V", for: .normal)
            
                    m_ListConsumeInfo.removeAll();
                    m_ListConsumeInfo.append(contentsOf: m_ListOrgConsumeInfo)
                    self.m_textTable.reloadData();
                })
        latestNewPrizeButton.setValue(m_iSortType == 0 ? true : false, forKey: "checked")
        
        let HighToLowButton = UIAlertAction(title: "點數高到低", style: .default, handler: { [unowned self] _ in
                    m_iSortType = 1
                    
                    m_buttonSortType.setTitle("點數高到低V", for: .normal)
            
                    Sort(isHighToLow: true)
                    self.m_textTable.reloadData();
                })
        
        
                //Here's the main magic; it's called Key-Value Coding, or KVC:
        HighToLowButton.setValue(m_iSortType == 1 ? true : false, forKey: "checked")

                let  LowToHighButton = UIAlertAction(title: "點數低到高", style: .default, handler: { [unowned self] _ in
                    
                    m_iSortType = 2
                    
                    m_buttonSortType.setTitle("點數低到高V", for: .normal)
                    
                    
                    Sort(isHighToLow: false)
                    
                    self.m_textTable.reloadData();
                    
                })
                
                LowToHighButton.setValue(m_iSortType == 2 ? true : false, forKey: "checked")
                let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)

                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
                alert.addAction(latestNewPrizeButton)
                alert.addAction(HighToLowButton)
                alert.addAction(LowToHighButton)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
        
    }
   
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:PointGiftTableViewCell!;
        let cell = PointGiftTableViewCell(style: .default, reuseIdentifier: "PointCHPrizeList")
        
        //let dicData  = DataDic as! NSDictionary
        let dicData  = m_ListConsumeInfo[indexPath.row];
        //let  strURL  = dicData.object(forKey: "img_url") as! String
//==============//
        let strURL = "\(ConfigInfo.IMAGES_SITE)/\((dicData.object(forKey:"img_url") as! String))"
        let url = URL(string: strURL)!
        //let url = URL(string: strURL);
        
        let data = try? Data(contentsOf: url) //make sure your image in this url does exist,
        if(data != nil)
        {
            let image = UIImage(data: data!)!
            
            cell.LoadDataOnlyImage(image: image)
            
        }
        
        Mycell = cell;
        
        return Mycell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        m_ListConsumeInfo.count;
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
     
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return  CGFloat(PointGiftTableViewCell.MainImageHeight);
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btPointCHPrizeContent
                   = StoryBoard.instantiateViewController(withIdentifier: "PointChangePrizeContent") as! PointCHPrizeContentViewController
        
        
        btPointCHPrizeContent.m_strScheduleID = m_dicData.object(forKey: "schedule_id") as! String;
        
        btPointCHPrizeContent.m_dicData  = m_ListConsumeInfo[indexPath.row];
        
        
        
        self.navigationController?.pushViewController(btPointCHPrizeContent, animated: true)
        
    }
    
    
    func Sort(isHighToLow:Bool)
    {
        if(isHighToLow)
        {
            m_ListConsumeInfo.sort { (dic1, dic2) -> Bool in
                
                let  qty1 = dic1.object(forKey: "wallet_qty") as! Int;
                let qty2 = dic2.object(forKey: "wallet_qty") as! Int;
                return qty1 >= qty2 ? true : false
            }
        }else
        {
            m_ListConsumeInfo.sort { (dic1, dic2) -> Bool in
                
                let  qty1 = dic1.object(forKey: "wallet_qty") as! Int;
                let qty2 = dic2.object(forKey: "wallet_qty") as! Int;
                return qty1 <= qty2 ? true : false
            }
        }
        
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
