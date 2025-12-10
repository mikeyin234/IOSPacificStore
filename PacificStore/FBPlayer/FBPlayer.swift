//
//  FBPlayer.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2022/6/13.
//  Copyright © 2022 greatsoft. All rights reserved.
//

import Foundation
import WebKit


class FBPlayer
{
    var   m_FBWebView : WKWebView!
    let   FB_APP_ID  = "4971263529589029";
    
    func LoadHtmlFile(FBWebView : WKWebView!,video_url:String)
    {
           m_FBWebView =  FBWebView;
           m_FBWebView.configuration.preferences.javaScriptEnabled = true;
        
           // Adding webView content
            do {
                guard let filePath = Bundle.main.path(forResource: "players", ofType: "html")
                    else {
                        // File Error
                        print ("File reading error")
                        return
                }
                
                var contents =  try String(contentsOfFile: filePath, encoding: .utf8)
                contents = contents.replacingOccurrences(of: "{app_id}", with: FB_APP_ID)
                contents = contents.replacingOccurrences(of: "{video_url}", with: video_url)
                
                contents = contents.replacingOccurrences(of: "{auto_play}", with: "true")
                contents = contents.replacingOccurrences(of: "{show_text}", with: "false")
                contents = contents.replacingOccurrences(of: "{show_captions}", with: "false")
                
                let baseUrl = URL(fileURLWithPath: filePath)
                
                m_FBWebView.loadHTMLString(contents as String, baseURL: baseUrl)
                
            
            }
            catch {
                print ("File HTML error")
            }
        
    }
   
    func onPlay()
    {
        m_FBWebView.evaluateJavaScript("javascript:playVideo()", completionHandler: nil)
    }
    
    
    func onPause(_ sender:UIButton)
    {
        m_FBWebView.evaluateJavaScript("javascript:pauseVideo()", completionHandler: nil)
        
        
    }
        
    
}
