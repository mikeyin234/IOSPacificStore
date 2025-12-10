//
//  QueryPointViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/3.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

/////////////////////////////////////////////
//消費積點記錄查詢
class QueryPointViewController: BaseViewController,
                                UITableViewDelegate,UITableViewDataSource{
                    
    
    @IBOutlet var m_labelName : UILabel!
    @IBOutlet var m_labelCardType : UILabel!
    
    @IBOutlet var m_labelCurPoint : UILabel!
    
    
    //@IBOutlet var m_labelExpirationThisYear : UILabel!
    //@IBOutlet var m_labelExpirationNextYear : UILabel!
//=====================================================
    //@IBOutlet var m_labelLimitThisYear : UILabel!
    //@IBOutlet var m_labelLimitNextYear : UILabel!
    
    
    
//======================================================//
    @IBOutlet var m_SegChangeControl : UISegmentedControl!
//======================================================//
    @IBOutlet weak var m_textQueryDate:UITextField!
    @IBOutlet weak var m_textTable:UITableView!
    let   m_pickerView  = UIPickerView();
    
//===================================================
    var m_ListConsumeInfo:[NSDictionary] =  [];
    
    var m_ListCollectInfo:[NSDictionary] =  [];
    
//================================
    var m_iType = 0;  //0 = 消費 1 = 收
    var m_iCurrentSelect = 0;
    var  m_strStartDate = "" , m_strEndDate = "";
    var m_iMaxSelect =  1;
    
//===================================================//
    @IBOutlet var m_btnQueryPointValidDate : UIButton!
    @IBOutlet var m_ValidPointView : UIView!
    @IBOutlet var m_blackBGView : UIView!
    
    
    var  m_validPointViewController:ValidPointViewController!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
         return 3;
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_ValidPointView.isHidden =  true
        m_blackBGView.isHidden =  true
        /////////////////////////////////////////////////////////////////////////
        //Segmented Control  background color and textcolor......
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white as Any], for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red as Any], for: .normal)
        
        
        m_btnQueryPointValidDate.layer.cornerRadius = 10;
        
        m_ValidPointView.layer.cornerRadius = 20
        m_ValidPointView.clipsToBounds = true
        
        
        //  addSelectDatePick();
        m_textQueryDate?.text = funcGetCur(iMonth: 0);
        //ConfigInfo.m_strCardNumber =  "0000000018";
        
        //self.QueryData();
        
        
        let calendar = Calendar.current
        let yearThis = calendar.component(.year, from: Date())
        let resultDate =  calendar.date(byAdding: .year, value: 1, to: Date())
      
        
//===========================================================//
        let  month = calendar.component(.month, from: Date())
        if(yearThis == 2021 && (month == 7 || month == 8))
        {
            m_iMaxSelect  =  0;
        }else if(yearThis == 2021 && (month == 9 || month == 10))
        {
            m_iMaxSelect =  1;
        }else
        {
            m_iMaxSelect =  2;
        }
    }
    
    
    //0   1   2
    func  funcGetCur(iMonth:Int)->String
    {
        
        let calendar = Calendar.current
        let resultDate =  calendar.date(byAdding: .month, value: -iMonth, to: Date())
        
        let year = calendar.component(.year, from: resultDate!)
        var month = calendar.component(.month, from: resultDate!)
        
        if(month % 2 == 0)
        {
            month = month - 1;
        }
        
        return "\(year)年\(month)月~\(month+1)月";
        
    }
    
    
    func  funcGetCurString(iMonth:Int)->(String, String)
    {
        
        let calendar = Calendar.current
        let resultDate =  calendar.date(byAdding: .month, value: -iMonth, to: Date())
        
        let year = calendar.component(.year, from: resultDate!)
        var month = calendar.component(.month, from: resultDate!)
        
        if(month % 2 == 0)
        {
            month = month - 1;
        }
        
        
        
        return ("\(year)-\( String(format:"%02d" , month))-01" , "\(year)-\(String(format:"%02d" , month+1))-31");
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //2021年01月~02月
        //2020年11月~12月
        //2020年09月~10月
        
        let pickerLabel = UILabel()
        pickerLabel.text = funcGetCur(iMonth: row * 2)
        pickerLabel.font = UIFont.systemFont(ofSize: 25);
        pickerLabel.textAlignment = NSTextAlignment.center
        
        return pickerLabel
    }
    
    
    
    
    func  addSelectDatePick()
    {
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        m_textQueryDate.inputView = m_pickerView
        m_textQueryDate.tag = 201
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(doneSelectDateButton))
        toolBar.tintColor = UIColor.blue
        
        m_textQueryDate.inputAccessoryView = toolBar
        
    }
    
//=========================================================================================//
    @objc func doneSelectDateButton()
    {
        let iRow = m_pickerView.selectedRow(inComponent: 0)
        
        m_textQueryDate?.text = funcGetCur(iMonth: iRow * 2)
        
        m_textQueryDate.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    
    
    
    func SetCardType()
    {            
        m_labelCardType.text  = ConfigInfo.CardType[ConfigInfo.m_iCardType-1];
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didMemberPointResult), name:NSNotification.Name(rawValue: kDCGetMemberPoints), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryTradeRecord), name:NSNotification.Name(rawValue: kDCQueryTradeRecord), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryMemberTradePoint), name:NSNotification.Name(rawValue: kDCQueryMemberTradePoint), object: nil)
        
        self.SetTitleColor();
        
        super.viewWillAppear(animated)
        
//==================================================//
        self.startTimeTick();
        
