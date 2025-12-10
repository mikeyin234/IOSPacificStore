//
//  ResultGameViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/30.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import UIKit

class ResultGameViewController: GameBaseViewController {
        
    @IBOutlet weak var m_imageSignView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = URL(string:ConfigInfo.m_gameInfo.strSignImage);
        
        if(url != nil)
        {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
            if(data != nil)
            {
                 let image = UIImage(data: data!)!
                 m_imageSignView.image = image
            }            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
      self.playSound(strFileName: "sign_text", strExtName: "mp3",iLoop: 0);
      
   }
   
    
    override  func viewWillDisappear(_ animated: Bool) {
        
            player?.stop();

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
    
    override var prefersStatusBarHidden: Bool {
           return true
    }
    
  
    
    @IBAction func onGetRewardClick(_ sender:UIButton)
    {
           
           let  StoryBoard = UIStoryboard(name: "game" , bundle: nil)
                  
           let  btMainGame
                             = StoryBoard.instantiateViewController(withIdentifier: "RewardGame");
                  
           self.navigationController?.pushViewController(btMainGame, animated: true)        
    }
    
    
    
    
    
    
}
