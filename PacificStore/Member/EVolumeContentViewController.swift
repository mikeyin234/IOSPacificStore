//
//  EVolumeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/1/31.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class EVolumeContentViewController: BaseViewController {
    
    @IBOutlet weak var mtvContent: UITextView!
    
    
    var   m_dataDirectory:NSDictionary!
    
    @IBOutlet var m_labelWalletName : UILabel!
    @IBOutlet var m_labelPoint : UILabel!
    @IBOutlet var m_labelLimitDate : UILabel!
    
    
    
    
    var  m_strTitle = "";
    @IBOutlet var m_labelTitle : UILabel!
    
    
    @IBOutlet var m_labelUnit : UILabel!
    var  m_strUnit = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_labelTitle.text  = m_strTitle;
        
        if(m_strTitle == "Q點")
        {
           m_labelUnit.text  = "Q";
        }else if(m_strTitle == "摸彩券")
        {
            m_labelUnit.text  = "張";
        }
        
        
        let strWalletName = m_dataDirectory.object(forKey: "wallet_name") as! String;
        let strPoint  = (m_dataDirectory.object(forKey: "wallet_amt") as! Int);
              
        let   dateStart =  (m_dataDirectory.object(forKey: "exp_date_start") as! String);
        let dateEnd  =  (m_dataDirectory.object(forKey: "exp_date_end") as! String);
                       
        let strRemark = m_dataDirectory.object(forKey: "remark") as! String;
        
        m_labelLimitDate.text  = "\(strRemark)\n使用期限：\( ConfigInfo.FormatDateStirng(strDate: dateStart))-\( ConfigInfo.FormatDateStirng(strDate: dateEnd))";
    
        m_labelWalletName.text  = strWalletName;
        m_labelPoint.text  = "\(strPoint)";
      
        
        // Do any additional setup after loading the view.
        mtvContent.insertText(m_dataDirectory.object(forKey: "remark2") as! String);
        
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
        
        super.viewWillAppear(animated)
        

        
    }
    
    override  func viewWillDisappear(_ animated: Bool) {
        
       
        RemoveTitleBar()
        
      
        
    }
    
    
    
    
}
