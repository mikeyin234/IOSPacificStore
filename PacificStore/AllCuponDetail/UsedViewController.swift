//
//  UsedViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/3/7.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class UsedViewController: UIViewController {
    
    @IBOutlet var m_labelExchangeDate: UILabel!
    
    @IBOutlet var m_labelExchanged: UILabel!
    
    var m_strExchangeDate = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(m_strExchangeDate.count > 0)
        {
            m_strExchangeDate.insert("/", at: m_strExchangeDate.index(m_strExchangeDate.startIndex, offsetBy: 4))
            m_strExchangeDate.insert("/", at: m_strExchangeDate.index(m_strExchangeDate.startIndex, offsetBy: 7))
            
            m_labelExchangeDate.text  = "兌換日期:\(m_strExchangeDate)";
            
            m_labelExchanged.layer.borderColor = UIColor.red.cgColor
            m_labelExchanged.layer.borderWidth = 3.0
        }
       
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
