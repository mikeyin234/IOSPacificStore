//
//  ReferenceLinkViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/13.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class ReferenceLinkViewController: BaseViewController {

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
    
    
    @IBAction func onPacificStoreClick(_ sender:UIButton)
    {
        if let url = URL(string: "http://fy.pacific-mall.com.tw/indexStore.php") {
            UIApplication.shared.open(url, options: [:])
        }
        
       
    }
    
    
    @IBAction func onFaceBookClick(_ sender:UIButton)
    {   
        if let url = URL(string: ConfigInfo.FB_SITE) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func onLineClick(_ sender:UIButton)
    {
        /*
        if let url = URL(string: "https://goo.gl/AoMrQG") {
            UIApplication.shared.open(url, options: [:])
        }*/
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        let  btVideoListBank
                   = StoryBoard.instantiateViewController(withIdentifier: "VideoList");
        self.navigationController?.pushViewController(btVideoListBank, animated: true)
    }
    
    
    @IBAction func onInstagramClick(_ sender:UIButton)
    {
        if let url = URL(string: "https://www.instagram.com/?hl=zh-tw") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func onMamaClick(_ sender:UIButton)
    {
        if let url = URL(string: "https://fy.pacific-mall.com.tw/memberMom.php") {
            UIApplication.shared.open(url, options: [:])
        }
    }
   
}
