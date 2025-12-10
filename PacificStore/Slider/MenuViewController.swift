///////////////////////////////////////////////////////
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
///////////////////////////////////////////////////////

import UIKit


protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}


extension UIImage {
    func resizeImage(_ newSize: CGSize) -> UIImage? {
        func isSameSize(_ newSize: CGSize) -> Bool {
            return size == newSize
        }
        
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
            
            func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                draw(in: scaledRect)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                return image
            }
            return _scaleImage(getScaledRect(newSize))
        }
        
        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }
}




class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    let picker = UIImagePickerController()
    
    var   m_bUpdateMenu = false;
    var  m_bNeedSave = false;
    
    
    var m_blurView:UIVisualEffectView!;

    
    func showBlurEffect() {
        
        //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        
        
        //创建一个承载模糊效果的视图
        m_blurView = UIVisualEffectView(effect: blurEffect)
        
        m_blurView.frame = CGRect(x: 0, y: 0, width: tblMenuOptions.frame.width, height: self.view.frame.height)
        
        tblMenuOptions.backgroundColor = UIColor.clear;
        tblMenuOptions.backgroundView  = m_blurView;
        
        
        tblMenuOptions.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        //tableView.backgroundView = blurEffectView
        //tblMenuOptions.insertSubview(m_blurView, aboveSubview: tblMenuOptions.backgroundView!)
    }
    
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clear
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        picker.delegate = self
        
       
        
        tblMenuOptions.alwaysBounceVertical = false
        
      
    }
    
    
    @objc func  onNickNameClick() {
      
    }
    
    
    @objc func  onImageViewClick() {
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if( m_blurView != nil)
        {
            m_blurView.removeFromSuperview();
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!m_bUpdateMenu)
        {
           updateArrayMenuOptions()
           m_bUpdateMenu = true;
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        super.viewDidAppear(animated)
        
        showBlurEffect();
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    
    
    func updateArrayMenuOptions(){
        
        arrayMenuOptions.append(["title":"首頁", "icon":"menu_home"])
        arrayMenuOptions.append(["title":"最新消息", "icon":"menu_news"])
        arrayMenuOptions.append(["title":"美食推薦", "icon":"menu_food"])
        
        arrayMenuOptions.append(["title":"品牌導覽", "icon":"menu_brand"])
        arrayMenuOptions.append(["title":"線上DM", "icon":"menu_dm"])
        
        arrayMenuOptions.append(["title":"會員專區", "icon":"menu_member"])
        //arrayMenuOptions.append(["title":"停車資訊", "icon":"menu_parking"])
        
        arrayMenuOptions.append(["title":"太百購物網", "icon":"menu_purchase"])
        arrayMenuOptions.append(["title":"好康直播", "icon":"menu_video"])
        
        arrayMenuOptions.append(["title":"營業及停車資訊","icon":"menu_parking"])
        
        arrayMenuOptions.append(["title":"關於太平洋APP", "icon":"menu_about"])
        
        //arrayMenuOptions.append(["title":"國泰世華聯名卡", "icon":"cathayBank"])
        arrayMenuOptions.append(["title":"相關連結", "icon":"menu_link"])
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        
        arrayMenuOptions.append(["title":"V" + appVersion! + ConfigInfo.m_strBetaVersion, "icon":""])
        
        //arrayMenuOptions.append(["title":"設定", "icon":"menu_setting"])
        
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        
        btnMenu.tag = 0
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }            
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            
            self.view.layoutIfNeeded()
            
            self.view.backgroundColor = UIColor.clear
            
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear;
        
        
        var lblTitle : UILabel!
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        
        if(imgIcon.image == nil)
        {
            lblTitle = (cell.contentView.viewWithTag(101) as! UILabel)
            lblTitle.isHidden = true;
            
            lblTitle  = (cell.contentView.viewWithTag(103) as! UILabel)
            imgIcon.isHidden = true;
        }else
        {
            lblTitle = (cell.contentView.viewWithTag(103) as! UILabel)
            lblTitle.isHidden = true;
            
            lblTitle  = (cell.contentView.viewWithTag(101) as! UILabel)
            imgIcon.isHidden = false;
        }
        
        
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        lblTitle.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        lblTitle.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        lblTitle.isHidden = false
        
        if(indexPath.row == (arrayMenuOptions.count-1))
        {
            lblTitle.font =  UIFont.systemFont(ofSize: 20.0)
        }
        
        //cell.backgroundColor =  UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
       
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    @IBAction func onCloseClick(_ button:UIButton!){
        
    }
    
    
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.delegate = self;
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        
    }
    
   
    
}



extension UIImageView {
    
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let image = UIImage(data: data!)
                if(image != nil)
                {
                   self.image = image
                }
            })
        }).resume()
    }
    
    public func imageFromServerURL(urlString: String,strFilePath:String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let image = UIImage(data: data!)
                if(image != nil)
                {
                    self.image = image
                    self.saveImage(self.image!,strFilePath: strFilePath);
                }
            })
        }).resume()
    }
    
    
    func saveImage(_ inputImage:UIImage,strFilePath:String)
    {
        let imageData:Data = inputImage.pngData()!
        var error: NSError?
        do {
            
            try imageData.write(to: URL(fileURLWithPath: strFilePath as String), options: NSData.WritingOptions.atomic)
            
        } catch let error1 as NSError {
            error = error1
            
        }
    }
}



