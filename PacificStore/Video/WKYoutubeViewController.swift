//
//  YoutubeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/12/26.
//  Copyright © 2019 greatsoft. All rights reserved.
//////////////////////////////////////////////////////

import UIKit



import youtube_ios_player_helper
//import YoutubePlayer_in_WKWebView


class WKYoutubeViewController: BaseViewController,YTPlayerViewDelegate {
    
    @IBOutlet weak var m_player: YTPlayerView!
    
    //@IBOutlet weak var m_player: YTPlayerView!
    var   m_strVideoID = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        m_player.isHidden = true;
        print("Video ID = " +  m_strVideoID);
        
        //let strCustomPlayer = Bundle.main.path(forResource: "custom_player", ofType: "html")
        
      
        /*m_player.load(withVideoId: m_strVideoID, playerVars: ["controls" : 0,"playsinline" : 0,"modestbranding" : 1,"fs" : 0,"rel" : 0,"showinfo": 0,"origin":"http://www.youtube.com"],
                      templatePath:strCustomPlayer)*/
        
        m_player.load(withVideoId: m_strVideoID, playerVars: ["controls" : 0,"playsinline" : 0,"modestbranding" : 1,"fs" : 0,"rel" : 0,"showinfo": 0,"origin":"http://www.youtube.com"])
        
        m_player.delegate =  self;
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
          m_player.playVideo();
          //m_player.isHidden = false;
    }
    
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
        if(state == .playing)
        {
             m_player.isHidden = false;
        }else if(state == .ended)
        {
            self.navigationController?.popViewController(animated: true);
        }else if(state == .unstarted)
        {
            
        }
    }
    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
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
