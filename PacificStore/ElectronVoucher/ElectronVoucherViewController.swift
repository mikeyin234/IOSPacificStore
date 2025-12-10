//
//  ElectronVoucherViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/1/22.
//  Copyright © 2021 greatsoft. All rights reserved.
//////////////////////////////////////////////////////////////////////////////
import UIKit
//////////////////////////////////////////////////////////////////////////////
//我的電子贈卷
class ElectronVoucherViewController: BaseViewController ,
                                     UITableViewDelegate,UITableViewDataSource{
    
    
//============================================
    var m_iType  = 1;
    var m_ListConsumeInfo:[NSDictionary] =  [];
    var m_ListCollectInfo:[NSDictionary] =  [];
    
    
    @IBOutlet var m_btnVoucher : UIButton!
    @IBOutlet var m_btnECeremony : UIButton!
    
    @IBOutlet weak var m_textTable:UITableView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(m_iType == 0)   //電子抵用券
        {
            return  m_ListConsumeInfo.count;
        }else
        {
            return  m_ListCollectInfo.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(m_iType == 0 )
        {
            var Mycell:ElectronVoucherTableViewCell!;
            
            let cell = ElectronVoucherTableViewCell(style: .default, reuseIdentifier: "ElectronVoucher")
            
            cell.LoadData(dictionary: m_ListConsumeInfo[indexPath.row], strUnit: "元")
            
            
            Mycell = cell;
            return Mycell
            
        }else
        {
            var Mycell:ElectronCeremonyTableViewCell!;
            
            let cell = ElectronCeremonyTableViewCell(style: .default, reuseIdentifier: "ElectronCeremony")
            
            cell.LoadData(dictionary: m_ListCollectInfo[indexPath.row], strUnit: "元")
            
            Mycell = cell;
            
            return Mycell
        }
        
    }
    

   
   
    
   override func viewDidLoad() {
       super.viewDidLoad()
       
       if(m_iType == 0)
       {
           m_btnVoucher.setTitleColor(UIColor.white, for: .normal)
           m_btnECeremony.setTitleColor(UIColor.black, for: .normal)
       }else
       {
           /// 4 -  16 add
          m_btnVoucher.setTitleColor(UIColor.black, for: .normal)
          m_btnECeremony.setTitleColor(UIColor.white, for: .normal)
       }
       
       
      MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
    
      DCUpdater.shared()?.queryPointsBalance(ConfigInfo
                                          .m_strAccessToken, andWalletType: "L,C");
    
    
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
                        if(strType == "C")   //電子抵用券
                        {
                            m_ListConsumeInfo.append(DataDicCur)
                        }else  if(strType == "L") //電子禮券
                        {
                            m_ListCollectInfo.append(DataDicCur)
                        }
                    }
                    
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
    
    RemoveTitleBar()
    
}

    
  @objc func didQueryEVoucher(notification: NSNotification)
  {
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
                        
        if(strSuccess.isEqual(to: "YES"))
        {
            
        }
    
  }
    
    

  //電子抵用卷
  @IBAction func onEVoucherClick(_ sender:UIButton)
  {
      m_btnVoucher.setTitleColor(UIColor.white, for: .normal)
      m_btnECeremony.setTitleColor(UIColor.black, for: .normal)
      m_iType  = 0;
      self.m_textTable.reloadData();
  }
  
  ////////////////////////////////////////////////////////////////
  //電子禮卷
  @IBAction func onECeremonyClick(_ sender:UIButton)
  {
     m_btnVoucher.setTitleColor(UIColor.black, for: .normal)
     m_btnECeremony.setTitleColor(UIColor.white, for: .normal)
     m_iType  = 1;
    
     self.m_textTable.reloadData();
    
  }
  
    
  func numberOfSections(in tableView: UITableView) -> Int {
        1    
  }
    
    
  func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return m_iType == 0 ? CGFloat(ElectronVoucherTableViewCell.MainHeight) :
                CGFloat( ElectronCeremonyTableViewCell.MainHeight);
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
//=====================================
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btSubNavBrandMain
                   = StoryBoard.instantiateViewController(withIdentifier: "ElectronVoucherList") as!   ElectronVoucherListViewController
        
        btSubNavBrandMain.m_iType  = m_iType;
        if(m_iType == 0)
        {
            btSubNavBrandMain.m_dataDirectory = m_ListConsumeInfo[indexPath.row]
            
            btSubNavBrandMain.m_strTitle  = "電子抵用券";
        }else
        {
            btSubNavBrandMain.m_strTitle  = "電子禮券";

            
            btSubNavBrandMain.m_dataDirectory = m_ListCollectInfo[indexPath.row]
        }
        
        
        self.navigationController?.pushViewController(btSubNavBrandMain, animated: true)
        
        
    }
    
    
    
    
}
