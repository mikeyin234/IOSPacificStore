//
//  YoutubeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/12/26.
//  Copyright © 2019 greatsoft. All rights reserved.
//////////////////////////////////////////////////////

import UIKit
//import YoutubePlayer_in_WKWebView
import youtube_ios_player_helper


 class YoutubeViewController: BaseViewController,YTPlayerViewDelegate {
    
    @IBOutlet weak var m_player: YTPlayerView!
    //@IBOutlet weak var m_player: YTPlayerView!
    var   m_strVideoID = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        m_player.isHidden = true;
        
        //let webConfiguration = WKWebViewConfiguration()
        //webConfiguration.allowsInlineMediaPlayback = true // Important for inline playback
        
        
        print("Video ID = " +  m_strVideoID);
        
        m_player.load(withVideoId: m_strVideoID, playerVars: ["controls" : 1,"playsinline" : 0,"modestbranding" : 1,"fs" : 0,"rel" : 0,"showinfo": 0,"origin":"http://www.youtube.com"])
        
        m_player.delegate =  self;
    }
    
   
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    
    
     internal func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
           self.m_player.playVideo();
            //m_player.isHidden = false;
             
       }
       
       
     internal func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
