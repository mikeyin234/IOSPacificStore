//
//  FinalRegisterViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/2/23.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit


class FinalRegisterViewController: BaseViewController,UITextFieldDelegate,
UIPickerViewDelegate,UIPickerViewDataSource{
    
    var    m_bResiterType = 0;  //0 == AppMember // 1 == CardUser..
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView == m_pickerCityView)
        {
            return m_CitysArray.count;
        }else if(pickerView == m_pickerAreaView)
        {
            return m_AreasArray.count;
        }else
        {
            return 2;
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let pickerLabel = UILabel()
        
        if(pickerView == m_pickerCityView)
        {
            pickerLabel.text = m_CitysArray[row];
            
        }else if(pickerView == m_pickerAreaView)
        {
            pickerLabel.text = m_AreasArray[row].object(forKey: "district") as? String;
        }else
        {
            if row == 0 {
                pickerLabel.text = "男"
            } else if row == 1 {
                pickerLabel.text = "女"
            }
        }
        
        pickerLabel.font = UIFont.systemFont(ofSize: 25);
        pickerLabel.textAlignment = NSTextAlignment.center
        
        return pickerLabel
    }
    
    
    @IBOutlet weak var m_textName:UITextField!
    @IBOutlet weak var m_textSex:UITextField!
    @IBOutlet weak var m_textBirthday:UITextField!
    var m_strCardNumber = "";
    @IBOutlet weak var m_textShareCode: UITextField!
    
    
    var  formatter: DateFormatter! = nil
    let  myDatePicker  = UIDatePicker()
    var  m_CitysArray  = Array<String>();
    var  m_AreasArray  = Array<NSDictionary>();
    
    
    //===========================================//
    let   m_pickerView  = UIPickerView();
    let   m_pickerCityView  = UIPickerView();
    let   m_pickerAreaView  = UIPickerView();
    
    
    @IBOutlet weak var m_textCity:UITextField!
    @IBOutlet weak var m_textArea:UITextField!
    @IBOutlet weak var m_textAddress:UITextField!
    
    var  m_strZipCode = "";
    @IBOutlet weak var m_uiCurrentTextField: UITextField!
    
    
//========================================================//
    @IBOutlet weak var m_lablePersonalData: UILabel!
    
    static  var  m_strPolicySite  = "";
    
    
    
//=====================================================//
    @IBOutlet var m_uiPersonalDataPolicyView : UIView!
    @IBOutlet var m_uiPersonalDataPolicyViewBG : UIView!
    
    var  m_personalDataViewController:PersonalDataViewController!
    
    
    
    @IBOutlet weak var m_btnCheckPolicy:UIButton!
    
    
    @IBOutlet weak var m_btnRegister:UIButton!
    
    
