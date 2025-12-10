//
//  ValidPointViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2023/5/28.
//  Copyright © 2023 greatsoft. All rights reserved.
////////////////////////////////////////////////////////
import UIKit

class ValidPointViewController: BaseViewController ,
                                UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var m_textTable:UITableView!
    @IBOutlet weak var m_labelTotalPoint:UILabel!
    
    var  m_queryPointViewController:QueryPointViewController!
    var  m_pointCHPrizeListViewController:PointCHPrizeListViewController!;
    
    var  m_pointCHPrizeContentViewController:PointCHPrizeContentViewController!
    
    
    var m_ListPointInfo:[NSDictionary] =  []
    var m_iTotalPoint:Int64 = 0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               
        return  m_ListPointInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:ComsumerPointTableViewCell!;
        
        let cell = ComsumerPointTableViewCell(style: .default, reuseIdentifier: "ComsumerPoint")
        
        cell.LoadData(dictionary: m_ListPointInfo[indexPath.row],frameTable: m_textTable.frame)
        
        
        Mycell = cell;
        
        return Mycell
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DCUpdater.shared()?.queryPointsBalance(ConfigInfo
                                             .m_strAccessToken, andWalletType: "0");
        
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        self.SetTitleColor();
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryPointsBalanceResult), name:NSNotification.Name(rawValue: kDCQueryPointsBalance), object: nil)
        
        
        super.viewWillAppear(animated)
    }


        
        @objc func didQueryPointsBalanceResult(notification: NSNotification){
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
                    let dicData  = dic.object(forKey: "Data") as! NSDictionary
                    let dataArray  = dicData.object(forKey: "wallet") as! NSArray
                    
                    for DataDicCur  in dataArray
                    {
                        let DataDicCur  = DataDicCur as! NSDictionary
                        
                        let strType  = DataDicCur.object(forKey: "wallet_type") as! String
                        if(strType == "0")   //電子抵用券
                        {
                            let wallet_qty = DataDicCur.object(forKey: "wallet_qty") as! Int64
                            
                            m_iTotalPoint += wallet_qty;
                            
                            m_ListPointInfo.append(DataDicCur)
                        }
                    }
                    
                    m_labelTotalPoint.text = "\(m_iTotalPoint)"
                    self.m_textTable.reloadData();
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
        
        NotificationCenter.default.removeObserver(self);
        
    }
    
    
    @IBAction func onClose(_ sender:UIButton)
    {
        if(m_queryPointViewController != nil)
        {
            m_queryPointViewController.HideQueryValidPoint()
        }
        
        if(m_pointCHPrizeListViewController != nil)
        {
            m_pointCHPrizeListViewController.HideQueryValidPoint()
        }
        
        
        if(m_pointCHPrizeContentViewController != nil)
        {
            m_pointCHPrizeContentViewController.HideQueryValidPoint()
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

}
