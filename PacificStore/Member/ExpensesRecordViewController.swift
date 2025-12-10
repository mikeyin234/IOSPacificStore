//
//  ExpensesRecordViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/6.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import UIKit

////////////////////////////////////////////////////////
//消費積點查詢
class ExpensesRecordViewController: BaseViewController , UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mlabelCurrentPoint: UILabel!
    
    var m_ListDetailInfo:[NSDictionary] =  [];
    
    
    @IBOutlet weak var mTableview: UITableView!
    let   TITLE_WIDTH:CGFloat  =  120.0;
    
    var    BUTTON_TYPE =  0;
    
    
    
    
    var   m_buttonObject:[UIButton] = [];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Mycell:ExpensesRecordTableViewCell!;
        
        let cell = ExpensesRecordTableViewCell(style: .default, reuseIdentifier: "ExpensesRecord")
        
        cell.LoadData(dictionary: m_ListDetailInfo[indexPath.row])
        
        Mycell = cell;
        
        return Mycell
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        
        
        DCUpdater.shared()?.getMemberPoints(ConfigInfo.m_strAccessToken)
        
        
        //mTableview.separatorColor = UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
          
          SetTitleColor()
          
          NotificationCenter.default.addObserver(self, selector:#selector(didGetNewsDetailResult), name:NSNotification.Name(rawValue: kDCExpensesRecord), object: nil)
          
          NotificationCenter.default.addObserver(self, selector:#selector(didMemberPointResult), name:NSNotification.Name(rawValue: kDCGetMemberPoints), object: nil)
        
          self.startTimeTick();
        
      }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        RemoveTitleBar()
        
        self.stopTimeTick();
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_CONSUMPTION), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
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
        
        return CGFloat(ExpensesRecordTableViewCell.MainHeight);
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
   
    
    
  
    
    
    
    @objc func didMemberPointResult(notification: NSNotification){
           
           //do stuff
           let userInfo = notification.userInfo as NSDictionary?;
           let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
           if(strSuccess.isEqual(to: "YES"))
           {
               let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
               let  strCode = dic.object(forKey: "ReturnCode") as! String;
               
               if(Int(strCode) == 0)
               {
                    let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                    let CurPoints  = DataDic.object(forKey: "CurPoints") as! String;
                    mlabelCurrentPoint.text = CurPoints;
                    
                    
                    DCUpdater.shared()?.queryExpensesRecord(withAccessToken: ConfigInfo.m_strAccessToken);
                
               } else if(Int(strCode) == -35)
               {
                    mlabelCurrentPoint.text  = "0"
                
                    DCUpdater.shared()?.queryExpensesRecord(withAccessToken: ConfigInfo.m_strAccessToken);
               }
               else
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
    
   
    
    
    
    
    
    @objc func didGetNewsDetailResult(notification: NSNotification){
        
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
    
    
    
}
