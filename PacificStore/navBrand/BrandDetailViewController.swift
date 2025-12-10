//
//  BrandDetailViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/5.
//  Copyright © 2019 greatsoft. All rights reserved.
////////////////////////////////////////////////////////

import UIKit
import WebKit
//import YoutubePlayer_in_WKWebView
import youtube_ios_player_helper

class BrandDetailViewController: BaseViewController,WKUIDelegate,WKNavigationDelegate,YTPlayerViewDelegate {
    
    @IBOutlet weak var mlabelTitle: UILabel!
    @IBOutlet weak var mlabelSubTitle: UILabel!
    
    var  m_strTitle =  "";
    var  m_strSubTitle =  "";
    var   m_PolicyWebView : WKWebView!
    
    @IBOutlet     weak var   m_ViewContent:UIView!;
    var   m_strWebPage = "";
    
//===========================================================//
    var    m_strYoutubeFile  = "";
    @IBOutlet weak var m_playerView: YTPlayerView!
    
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        var   poliwebFrame = m_ViewContent.frame;
        
        webConfiguration.dataDetectorTypes = .phoneNumber
        
        m_PolicyWebView  = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: poliwebFrame.size.height), configuration: webConfiguration);
        
        m_PolicyWebView.uiDelegate = self
        m_PolicyWebView.navigationDelegate  = self;
        
        m_ViewContent.addSubview(m_PolicyWebView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(m_strTitle.count > 12)
        {
            m_strTitle = String(m_strTitle.prefix(12));
        }
        mlabelTitle.text  = m_strTitle;
        mlabelSubTitle.text  = m_strSubTitle;
        
        self.clearCache();
        
        if(m_strYoutubeFile.count == 0)  //沒有影片
              {
                  m_playerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
              }else
              {
                 //m_strYoutubeFile  = "2wD-jRLP9yU";
                 m_playerView.load(withVideoId: m_strYoutubeFile, playerVars: ["controls" : 1,"playsinline" : 1,"modestbranding" : 1,"fs" : 1,"rel" : 0,"origin":"http://www.youtube.com"])
                  
                  
                 m_playerView.delegate =  self;
                
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

    
    @IBAction func onBackClick(_ sender:UIButton)
    {        
        self.navigationController?.popViewController(animated: true);
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
         self.SetTitleColor();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        InitWebView();
        
        // Do any additional setup after loading the view.
        let myURL = URL(string:m_strWebPage)
        let myRequest = URLRequest(url: myURL!)
        m_PolicyWebView.load(myRequest)
    }
    
   
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "tel" {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
                        
            UIApplication.shared.openURL(navigationAction.request.url!)
            
        }
        return nil
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
         if(m_strYoutubeFile.count > 0)
         {
            m_playerView.pauseVideo();
         }
         
         RemoveTitleBar();
        
    }
    
    
        func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
              self.m_playerView.playVideo();
        }
    
    
      
          
          func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
           
              if(state == .playing)
              {
                   m_playerView.isHidden = false;
              }else if(state == .ended)
              {
                 
                m_playerView.seek(toSeconds: 1, allowSeekAhead: true)
                m_playerView.pauseVideo();
                
                
              }else if(state == .unstarted)
              {
                  
              }
          }
       
    
    
}
