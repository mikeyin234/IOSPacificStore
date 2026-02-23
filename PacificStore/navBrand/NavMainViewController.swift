//
//  NavMainViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/5.
//  Copyright © 2019 greatsoft. All rights reserved.
////////////////////////////////////////////////////////

import UIKit

class NavMainViewController: BaseViewController , UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mTableview: UITableView!
    
    @IBOutlet     weak var   m_btnBuilding:UIButton!;
    @IBOutlet     weak var   m_btnClass:UIButton!;
    @IBOutlet     weak var   m_btnHomeSearch:UIButton!;
    
//====================================================//
    @IBOutlet     weak var   m_lableTitle:UILabel!;
    
    
    
    var m_ListDetailInfo:[NSDictionary] =  [];
    var m_imageCache  = NSMutableDictionary();
    var   m_iCurrentType = 0;
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  m_ListDetailInfo.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
        
        
        if(m_iCurrentType==0)
        {
            var Mycell:BuildTableViewCell!;
            
            let cell: BuildTableViewCell = BuildTableViewCell(style: .default, reuseIdentifier: "Imagecell")
            
            cell.m_labelText.text  = (m_ListDetailInfo[indexPath.row].object(forKey:"Name") as! String);
            
            let url = URL(string:m_ListDetailInfo[indexPath.row].object(forKey:"ImageName")as! String);
            
            if(url != nil)
            {
                if  let cachedImage = m_imageCache.object(forKey: url!.absoluteString as NSString)
                {
                    cell.m_imageView.image = (cachedImage as! UIImage)
                }else
                {
                    fetchImage(from: url!.absoluteString) { image in
                        // IMPORTANT: Update UI on the main thread
                        DispatchQueue.main.async { [weak imageView = cell.m_imageView] in
                            
                            self.m_imageCache.setObject(image!, forKey: url!.absoluteString as NSString)
                            imageView?.image = image!
                        }
                    }
                    
                    /*
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
                    let image = UIImage(data: data!)!
                    
                    self.m_imageCache.setObject(image, forKey: url!.absoluteString as NSString)
                    
                    cell.m_imageView.image = image
                    */
                }
            }
            cell.m_labelText.font = UIFont.systemFont(ofSize: 20.0);
            Mycell = cell;
            
            return Mycell
        }else
        {
            var Mycell:BrandTableViewCell!;
            
            let cell: BrandTableViewCell = BrandTableViewCell(style: .default, reuseIdentifier: "ImagecellBrand")
            
            cell.m_labelText.text  = (m_ListDetailInfo[indexPath.row].object(forKey:"Name") as! String);
            
            let url = URL(string:m_ListDetailInfo[indexPath.row].object(forKey:"ImageName")as! String);
            
            if  let cachedImage = m_imageCache.object(forKey: url!.absoluteString as NSString)
            {
                cell.m_imageView.image = (cachedImage as! UIImage)
            }else
            {
                
                fetchImage(from: url!.absoluteString) { image in
                    // IMPORTANT: Update UI on the main thread
                    DispatchQueue.main.async { [weak imageView = cell.m_imageView] in
                        
                        if( image != nil)
                        {
                            self.m_imageCache.setObject(image!, forKey: url!.absoluteString as NSString)
                            imageView?.image = image!                        
                        }
                    }
                }
                
                /*
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
                if(data != nil)
                {
                    let image = UIImage(data: data!)!
                    m_imageCache.setObject(image, forKey: url!.absoluteString as NSString)
                    cell.m_imageView.image = image
                }*/
                
            }
            
            cell.m_labelText.font = UIFont.systemFont(ofSize: 20.0);
            cell.m_bisLeft = indexPath.row % 2 == 0 ? true : false;
            cell.Relocation();
            
            Mycell = cell;
            return Mycell
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getBrandClassType("1");
        
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
        
        if(m_iCurrentType == 0)
        {
            return CGFloat(BuildTableViewCell.MainHeight);
        }else
        {
            return CGFloat(BrandTableViewCell.MainHeight);
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataDic = m_ListDetailInfo[indexPath.row];
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btSubNavBrandMain
            = StoryBoard.instantiateViewController(withIdentifier: "NavSubMain") as! NavSubMainViewController
        
        btSubNavBrandMain.m_strID  = dataDic.object(forKey: "id") as! String;
        btSubNavBrandMain.m_strSubTitle = dataDic.object(forKey: "Name") as! String;
        btSubNavBrandMain.m_strTitle  = m_iCurrentType==0 ? "樓層導覽" :"類別導覽";
        
        btSubNavBrandMain.m_strFloor = dataDic.object(forKey: "Floor") as! String;
        
        btSubNavBrandMain.m_strBrandType =  m_iCurrentType==0 ? "1" :"2";
        self.navigationController?.pushViewController(btSubNavBrandMain, animated: true)
        
    }
    
    
    @IBAction func onBuildingClick(_ sender:UIButton)
    {
       m_btnBuilding.setTitleColor(UIColor.white, for: UIControl.State.normal)
       m_btnClass.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
       
        
        
        m_iCurrentType =  0;
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getBrandClassType("1");
        
        //mTableview.reloadData();
    }
    
    
    @IBAction func onClassClick(_ sender:UIButton)
    {
        m_btnBuilding.setTitleColor(UIColor.black, for: UIControl.State.normal)
        m_btnClass.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
        m_iCurrentType =  1;
        
        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
        DCUpdater.shared()?.getBrandClassType("2");
        
        //mTableview.reloadData();
    }
    
    
    @IBAction func onHomeSearchClick(_ sender:UIButton)
    {
        
    }
    
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetBrandTypesResult), name:NSNotification.Name(rawValue: kDCGetBrandClassType), object: nil)
        
        self.SetTitleColor();
        
//====================================================//
        self.startTimeTick();
        
   }
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        RemoveTitleBar()
        
        
        
        //================================================================================//
        self.stopTimeTick();
        ///////////////////////////////////////////////////////////////////////
        //品牌導覽
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_BRAND), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
    }
    
    @objc func didGetBrandTypesResult(notification: NSNotification){
            //do stuff
            let userInfo = notification.userInfo as NSDictionary?;
            let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
            MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
            
            if(strSuccess.isEqual(to: "YES"))
            {
                let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
                let  strCode = dic.object(forKey: "ReturnCode") as! String;
                
                m_ListDetailInfo.removeAll();
                m_imageCache.removeAllObjects();
                
                
                if(Int(strCode) == 0)
                {
                    let DataArray = dic.object(forKey: "Data") as! NSArray;
                    
                    for DataDic  in DataArray
                    {
                        let dicData  = DataDic as! NSDictionary
                        
                        print(dicData["ImageName"]);
                        
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
    
    
    @IBAction func onSearchBrandDetailClick(_ sender:UIButton)
    {
        let alert = UIAlertController(title: "品牌搜尋", message: "請輸入品牌名稱", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in            
            let textField = alert!.textFields![0] // Force unwrapping
            self.Search(strName: textField.text!);
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func Search(strName:String)
    {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btSubNavBrandMain
            = StoryBoard.instantiateViewController(withIdentifier: "NavSubMain") as! NavSubMainViewController
        
        btSubNavBrandMain.m_strBrandType = "3";        
        btSubNavBrandMain.m_strName = strName;
        
        
        self.navigationController?.pushViewController(btSubNavBrandMain, animated: true)
        
    }
}
