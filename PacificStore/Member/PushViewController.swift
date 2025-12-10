//
//  PushViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/4/2.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class PushViewController: BaseViewController , UITableViewDelegate,UITableViewDataSource {
    
    var m_ListDetailInfo:[NSDictionary] =  [];
    @IBOutlet weak var mTableview: UITableView!
    
    
    let   TITLE_WIDTH:CGFloat  =  120.0;
    var   BUTTON_TYPE =  0;
    var   m_iSelectIndex = 0 ;
    var   m_buttonObject:[UIButton] = [];
    var   m_bNeedReload = false;
    var   m_iSubtitleWidth = 300.0;
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //m_ListDetailInfo
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero        
        let lblTitle : UILabel = cell.contentView.viewWithTag(100) as! UILabel
        let lblSubTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        
        let lblDate : UILabel = cell.contentView.viewWithTag(103) as! UILabel
        
        lblTitle.text =  (m_ListDetailInfo[indexPath.row].object(forKey:"MsgTitle") as! String)
        lblSubTitle.text = (m_ListDetailInfo[indexPath.row].object(forKey:"PushMessage")as! String)
        m_iSubtitleWidth = Double(lblSubTitle.bounds.size.width);
        lblSubTitle.sizeToFit();
        lblDate.text = (m_ListDetailInfo[indexPath.row].object(forKey:"Date")as! String)
        
        if(cell.contentView.viewWithTag(102) != nil)
        {
            let ButtonDelete = cell.contentView.viewWithTag(102) as! UIButton
            ButtonDelete.titleLabel?.text = "\(indexPath.row)";
            
            //ButtonDelete.center.y = ((lblSubTitle.bounds.height + 70) - ButtonDelete.bounds.height ) / 2
            //ButtonDelete.tag = indexPath.row;
            
            ButtonDelete.addTarget(self, action: #selector(pressedAction(_:)), for: .touchUpInside)
        }else
        {
            
        }
        
        return cell
        
    }
    
    
    
    @objc func pressedAction(_ sender: UIButton) {
        // do your stuff here
        print("you clicked on button \(sender.tag)")
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        m_iSelectIndex = Int(sender.titleLabel!.text!)!;
        let id =  (m_ListDetailInfo[m_iSelectIndex].object(forKey:"id") as! String)
        DCUpdater.shared()?.deletePushMessage(ConfigInfo.m_strAccessToken, andID: id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        
        
        if(ConfigInfo.m_bIsClickPush)
        {
            ConfigInfo.m_bIsClickPush  = false;
            DCUpdater.shared()?.getPushMessageExt(ConfigInfo.m_strAccessToken, andDataTime: ConfigInfo.m_strSendTime);
        }else
        {
            DCUpdater.shared()?.getPushMessage(ConfigInfo.m_strAccessToken);
        }
        
        
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
        
//======================================================//
        self.stopTimeTick();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_MESSAGE), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
    }
    
    func tableView(_ tableView: UITableView,
                      heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let m_labelText = UILabel();
        
         m_labelText.frame = CGRect(x: 0, y: 0, width: m_iSubtitleWidth, height: 20);
        
        let strPushMessage  = (m_ListDetailInfo[indexPath.row].object(forKey:"PushMessage")as! String)
        m_labelText.numberOfLines = 0;
        
        m_labelText.lineBreakMode = .byWordWrapping;
        m_labelText.font = UIFont.systemFont(ofSize: 18);
        m_labelText.text = strPushMessage;
        
        m_labelText.sizeToFit();
        let height = m_labelText.bounds.size.height;
        
        return 70 + height;//UITableView.automaticDimension;
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let strMsgTitle = m_ListDetailInfo[indexPath.row].object(forKey: "MsgTitle");
        let strPushMessage = m_ListDetailInfo[indexPath.row].object(forKey: "PushMessage");
        let strWebPage = m_ListDetailInfo[indexPath.row].object(forKey: "WebPage");
        let strID = m_ListDetailInfo[indexPath.row].object(forKey: "id");
        
        
        let strType = m_ListDetailInfo[indexPath.row].object(forKey: "Type") as! String;
        let strFBVideoPath = m_ListDetailInfo[indexPath.row].object(forKey: "FBVideoPath") as! String;
        
        if(strType == "1")    
        {
            UIApplication.shared.open(URL(string: strFBVideoPath)!, options:[:],completionHandler: nil);
        }else
        {
            //PushDetail
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            
            let  btPushDetailView
                = StoryBoard.instantiateViewController(withIdentifier: "PushDetail") as!  PushDetailViewController;
            
            btPushDetailView.m_strTitle  =  strMsgTitle as! String;
            btPushDetailView.m_strContent =  strPushMessage as! String;
            
            btPushDetailView.m_strWebPage  = strWebPage as! String;
            btPushDetailView.m_strID  = strID as! String;
            
            btPushDetailView.m_strDate  = m_ListDetailInfo[indexPath.row].object(forKey: "Date") as! String;
            
            self.navigationController?.pushViewController(btPushDetailView, animated: true)
        }
        
       
        
    }
    
    
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        SetTitleColor()
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetNewsDetailResult), name:NSNotification.Name(rawValue: kDCGetPushMessage), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didDeleteMsgResult), name:NSNotification.Name(rawValue: kDCDeleteMessage), object: nil)
        
        
         NotificationCenter.default.addObserver(self, selector:#selector(didGetPushMsgResult), name:NSNotification.Name(rawValue: kDCGetPushMessageDateTime), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didAllDeleteMsgResult), name:NSNotification.Name(rawValue: kDCDeleteAllPush), object: nil)
        
        
        if(m_bNeedReload)
        {
            DCUpdater.shared()?.getPushMessage(ConfigInfo.m_strAccessToken);
            
            m_bNeedReload =  false;
        }
        
        self.startTimeTick();
        
    }
    
   
    
    
    
    @objc func didDeleteMsgResult(notification: NSNotification){
        
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
                m_ListDetailInfo.remove(at: m_iSelectIndex);
                
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
            
        DCUpdater.shared()?.updateReadMessage(ConfigInfo.m_strAccessToken);
            
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    @objc func didGetPushMsgResult(notification: NSNotification){
        
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
                    
                    let strMsgTitle = dicData.object(forKey: "MsgTitle");
                    let strPushMessage = dicData.object(forKey: "PushMessage");
                    let strWebPage = dicData.object(forKey: "WebPage");
                    let strID = dicData.object(forKey: "id");
                    m_bNeedReload = true;
                    
                    
                    let strType = dicData.object(forKey: "Type") as! String;
                    let strFBVideoPath = dicData.object(forKey: "FBVideoPath") as! String;
                    
                    if(strType == "1")
                    {
                        UIApplication.shared.open(URL(string: strFBVideoPath)!, options:[:],completionHandler: nil);
                    }else
                    {
                        //PushDetail
                        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                    
                        let  btPushDetailView
                            = StoryBoard.instantiateViewController(withIdentifier: "PushDetail") as!  PushDetailViewController;
                    
                         btPushDetailView.m_strTitle  =  strMsgTitle as! String;
                         btPushDetailView.m_strContent =  strPushMessage as! String;
                         btPushDetailView.m_strWebPage  = strWebPage as! String;
                         btPushDetailView.m_strID  = strID as! String;
                         btPushDetailView.m_strDate  = dicData.object(forKey: "Date") as! String;
                         self.navigationController?.pushViewController(btPushDetailView, animated: true)
                    }
                    break;
                }
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
            
            DCUpdater.shared()?.updateReadMessage(ConfigInfo.m_strAccessToken);
            
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    @IBAction func onDeleteAllMessageClick(_ sender:UIButton)
    {
        let alert = UIAlertController(title: "訊息刪除確認", message: "請確認是否刪除全部訊息", preferredStyle: .alert)
        
        //kDCDeleteAllPush
        alert.addAction(UIAlertAction(title: "是", style: .default, handler: { UIAlertAction in
            
             MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
             
             DCUpdater.shared()?.deleteAllPushMessage(ConfigInfo.m_strAccessToken)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "否", style: .default, handler: nil))
        
        
        self.present(alert, animated: true)
        
    }
    
    
    @objc func didAllDeleteMsgResult(notification: NSNotification){
        
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
                self.navigationController?.popViewController(animated: true);
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
