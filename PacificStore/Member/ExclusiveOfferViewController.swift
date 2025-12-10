//
//  ExclusiveOfferViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/5/20.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class ExclusiveOfferViewController:BaseViewController,
UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var mTableview: UITableView!
    @IBOutlet weak var mlabelTitle: UILabel!
    @IBOutlet weak var mlabelSubTitle: UILabel!
    
    
    var  m_strID =  "0";
    var  m_strTitle =  "";
    var  m_strSubTitle =  "";
    var m_ListDetailInfo:[NSDictionary] =  [];
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text =  m_ListDetailInfo[indexPath.row].object(forKey: "Name") as! String;
        
        cell.textLabel?.textAlignment  = NSTextAlignment.center;
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0);
        
        
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btCuponMain
            = StoryBoard.instantiateViewController(withIdentifier: "ExcluseOfferDetail") as! ExclusiveOfferDetailViewController;
        
        btCuponMain.m_strWebPage   = m_ListDetailInfo[indexPath.row].object(forKey: "WebPage") as! String
        btCuponMain.m_strTitle  =   m_ListDetailInfo[indexPath.row].object(forKey: "Name") as! String
        btCuponMain.m_strID = m_ListDetailInfo[indexPath.row].object(forKey: "id") as! String
        
        let IsUsed  = m_ListDetailInfo[indexPath.row].object(forKey: "IsUsed") as! String
        
        btCuponMain.m_bAlreadyChange  = (IsUsed == "True") ? true : false;
        
        self.navigationController?.pushViewController(btCuponMain, animated: true)
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetBrandDetailResult), name:NSNotification.Name(rawValue: kDCGetExclusiveOffer), object: nil)
        
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getExclusiveOffer(ConfigInfo.m_strAccessToken);
        self.SetTitleColor();
        
        self.startTimeTick();
    }
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        RemoveTitleBar()
        
        //======================================================//
        self.stopTimeTick();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_EXCLUSIVE_OFFER), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
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
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
            mTableview.reloadData();            
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
}
