//
//  LotteryListViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/3/12.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class LotteryListViewController: BaseViewController ,
                                 UITableViewDelegate,UITableViewDataSource{

//============================================
var m_iType  = 0;

var m_ListLoteryHistory:[NSDictionary] =  [];
var m_ListLoteryNo:[NSDictionary] =  [];
    
    
@IBOutlet var m_btnVoucher : UIButton!
@IBOutlet var m_btnECeremony : UIButton!
@IBOutlet weak var m_textTable:UITableView!
    
var   m_dataDirectory:NSDictionary!
@IBOutlet var m_labelWalletName : UILabel!
@IBOutlet var m_labelPoint : UILabel!
@IBOutlet var m_labelLimitDate : UILabel!


//=================================================//
var  m_strTitle = "";
@IBOutlet var m_labelTitle : UILabel!
var  m_strWalletID  =  "";
    
//================================================//
var  m_strTitleRecord = "";
@IBOutlet var m_labelTitleRecord : UILabel!
    
//================================================//
@IBOutlet var m_btnHistory : UIButton!
@IBOutlet var m_btnNumber : UIButton!
    
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(m_iType == 0)
    {
        return m_ListLoteryHistory.count;
    }else
    {
        return m_ListLoteryNo.count;
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var Mycell:ElectronVoucherTableViewCell!;
    
    if(m_iType  == 0)
    {
        let cell = ElectronVoucherTableViewCell(style: .default, reuseIdentifier: "LotteryHistory")
        cell.LoaQLotterydData(dictionary: m_ListLoteryHistory[indexPath.row] ,strUnit: "張")
        Mycell = cell;
    }else
    {
        let cell = ElectronVoucherTableViewCell(style: .default, reuseIdentifier: "LotteryNumber")
        
        cell.LoaLotteryNumberdData(dictionary: m_ListLoteryNo[indexPath.row])
        
        Mycell = cell;
    }
   
    return Mycell
        
}

   


override func viewDidLoad() {
  super.viewDidLoad()

  m_labelTitle.text  = m_strTitle;
  
  let strWalletName = m_dataDirectory.object(forKey: "wallet_name") as! String;
  let strPoint  = (m_dataDirectory.object(forKey: "wallet_amt") as! Int);
        
  let   dateStart =  (m_dataDirectory.object(forKey: "exp_date_start") as! String);
  let dateEnd  =  (m_dataDirectory.object(forKey: "exp_date_end") as! String);
                 


  let strRemark = m_dataDirectory.object(forKey: "remark") as! String;


  m_labelLimitDate.text  = "\(strRemark)\n使用期限：\( ConfigInfo.FormatDateStirng(strDate: dateStart))-\( ConfigInfo.FormatDateStirng(strDate: dateEnd))";

  m_labelWalletName.text  = strWalletName;
  m_labelPoint.text  = "\(strPoint)";
  m_strWalletID =  m_dataDirectory.object(forKey: "wallet_id") as! String;
  
  
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = Date()
    let dateString = dateFormatter.string(from: date)
    
    let strDateStart = ConfigInfo.funcDateAddMonth(iMonth: 6);
    
    MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
    DCUpdater.shared()?.queryPointTrade(ConfigInfo.m_strAccessToken,
                                    andTransDateStart: strDateStart, andTransDateEnd: dateString, andWalletId: m_strWalletID)
    
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
    
    NotificationCenter.default.addObserver(self, selector:#selector(didQueryPointsTradeResult), name:NSNotification.Name(rawValue: kDCQueryPointTrade), object: nil)
    
    super.viewWillAppear(animated)
}



@objc func didQueryPointsTradeResult(notification: NSNotification){
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
            
            
            let dataArray  = dicData.object(forKey: "trans") as! NSArray
            for DataDicCur  in dataArray
            {
                let DataDicCur  = DataDicCur as! NSDictionary
                m_ListLoteryHistory.append(DataDicCur);
            }
            
            let dataTicketArray  = dicData.object(forKey: "ticket_list") as! NSArray
            for dataCurTicket  in dataTicketArray
            {
                let dataDicCurTicket  = dataCurTicket as! NSDictionary
                m_ListLoteryNo.append(dataDicCurTicket);
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
    
        return  CGFloat(ElectronVoucherTableViewCell.MainHeight);
}



func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
}
    
   @IBAction func onHelpClick(_ sender:UIButton)
   {
       let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
       
       let  btElectronicVolume
               = StoryBoard.instantiateViewController(withIdentifier: "ElectronicVolume") as! EVolumeContentViewController
    
       btElectronicVolume.m_dataDirectory  = m_dataDirectory;
       btElectronicVolume.m_strTitle  =  m_strTitle
    
       self.navigationController?.pushViewController(btElectronicVolume, animated: true)
    
    }

    
    @IBAction func onLoteryHistoryClick(_ sender:UIButton)
    {
        m_iType =  0;
        self.m_textTable.reloadData();
        
        m_btnHistory.setTitleColor(.white, for: .normal)
        m_btnNumber.setTitleColor(.black, for: .normal)
        
    }
    
    @IBAction func onLoteryNumberClick(_ sender:UIButton)
    {
        m_iType =  1;
        self.m_textTable.reloadData();
        
        m_btnHistory.setTitleColor(.black, for: .normal)
        m_btnNumber.setTitleColor(.white, for: .normal)
        
    }
    
    
    

}
