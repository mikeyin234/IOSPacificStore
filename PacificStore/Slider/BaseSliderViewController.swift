//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//
import UIKit

class BaseSliderViewController: BaseViewController, SlideMenuDelegate {
    
    let NAV_NEWS_MENU:Int32 =  1;
    let NAV_FOODS_MENU:Int32 =  2;
    let NAV_BRAND_MENU:Int32 =  3;
    
    let ONLINE_DM:Int32   =  4;
    let LOGIN_MENU:Int32 =  5;
    
    let PURCHASE_MENU:Int32 =  6;
    let VIDEO_LIST_MENU:Int32 =  7;
    
    let  NAV_PARKING_MENU:Int32 =  8;
    
    let ABOUT_US_MENU:Int32 =  9;
    //let  CATHAY_LINK:Int32 =  10;
    let  REFERENCE_LINK_MENU:Int32 =  10;
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @objc func MemberLogoutResult(notification: Notification) {
         exit(0)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.SetTitleColor();
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MemberLogoutResult),
                                               name: NSNotification.Name(rawValue: "MemberLogoutResult"),
                                               object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
        RemoveTitleBar()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        
        //let topViewController : UIViewController = self.navigationController!.topViewController!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        switch(index){
        case 0:
            let  viewController  =  UIApplication.topViewController()  as!  ViewController;
            viewController.RefershMainPage();            
            break       
        case NAV_NEWS_MENU:
            onNews();
            break
        case NAV_FOODS_MENU:
            onFoods();
            break            
        case NAV_BRAND_MENU:
            GotoNavBrandController();
            break
        case LOGIN_MENU:            
            GotoLoginController();
            break
        case PURCHASE_MENU:
             onPurchaseInfo();             
            break;
        case NAV_PARKING_MENU:
            onParkingInfo();            
            break;
        case ABOUT_US_MENU:
            onAboutUS();            
            break;
        case ONLINE_DM:
            OnLineDM();            
            break;
        case REFERENCE_LINK_MENU:
            OnReferenceLink();            
            break;
       // case CATHAY_LINK:
         //   OnCathayBankLink();
           // break;
        case VIDEO_LIST_MENU:
            OnVideoLink();
            break;
        default:
            print("default\n", terminator: "")
        }
    }
    
    
    func OnVideoLink()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btVideoListBank
            = StoryBoard.instantiateViewController(withIdentifier: "VideoList");
        
        self.navigationController?.pushViewController(btVideoListBank, animated: true)
        
    }
    
    
    
    func OnCathayBankLink()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btCathayBank
            = StoryBoard.instantiateViewController(withIdentifier: "CathayBank");
        
        self.navigationController?.pushViewController(btCathayBank, animated: true)
        
    }
    
    
    
    func OnReferenceLink()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btDMOnline
            = StoryBoard.instantiateViewController(withIdentifier: "ReferenceLink");
        
        self.navigationController?.pushViewController(btDMOnline, animated: true)
        
    }
    
    
    func OnLineDM()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btDMOnline
            = StoryBoard.instantiateViewController(withIdentifier: "DMOnLine");
        
        self.navigationController?.pushViewController(btDMOnline, animated: true)
        
    }
    
    
    
    func GotoNavBrandController()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btNavBrandMain
                = StoryBoard.instantiateViewController(withIdentifier: "NavBrandMain");
        
        self.navigationController?.pushViewController(btNavBrandMain, animated: true)
        
    }
    
    @IBAction func onPurchaseInfo() {
        
      
            let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
            let  btParkingInfo
                           = StoryBoard.instantiateViewController(withIdentifier: "PurchaseView");
            self.navigationController?.pushViewController(btParkingInfo, animated: true)
        
    }
    
    
    @IBAction func onParkingInfo() {
           
           
               let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
               let  btParkingInfo
                   = StoryBoard.instantiateViewController(withIdentifier: "ParkingInfo");
               self.navigationController?.pushViewController(btParkingInfo, animated: true)
       }
    
    
    
    func GotoLoginController()
    {
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        if(!ConfigInfo.m_bMemberLogin)
        {
           let  btPurchaseDevice
              = StoryBoard.instantiateViewController(withIdentifier: "Login");
           self.navigationController?.pushViewController(btPurchaseDevice, animated: true)
        }else
        {  
            let  btMemberCenter
                = StoryBoard.instantiateViewController(withIdentifier: "MemberCenter");
            
            self.navigationController?.pushViewController(btMemberCenter, animated: true)
            
        }
    }
    
    
   
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
       
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        
        
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            //self.slideMenuItemSelectedAtIndex(-1);
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        
        let menuVC  = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        sender.tag = 10
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
        
    }
    
    
    @IBAction func onNews() {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btNavBrandMain
            = StoryBoard.instantiateViewController(withIdentifier: "NewsList");
        
        self.navigationController?.pushViewController(btNavBrandMain, animated: true)
        
    }
    
    
    @IBAction func onFoods() {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btFoodList
            = StoryBoard.instantiateViewController(withIdentifier: "FoodList");
        
        self.navigationController?.pushViewController(btFoodList, animated: true)
        
    }
    
    
    @IBAction func onAboutUS() {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btFoodList
            = StoryBoard.instantiateViewController(withIdentifier: "AboutUS");
        
        self.navigationController?.pushViewController(btFoodList, animated: true)
        
    }
    
    
    
}
