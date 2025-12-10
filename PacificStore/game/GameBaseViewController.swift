//
//  GameBaseViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/31.
//  Copyright © 2020 greatsoft. All rights reserved.
//

import UIKit
import AVFoundation


class GameBaseViewController: BaseViewController {

    var player: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func playSound2(strFileName:String,strExtName:String,iLoop:Int)
    {
        guard let url = Bundle.main.url(forResource: strFileName, withExtension: strExtName) else { return
            
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            
            try AVAudioSession.sharedInstance().setActive(true)
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            //AVAudioPlayer(contentsOf: T##URL
          
            player2 = try AVAudioPlayer(contentsOf: url)
          
            player2?.numberOfLoops  = iLoop;
          
            player2?.prepareToPlay();
            
            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            guard let player = player2 else { return }
            
            player.volume  = ConfigInfo.m_bOpenVoice ? 0.5 : 0;
            
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

    func playSound(strFileName:String,strExtName:String,iLoop:Int)
      {
         
        
          guard let url = Bundle.main.url(forResource: strFileName, withExtension: strExtName) else { return
              
          }
          do {
              try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
              
              try AVAudioSession.sharedInstance().setActive(true)
              /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
              //AVAudioPlayer(contentsOf: T##URL
            
              player = try AVAudioPlayer(contentsOf: url)
            
              player?.numberOfLoops  = iLoop;
            
              player?.prepareToPlay();
              
              /* iOS 10 and earlier require the following line:
              player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
              guard let player = player else { return }
            
              player.volume  = ConfigInfo.m_bOpenVoice ? 0.5 : 0;
            
              player.play()

          } catch let error {
              print(error.localizedDescription)
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
    
   func  SetPlayMute()
   {
       player!.volume  = ConfigInfo.m_bOpenVoice ? 0.5 : 0;
       if(player2 != nil)
       {
          player2!.volume  = ConfigInfo.m_bOpenVoice ? 0.5 : 0;
       }
    
   }
    
    
}
