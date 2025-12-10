//
//  ModifyMemberViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/3.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit






class ModifyMemberViewController: BaseViewController,UITextFieldDelegate,
                                  UIPickerViewDelegate,UIPickerViewDataSource,
                                  UIScrollViewDelegate
{

    @IBOutlet weak var m_textAccount:UITextField!
    @IBOutlet weak var m_textMobile:UITextField!
    
    @IBOutlet weak var m_textName:UITextField!
    @IBOutlet weak var m_textSex:UITextField!
    @IBOutlet weak var m_textBirthday:UITextField!
    
    
    //@IBOutlet weak var m_textZipCode:UITextField!
    @IBOutlet weak var m_textAddress:UITextField!
    
    @IBOutlet weak var m_textCity:UITextField!
    @IBOutlet weak var m_textArea:UITextField!
    
    
    @IBOutlet var m_labelName : UILabel!
    @IBOutlet var m_labelCardType : UILabel!
    @IBOutlet weak var m_uiCurrentTextField: UITextField!
    
    
    
    var  m_strZipCode = "";
    var  m_CitysArray  = Array<String>();
    var  m_AreasArray  = Array<NSDictionary>();
    
    
    let   m_pickerCityView  = UIPickerView();
    let   m_pickerAreaView  = UIPickerView();
    
    
    //========================================================//
    @IBOutlet weak var m_lablePersonalData: UILabel!
    @IBOutlet weak var m_btnCheckPolicy:UIButton!
    
    
    static  var  m_strPolicySite  = "";
    
    @IBOutlet var m_uiPersonalDataPolicyView : UIView!
    @IBOutlet var m_uiPersonalDataPolicyViewBG : UIView!
    var  m_personalDataViewController:PersonalDataViewController!
    
    
    
    @IBOutlet weak var m_btnOK:UIButton!
    var m_bIsCheckPolicy = false;
    
    
    @IBOutlet var m_uiContentScrollView : UIScrollView!
    
   
    @IBOutlet var m_uiContentView : UIView!
    
  
    override func viewDidLayoutSubviews() {
        
        let iHeight = m_btnOK.frame.origin.y +  m_btnOK.frame.size.height + 20;
        
        
        self.m_uiContentScrollView.contentSize = CGSize(width: Int(self.m_uiContentView.frame.size.width-10), height: Int(iHeight));
        
        self.m_uiContentView.frame.size =  CGSize(width: Int(self.m_uiContentView.frame.size.width), height: Int(iHeight));
    }
    
    
    
    func SetTextLinkable()
    {
        let attributedString = NSMutableAttributedString(string:"本人同意個人資料使用條款")
        
        let linkWasSet = attributedString.setAsLink(textToFind: "個人資料使用條款", linkURL: "https://stackoverflow.com")
        
        m_lablePersonalData.attributedText = attributedString;
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ModifyMemberViewController.tapFunction))
        
        m_lablePersonalData.isUserInteractionEnabled = true
        m_lablePersonalData.addGestureRecognizer(tap)
        
    }
    
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        
        print("tap working")
        let targetRange = (m_lablePersonalData.text! as NSString).range(of: "個人資料使用條款")
        if sender.didTapAttributedTextInLabel(label: m_lablePersonalData, inRange: targetRange ) {
            
            print("Tapped targetRange1")
            
            m_uiPersonalDataPolicyView.isHidden = false
            m_uiPersonalDataPolicyViewBG.isHidden = false
            
            
            m_personalDataViewController.LoadPage()
            
        }
        else
        {
            print("Tapped none")
        }
        
    }
    
    
    
    
    @IBAction func onCheckClick(_ sender:UIButton)
    {
        m_bIsCheckPolicy = !m_bIsCheckPolicy;
        
        let image = m_bIsCheckPolicy ? UIImage(named:"check") : UIImage(named:"uncheck")
        
        m_btnOK.isEnabled = m_bIsCheckPolicy
        
        
        m_btnOK.backgroundColor = m_bIsCheckPolicy ? UIColor(red: 216.0/255, green: 0, blue: 39.0/255.0, alpha: 1) : UIColor.gray
        
        m_btnCheckPolicy.setBackgroundImage(image! , for: UIControl.State.normal)
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView == m_pickerCityView)
        {
            return m_CitysArray.count;
        }else
        {
            return m_AreasArray.count;
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let pickerLabel = UILabel()
        
        if(pickerView == m_pickerCityView)
        {
            pickerLabel.text = m_CitysArray[row];
        }else
        {
            pickerLabel.text = m_AreasArray[row].object(forKey: "district") as? String;
        }
                           
        pickerLabel.font = UIFont.systemFont(ofSize: 25);
        pickerLabel.textAlignment = NSTextAlignment.center
        
        return pickerLabel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        m_labelName.text =  ConfigInfo.m_strName;
        SetCardType();
        m_textAccount.text = ConfigInfo.m_strUserID;
        
        
      
        
        
        m_textMobile.text =  ConfigInfo.m_strPhone;
        m_textName.text   = ConfigInfo.m_strName;
        m_textSex.text  = ConfigInfo.m_strSex;
        m_textBirthday.text  = ConfigInfo.m_strBirthday;
        m_strZipCode  = ConfigInfo.m_strZip;
        m_textAddress.text = ConfigInfo.m_strAddr;
        
        
        m_textAddress.attributedPlaceholder = NSAttributedString(string: "詳細地址(路名段巷弄號)", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16)
        ])
        
        
        
        if(ConfigInfo.m_strCity != "")
        {
            m_textCity.text = ConfigInfo.m_strCity;
            m_textArea.text = ConfigInfo.m_strArea;
        }
        
        
        let toolBarName = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonName))
        m_textName.inputAccessoryView = toolBarName
        
        
        
        let toolBarZipCode = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonZipCode))
        //m_textZipCode.inputAccessoryView = toolBarZipCode
        
        
        
        let toolBarAddress = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonAddress))
        m_textAddress.inputAccessoryView = toolBarAddress
        
        
        
        
        let toolBarMobile = UIToolbar().ToolbarPiker(mySelect: #selector(doneButtonMobile))
        m_textMobile.inputAccessoryView = toolBarMobile
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ModifyMemberViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ModifyMemberViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
//===================================================//
        DCUpdater.shared()?.queryCitys();
        
        addCityCustomerPick();
        addAreaCustomerPick();
        
        SetTextLinkable();
        
        m_uiPersonalDataPolicyView.isHidden = true
        m_uiPersonalDataPolicyViewBG.isHidden = true
        
        
        m_bIsCheckPolicy = MemberCenterViewController.m_bAlowModifyData;
        
        m_btnOK.backgroundColor = m_bIsCheckPolicy ? UIColor(red: 216.0/255, green: 0, blue: 39.0/255.0, alpha: 1) : UIColor.gray
        
        m_btnOK.isEnabled = m_bIsCheckPolicy;
        
        m_btnCheckPolicy.isEnabled = !MemberCenterViewController.m_bAlowModifyData
        let image = m_bIsCheckPolicy ? UIImage(named:"check") : UIImage(named:"uncheck")
        m_btnCheckPolicy.setBackgroundImage(image! , for: UIControl.State.normal)
        
        CheckShowAlertMsg();
    }
    
    func  CheckShowAlertMsg()
    {
        
        if(!MemberCenterViewController.m_bAlowModifyData)
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let dirAD  = appDelegate.m_UserPolicyCount.GetDictionary();
            if(dirAD.count > 0)
            {
                var  ViewCount = dirAD.value(forKey: "UserCheckCount") as! Int;
                if(ViewCount <= MemberCenterViewController.m_iEverydayCheckCount)
                {
                    ShowAlertControlWithTitle(Message:MemberCenterViewController.m_strAlertPersonalPolicy ,strTitle:"個人資料使用")
                }
            }
            
                      
        }
    }
    
    
    func  addCityCustomerPick()
    {
        m_pickerCityView.delegate = self
        m_pickerCityView.dataSource = self
        
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        m_textCity.inputView = m_pickerCityView
        m_textCity.tag = 202
        
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(doneCityButton))
        toolBar.tintColor = UIColor.blue
        
        m_textCity.inputAccessoryView = toolBar
        
    }
    
    
    
    func  addAreaCustomerPick()
    {
        m_pickerAreaView.delegate = self
        m_pickerAreaView.dataSource = self
        
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        m_textArea.inputView = m_pickerAreaView;
        m_textArea.tag = 203
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(doneAreaButton))
        toolBar.tintColor = UIColor.blue
        
        m_textArea.inputAccessoryView = toolBar
        
    }
    
    
    
    @objc func doneAreaButton()
    {
        if(m_AreasArray.count > 0)
        {
            let iRow = m_pickerAreaView.selectedRow(inComponent: 0)
            
            m_textArea?.text = m_AreasArray[iRow].object(forKey: "district") as! String;
            
            m_strZipCode = m_AreasArray[iRow].object(forKey: "zip_code") as! String;
        }
        m_textArea.resignFirstResponder() // To resign the inputView on clicking done.
    }

    
    
    
    
    @objc func doneCityButton()
    {
        let iRow = m_pickerCityView.selectedRow(inComponent: 0)
        
        m_textCity?.text = m_CitysArray[iRow];
        m_textCity.resignFirstResponder() // To resign the inputView on clicking done.
        
        m_textArea?.text = "請選擇鄉鎮市區";
        
        m_strZipCode = "";
        
        DCUpdater.shared()?.queryAreas(m_textCity?.text)
        
    }

    
    
    
    @objc func doneButtonMobile()
    {
        m_textMobile.resignFirstResponder() // To resign the
    }
    
    
    
    @objc func doneButtonName()
    {
        m_textName.resignFirstResponder() // To resign the
    }
    
    @objc func doneButtonZipCode()
    {
        //m_textZipCode.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    @objc func doneButtonAddress()
    {
        m_textAddress.resignFirstResponder()   //To resign the inputView on clicking done.
        
    }
    
    
    
    func SetCardType()
    {
       
        m_labelCardType.text  = ConfigInfo.CardType[ConfigInfo.m_iCardType-1];
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
    
    
    @IBAction func onModifyClick(_ sender:UIButton)
    {
        if(ConfigInfo.m_strPhone !=  m_textMobile.text)
        {
            GotoAccCodeVirify();
        }else
        {
            
            if(m_strZipCode.count == 0)
            {
                ShowAlertControl(Message: "請選擇縣市鄉鎮市區");
                return;
            }
            
            let iCountAddress = m_textAddress.text!.count;
            
            if(iCountAddress >= 4)
            {
                MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
                
                DCUpdater.shared()?.modifyMember( ConfigInfo.m_strAccessToken,
                                                 andName: m_textName.text
                                                 ,andPhone: m_textMobile.text,
                                                  andPostCode: m_strZipCode,
                                                  andAddress: m_textAddress.text,
                                                  andCity: m_textCity.text,
                                                  andArea: m_textArea.text,
                                                  andAllowModifyData: true);
                
            }else
            {
                
                ShowAlertControl(Message: "請輸入詳細地址(路名段巷弄號)");
                
            }
        }
    }
    
    
    func GotoAccCodeVirify()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btAccCode
        = StoryBoard.instantiateViewController(withIdentifier: "AccCodeVerify") as!  AccCodeVerifyViewController;
        
        btAccCode.m_strPhoneNumber  = m_textMobile.text!;
        btAccCode.m_iVerityType  = 1;
        btAccCode.m_strAddr = m_textAddress.text!;
        btAccCode.m_strName = m_textName.text!;
        btAccCode.m_strZip = m_strZipCode;
        
        
//===============================================//
        btAccCode.m_strCity = m_textCity.text!;
        btAccCode.m_strArea = m_textArea.text!;
//===============================================//
        
        self.navigationController?.pushViewController(btAccCode, animated: true)
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didModifyResult), name:NSNotification.Name(rawValue: kDCModifyUser), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryCitysResult), name:NSNotification.Name(rawValue: kDCQueryCitys), object: nil)
       
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryAreasResult), name:NSNotification.Name(rawValue: kDCQueryAreas), object: nil)
        
        
       
        self.SetTitleColor();
        
        super.viewWillAppear(animated)
        
        self.startTimeTick();
        
        
    }
    
    
    
    @objc func didQueryCitysResult(notification: NSNotification){
        
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
                m_CitysArray  =  dic.object(forKey: "Data") as! Array<String>
                if(m_textCity.text != "請選擇鄉鎮市區")
                {
                    DCUpdater.shared()?.queryAreas(m_textCity?.text);
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
   
    
    @objc func didQueryAreasResult(notification: NSNotification){
        
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
                
                
                let jsonString  =  dic.object(forKey: "Data") as! String
                let jsonData = jsonString.data(using: .utf8)!
                
                do {
                    
                    m_AreasArray = try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [NSDictionary])!
                    
                    print(m_AreasArray as Any)  // 输出: [1, 2, 3]
                    
                } catch {
                    print(error)
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
    
    
    
    
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDCModifyUser), object: nil)
        
        RemoveTitleBar()
        
        //======================================================//
        self.stopTimeTick();
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_MEMBER_EDIT), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
        
        
        
    }
    
    @objc func didModifyResult(notification: NSNotification){
        
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
                ConfigInfo.m_strName  = m_textName.text!;
                ConfigInfo.m_strZip   = m_strZipCode;
                
                ConfigInfo.m_strAddr  = m_textAddress.text!;
                ConfigInfo.m_strPhone =  m_textMobile.text!;
                
//==============================================================//
                ConfigInfo.m_strCity  = m_textCity.text!;
                ConfigInfo.m_strArea  = m_textArea.text!;
                
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
    
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("notification: Keyboard will show")
            
            if(m_uiCurrentTextField != nil && m_uiCurrentTextField.tag == 303)
            {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= (keyboardSize.height*0.65)
                }
            }
            
        }
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        m_uiCurrentTextField = textField;
        
        return true;
    }
    
    
    func onHidePolicy()
    {
        
        m_uiPersonalDataPolicyView.isHidden = true
        m_uiPersonalDataPolicyViewBG.isHidden = true
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "PersonalDataPolicy2")
        {
            m_personalDataViewController =  (segue.destination as!  PersonalDataViewController)
            
            m_personalDataViewController.m_modifyMemberViewController = self
            
        }
    }
    
}
