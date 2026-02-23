//
//  FoodDetailViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/6.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import WebKit
//import YoutubePlayer_in_WKWebView;
import youtube_ios_player_helper


class FoodDetailViewController: BaseViewController,WKUIDelegate,WKNavigationDelegate,YTPlayerViewDelegate {
    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    @IBOutlet weak var m_labelTitle: UILabel!
    @IBOutlet weak var m_labelSubTitle: UILabel!
    var    m_WebPage  = "";
    
//=================================================//
    var    m_strTitle  = "";
    var    m_strSubTitle  = "";
    var    m_strYoutubeFile  = "";
    @IBOutlet weak var m_playerView: YTPlayerView!
    
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        var   poliwebFrame = m_ViewContent.frame;
        poliwebFrame.origin.y = 0;
        
        m_PolicyWebView  = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: poliwebFrame.size.height), configuration: WKWebViewConfiguration())
        
        m_PolicyWebView.uiDelegate = self
        m_PolicyWebView.navigationDelegate  = self
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    func webView(_ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
                        
            UIApplication.shared.openURL(navigationAction.request.url!)
            
        }
        return nil
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        m_labelTitle.text  = m_strTitle;
        m_labelSubTitle.text  = m_strSubTitle;
        self.clearCache();
        
        /// m_strYoutubeFile = "_xnEk-uUotQ";
        if(m_strYoutubeFile.count == 0)  //沒有影片
        {
            m_playerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
        }else
        {
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
        m_playerView.pauseVideo();
        
        self.navigationController?.popViewController(animated: true);
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(m_strYoutubeFile.count > 0)
        {
              m_playerView.pauseVideo();
        }
        
        RemoveTitleBar();
        
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.SetTitleColor();
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        InitWebView();
        // Do any additional setup after loading the view.
        let myURL = URL(string: m_WebPage)
        
        let myRequest = URLRequest(url: myURL!)
        m_PolicyWebView.load(myRequest)
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
