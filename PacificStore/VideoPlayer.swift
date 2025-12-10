//
//  VideoPlayer.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/4/7.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
//import YoutubePlayer_in_WKWebView
import youtube_ios_player_helper


class VideoPlayer
{
    var  m_player : AVPlayer?
    var m_strYoutubeID   = "";
    var m_ParentControl:UIViewController!
    
    func AddVideoToView(strURL:String, strYoutubeID:String,viewVideo:UIView!,
                        ParentControl:UIViewController!)
    {
                    m_ParentControl  = ParentControl
                    m_strYoutubeID  = strYoutubeID;
                    //put your code here
                    if let url = URL(string: strURL)
                    {
                        //2. Create AVPlayer object
                        let asset = AVAsset(url: url)
                        let playerItem = AVPlayerItem(asset: asset)
                        let player = AVPlayer(playerItem: playerItem)
                        
                        viewVideo.backgroundColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                        
                        
                        //3. Create AVPlayerLayer object
                        player.isMuted = true;
                        let playerLayer = AVPlayerLayer(player: player)
                        playerLayer.frame = CGRect(x: 0, y: 0, width: viewVideo.frame.size.width, height:viewVideo.frame.size.height)
                        
                        player.play();
                        
                        playerLayer.videoGravity = .resizeAspect
                        //4. Add playerLayer to view's layer
                        viewVideo.layer.addSublayer(playerLayer)
                        
                        self.AddOnTouchClick(vTouch: viewVideo,action: #selector(self.tapHandler));
                    }
                                                       
     }
    
    
    func AddYVVideoToView(strYoutubeID:String,viewVideo:UIView!,
                        ParentControl:UIViewController!)
    {
                    m_ParentControl  = ParentControl
                    m_strYoutubeID  = strYoutubeID;
                    //put your code here
        
                    self.AddOnTouchClick(vTouch: viewVideo,action: #selector(self.tapHandler));
                                                       
        }
    
    
    
    
    func play() {
        m_player?.play()
    }
    
    
    func stop() {
        m_player?.pause()
    }
    
    
    @objc func tapHandler(_ sender: UIGestureRecognizerDelegate) {
        
           self.stop();        
           StarPlayYoutube(identifier:m_strYoutubeID);
    }
    
    
    func  AddOnTouchClick(vTouch:UIView!,action:Selector?)
       {
           let tapNoInstallRecognizer = UITapGestureRecognizer.init(target: self, action: action)
           
           tapNoInstallRecognizer.numberOfTapsRequired = 1;
           
           vTouch.addGestureRecognizer(tapNoInstallRecognizer);
           vTouch.isUserInteractionEnabled = true;
       }
    
    
    
    func StarPlayYoutube(identifier:String)
       {
           //YTPlayerView.load(T##self: YTPlayerView##YTPlayerView);
           let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
           
           let  ControlYoutube
               = StoryBoard.instantiateViewController(withIdentifier: "Youtube") as! YoutubeViewController;
        
           ControlYoutube.m_strVideoID = identifier;
        
           //ControlYoutube.m_strVideoID = "qQVKXmpG7Vk";
        
           m_ParentControl.navigationController!.pushViewController(ControlYoutube, animated: true)
        
    }
    
    
}