//=========================================================/
    var m_bIsCheckPolicy = false;
    
    
    func SetTextLinkable()
    {
        let attributedString = NSMutableAttributedString(string:"本人同意個人資料使用條款")
        
        let linkWasSet = attributedString.setAsLink(textToFind: "個人資料使用條款", linkURL: "https://stackoverflow.com")
        
        m_lablePersonalData.attributedText = attributedString;
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(FinalRegisterViewController.tapFunction))
        
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
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      
        
        addBirthdayPick();
        addCustomerPick();
        addCityCustomerPick();
        addAreaCustomerPick();
        
        
        if (m_bResiterType == ConfigInfo.CAR_MEMBER)
        {
            m_textName.text  = ConfigInfo.m_strName;
            m_textSex.text  = ConfigInfo.m_strSex == "1" ? "男" : "女";
            m_textBirthday.text  = ConfigInfo.m_strBirthday;
            
//==========================================================//
            m_textAddress.text = ConfigInfo.m_strAddr;
            m_textCity.text = ConfigInfo.m_strCity;
            m_textArea.text = ConfigInfo.m_strArea;
            
//=============================================================//
            //add at 2013/10/06
            m_strZipCode    = ConfigInfo.m_strZip;
            
            
            m_textSex.isEnabled = false;
            m_textBirthday.isEnabled = false;
        }
        
        DCUpdater.shared()?.queryCitys();
        m_textAddress.tag = 303;
        
        m_textAddress.attributedPlaceholder = NSAttributedString(string: "詳細地址(路名段巷弄號)", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16)
        ])
        
        
        
        m_textShareCode.tag = 304;
        
        NotificationCenter.default.addObserver(self, selector: #selector(ModifyMemberViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ModifyMemberViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        SetTextLinkable()
        
        m_uiPersonalDataPolicyView.isHidden = true
        m_uiPersonalDataPolicyViewBG.isHidden = true
        
        
        
        DCUpdater.shared().queryPersonalUserDataPolicy();
        
        m_btnRegister.isEnabled = false
        
        m_btnRegister.backgroundColor = UIColor.gray
        
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
                
                DCUpdater.shared().queryPersonalUserDataPolicy();
                
                
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    
    func  addBirthdayPick()
    {
        formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        myDatePicker.datePickerMode = .date
        
        myDatePicker.locale = Locale(identifier: "zh_CN")
        
        myDatePicker.date = NSDate() as Date
        
        
        if #available(iOS 13.4, *) {
            myDatePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        
         
        
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        m_textBirthday.inputView = myDatePicker
        m_textBirthday.tag = 200
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(doneBirthdayButton))
        toolBar.tintColor = UIColor.blue
        
        m_textBirthday.inputAccessoryView = toolBar
        
        
    }
    
    
    func  addCustomerPick()
    {
        m_pickerView.delegate = self
        m_pickerView.dataSource = self
        
        
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        m_textSex.inputView = m_pickerView
        m_textSex.tag = 201
        
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(doneSexButton))
        toolBar.tintColor = UIColor.blue
        
        
        m_textSex.inputAccessoryView = toolBar
        
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
        let iRow = m_pickerAreaView.selectedRow(inComponent: 0)
        
        m_textArea?.text = m_AreasArray[iRow].object(forKey: "district") as! String;
        
        
        m_strZipCode = m_AreasArray[iRow].object(forKey: "zip_code") as! String;
        
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

    
    
    
   
    
    
    @objc func doneSexButton()
    {
        let iRow = m_pickerView.selectedRow(inComponent: 0)
        m_textSex?.text = iRow == 0 ? "男" : "女";
        m_textSex.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    @objc func doneBirthdayButton()
    {
        m_textBirthday?.text =
            formatter.string(from: myDatePicker.date)
        
        m_textBirthday.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
   
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        
        if(segue.identifier == "PersonalDataPolicy")
        {
            m_personalDataViewController =  segue.destination as!  PersonalDataViewController
            
            m_personalDataViewController.m_finalRegisterViewController = self
            
            
        }
        
        
    }
    

    @IBAction func onRegisterClick(_ sender:UIButton)
    {
        if(m_textName.text?.count==0)
        {
            ShowAlertControl(Message: "姓名不能為空!");
            return;
        }else if(m_textSex.text?.count==0)
        {
            ShowAlertControl(Message: "性別不能為空!");
            return;
        }else if(m_textBirthday.text!.count == 0)
        {
            ShowAlertControl(Message: "生日不能為空·!");
            return;
        }
        
        let iSex = m_textSex.text == "男" ? "1" : "2";
        if(m_bResiterType != ConfigInfo.CAR_MEMBER)
        {
            let myAge = myDatePicker.date.age;
            if(myAge<=13)
            {
                ShowAlertControl(Message: "13歲以上才能註冊.");
                return;
            }
        }
        
        if(m_strZipCode.count == 0)
        {
            ShowAlertControl(Message: "請選擇縣市鄉鎮市區");
            return;
        }
        
        
        let iCountAddress = m_textAddress.text!.count
        if(iCountAddress >=  4)
        {
            MBProgressHUDObjC.showHUDAdded(to:  self.view, animated: true)
            //m_textShareCode
            if (m_bResiterType == ConfigInfo.APP_MEMBER)
            {
               DCUpdater.shared()?.register(ConfigInfo.m_strUserID, andPassword: ConfigInfo.m_strPassword, andName: m_textName.text, andSex: "\(iSex)", andBirthday: m_textBirthday.text,andPhone:ConfigInfo.m_strPhone, andShareCode: m_textShareCode.text,andPushToken: ConfigInfo.FCM_DEVICE_TOKEN,
                                            andZipCode: m_strZipCode , andCity: m_textCity.text , andArea: m_textArea.text ,
                                            andAddress: m_textAddress.text, andAllowModifyData: true)
                ;
                
            }else
            {
               //ConfigInfo.m_bIsChildren
               DCUpdater.shared()?.cardRegister(ConfigInfo.m_strUserID, andPassword: ConfigInfo.m_strPassword, andName: m_textName.text, andSex: "\(iSex)", andBirthday: m_textBirthday.text,                                            andPhone: ConfigInfo.m_strPhone, andCardNumber: ConfigInfo.m_strCardNumber, isChildren: ConfigInfo.m_bIsChildren ? 1 : 0, andShareCode: m_textShareCode.text,andPushToken: ConfigInfo.FCM_DEVICE_TOKEN,
                                                andZipCode: m_strZipCode , andCity: m_textCity.text , andArea: m_textArea.text ,
                                                andAddress: m_textAddress.text,
                                                andAllowModifyData: true);                
            }            
        }else
        {
            
            ShowAlertControl(Message: "請輸入詳細地址(路名段巷弄號)");
        }
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
        
        NotificationCenter.default.addObserver(self, selector:#selector(didRegisterResult), name:NSNotification.Name(rawValue: kDCRegisterUser), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryCitysResult), name:NSNotification.Name(rawValue: kDCQueryCitys), object: nil)
       
        
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryAreasResult), name:NSNotification.Name(rawValue: kDCQueryAreas), object: nil)
        
        
//===============================================================================================//
        NotificationCenter.default.addObserver(self, selector:#selector(didQueryPerosnalDataResult), name:NSNotification.Name(rawValue: kDCPersonalDataUseTerms), object: nil)
        
        
    }
    
    @objc func didQueryPerosnalDataResult(notification: NSNotification){
        
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
                FinalRegisterViewController.m_strPolicySite = dic.object(forKey: "WebPage") as! String;
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    func onHidePolicy()
    {
        
        m_uiPersonalDataPolicyView.isHidden = true
        m_uiPersonalDataPolicyViewBG.isHidden = true
        
    }
    
    
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
        
    }
    
    @IBAction func onCheckClick(_ sender:UIButton)
    {
        m_bIsCheckPolicy = !m_bIsCheckPolicy;
        
        let image = m_bIsCheckPolicy ? UIImage(named:"check") : UIImage(named:"uncheck")
        
        m_btnRegister.isEnabled = m_bIsCheckPolicy
        
        
        m_btnRegister.backgroundColor = m_bIsCheckPolicy ? UIColor(red: 216.0/255, green: 0, blue: 39.0/255.0, alpha: 1) : UIColor.gray
        
        m_btnCheckPolicy.setBackgroundImage(image! , for: UIControl.State.normal)
        
    }
    
    @objc func didRegisterResult(notification: NSNotification){
        
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
                ConfigInfo.m_bMemberLogin  = true;
                
                ConfigInfo.m_strSex  = m_textSex.text!;
                ConfigInfo.m_strBirthday  = m_textBirthday.text!;
                ConfigInfo.m_strName = m_textName.text!;
                
                
                let DataDic = dic.object(forKey: "Data") as! NSDictionary;
                
                ConfigInfo.m_SerialNo = DataDic.object(forKey: "SerialNo") as! String;
                ConfigInfo.m_strAccessToken = DataDic.object(forKey: "AccessToken") as! String;
                ConfigInfo.m_iMemberType = Int(DataDic.object(forKey: "MemberType") as! String)!;
                ConfigInfo.m_strCardNumber = DataDic.object(forKey: "CardNumber") as! String;
                
                
                ConfigInfo.m_strZip = DataDic.object(forKey: "PostCode") as! String;
                ConfigInfo.m_strAddr = DataDic.object(forKey: "Address") as! String;
                
                
//======================================================================//
                ConfigInfo.m_strCity = DataDic.object(forKey: "city") as! String;
                ConfigInfo.m_strArea = DataDic.object(forKey: "region") as! String;
//======================================================================//
                
                
                
                ConfigInfo.m_iCardType = Int(DataDic.object(forKey: "CardType") as! String)!;
                SaveToUserLoginInfo();
                
                //Goto Password Result
                let alert = UIAlertController(title: "系統資訊", message:"恭禧您成功註冊。", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (UIAlertAction) in
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }))
                
                self.present(alert, animated: true)
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    func SaveToUserLoginInfo()
    {
        let myUserDefaults = UserDefaults.standard;
        
        myUserDefaults.set(ConfigInfo.m_strUserID, forKey: "UserID");
        myUserDefaults.set(ConfigInfo.m_strPassword, forKey: "Password");
        myUserDefaults.set(true, forKey: "IsSave")
        myUserDefaults.set(ConfigInfo.m_SerialNo , forKey: "SerialNo")
        myUserDefaults.set(ConfigInfo.m_strAccessToken , forKey: "AccessToken")
        myUserDefaults.set(ConfigInfo.m_iMemberType , forKey: "MemberType")
        myUserDefaults.set(ConfigInfo.m_strName , forKey: "Name")
        myUserDefaults.set(ConfigInfo.m_strBirthday , forKey: "Birthday")
        myUserDefaults.set(ConfigInfo.m_strZip , forKey: "ZIP")
        myUserDefaults.set(ConfigInfo.m_strAddr , forKey: "ADDR")
        myUserDefaults.set(ConfigInfo.m_strSex , forKey: "Sex")
        myUserDefaults.set(ConfigInfo.m_strPhone , forKey: "PhoneNumber")
        myUserDefaults.set(ConfigInfo.m_iCardType , forKey: "CardType")
        myUserDefaults.set(ConfigInfo.m_strCardNumber , forKey: "CardNumber")
        myUserDefaults.set(ConfigInfo.m_bMemberLogin , forKey: "IsLogin")
        
        
        myUserDefaults.synchronize();
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("notification: Keyboard will show")
            
            if(m_uiCurrentTextField != nil && m_uiCurrentTextField.tag == 304)
            {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= (keyboardSize.height*0.4)
                }
            }
            
            
        }
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        m_uiCurrentTextField = textField;
        
        return true;
    }
    
    
    
    @objc func keyboardWillHide(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}