//========2022  02   10=============================//
        self.QueryData();
        
        
    }
    
    
    ///////////////////
    ///消費記錄
    @objc func didQueryTradeRecord(notification: NSNotification)
    {
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
                        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        
        if(strSuccess.isEqual(to: "YES"))
        {
            
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            
            let dicData =  dic.object(forKey: "Data") as! NSDictionary;
            m_labelCurPoint.text = "\((dicData.object(forKey: "all_point") as! Int64))";
            
            
            //m_labelExpirationThisYear.text  = "\((dicData.object(forKey: "this_point") as! Int64))";
            //m_labelExpirationNextYear.text  = "\((dicData.object(forKey: "next_point") as! Int64))";
            
            
            let transArray  = dicData.object(forKey: "trans") as! NSArray
            m_ListConsumeInfo.removeAll();
            
            for DataDic  in transArray
            {
                let dicData  = DataDic as! NSDictionary
                m_ListConsumeInfo.append(dicData)
            }
            
            m_textTable.reloadData();
            
        }
    }
    
    
    ///////////////////
    ///積點記錄
    @objc func didQueryMemberTradePoint(notification: NSNotification)
    {
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
                let dicData =  dic.object(forKey: "Data") as! NSDictionary;
                let transArray  = dicData.object(forKey: "trans") as! NSArray
                
                m_ListCollectInfo.removeAll();
                for DataDic  in transArray
                {
                    let dicData  = DataDic as! NSDictionary
                    self.m_ListCollectInfo.append(dicData)
                }
                
                self.m_textTable.reloadData();
                
            }
        }
        
    }
    
    
    @objc func didMemberPointResult(notification: NSNotification){
        
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
                
            } else if(Int(strCode) == -35)
            {
                //m_labelPointLimitInto.text = "查無帳號點數資訊";
            }
            else
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
        
        self.stopTimeTick();
        
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_POINT_QUERY), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
    }
    
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "ValidPointView")
        {
            m_validPointViewController =  segue.destination as!  ValidPointViewController
            
            m_validPointViewController.m_queryPointViewController = self
            
        }
        
        
        
        
    }
    

    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func segmentedControlValueChanged(segment: UISegmentedControl) {
                        
        QueryData();
        
        //m_textTable.reloadData();
    }
    
    
    func QueryData()
    {
        
        let resultDateCur = funcGetCurString(iMonth: m_iCurrentSelect * 2)
        
        if m_SegChangeControl.selectedSegmentIndex == 0 {
            
            m_iType = 0
            
            MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
            
            DCUpdater.shared()?.queryTradeRecord(ConfigInfo.m_strAccessToken, andCardNbr: ConfigInfo.m_strCardNumber, andRRN: "", andTransDateStart: resultDateCur.0, andTransDateEnd: resultDateCur.1, andTransType: "708070",
                                                 andTransTypeList: "")
            
        }else
        {
            m_iType = 1
            
            
            MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
            
            DCUpdater.shared()?.queryMemberTradePoint(ConfigInfo.m_strAccessToken, andTransDateStart: resultDateCur.0, andTransDateEnd: resultDateCur.1)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE6/255, alpha: 1)
        
        if(m_iType == 0 )
        {
            var Mycell:ConsumptionRecordTableViewCell!;
            
            let cell = ConsumptionRecordTableViewCell(style: .default, reuseIdentifier: "ConsumeRecord")
            
            cell.LoadData(dictionary: m_ListConsumeInfo[indexPath.row])
            
            cell.selectedBackgroundView = bgColorView
            
            Mycell = cell;
            
            return Mycell
            
        }else
        {
            var Mycell:CollectPointTableViewCell!;
            
            let cell = CollectPointTableViewCell(style: .default, reuseIdentifier: "PointRecord")
            
            cell.LoadData(dictionary: m_ListCollectInfo[indexPath.row])
            
            cell.selectedBackgroundView = bgColorView
            
            
            Mycell = cell;
            
            return Mycell
        }
    
       
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(m_iType == 0)
        {
            return m_ListConsumeInfo.count;
        }
        
        return m_ListCollectInfo.count;
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return  1
        
    }
    
     
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return m_iType == 0 ? CGFloat(ConsumptionRecordTableViewCell.MainHeight) :
                CGFloat(CollectPointTableViewCell.MainHeight);
    }
    
    
    @IBAction func onBackMonthClick(_ sender:UIButton)
    {
        m_iCurrentSelect += 1;
        if(m_iCurrentSelect > m_iMaxSelect)
        {
            m_iCurrentSelect = m_iMaxSelect;
        }
        
        m_textQueryDate.text =  funcGetCur(iMonth: m_iCurrentSelect * 2)
        
        QueryData();
        
    }
    
    
    @IBAction func onNextMonthClick(_ sender:UIButton)
    {
        m_iCurrentSelect -= 1;
        if(m_iCurrentSelect < 0)
        {
            m_iCurrentSelect = 0;
        }
        
        m_textQueryDate.text =  funcGetCur(iMonth: m_iCurrentSelect * 2)
        
        QueryData();
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if(m_iType  ==  0)
        {
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            
            let  btConsumptionRecViewController
                       = StoryBoard.instantiateViewController(withIdentifier: "ConsumptionRecord") as! ConsumptionRecordViewController
            
            btConsumptionRecViewController.m_dicInfo  = m_ListConsumeInfo[indexPath.row];
                
            self.navigationController?.pushViewController(btConsumptionRecViewController, animated: true)
        }
    }
    
    
    @IBAction func onQueryValidPoint(_ sender:UIButton)
    {
        
        m_validPointViewController.m_textTable.reloadData()
        
        m_ValidPointView.isHidden =  false
        m_blackBGView.isHidden =  false
        
        
    }
    
    @IBAction func HideQueryValidPoint()
    {
        m_ValidPointView.isHidden =  true
        m_blackBGView.isHidden =  true
        
        
    }
    
    
    
}
