//
//  MainHScrollTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/2/23.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
//import YoutubePlayer_in_WKWebView
import youtube_ios_player_helper

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}


class MainHScrollTableViewCell: UITableViewCell,UIScrollViewDelegate {
    
    let m_scrollView = UIScrollView()
    let  mPageControl = UIPageControl();
    
    
    static  var MainHeight =  220;
    var  m_iSpace =  3;
    var  m_iIndex = 0;
    var  m_timer:Timer!;
    var  m_imageBigMain:[NSDictionary] =  [];
    var  m_imageCache  = NSMutableDictionary();
    
    var  m_player : AVPlayer?
    
    var  m_viewVideo:UIView!
    var  m_ParentViewController:BaseViewController!;
    var  m_strYoutubeID  = "";
    var  m_dirVideos  =  NSMutableDictionary();
    
    
    var  m_iInterval =   3;   //
    var  m_TounchAD  = false;
    
    private var start_: TimeInterval = 0.0;
    private var end_: TimeInterval = 0.0;
    
    
    public func startTimeTick() {
              start_ = NSDate().timeIntervalSince1970;
          }

    public func stopTimeTick() {
              end_ = NSDate().timeIntervalSince1970;
          }
    
    
    public func durationSeconds() -> TimeInterval {
               return end_ - start_;
    }
    
    
    func RemovePlayer()
    {
        if(m_viewVideo != nil)
        {
            self.m_viewVideo.removeFromSuperview();
            m_player?.pause();
            m_viewVideo  = nil;
        }
    }
    
    
    func LoadPlayer(strYoutubeID:String)
    {
        self.stop();
        
        StarPlayYoutube(identifier:strYoutubeID);
        
    }
    
    @objc func tapHandler(_ sender: UIGestureRecognizerDelegate) {
        
        //LoadPlayer();
        //RemovePlayer();
        
        self.stop();
        
        StarPlayYoutube(identifier:m_strYoutubeID);
        
        
    }
    
    @objc func didDoubleTap(_ sender: UIGestureRecognizerDelegate) {
        
    }
    
    func StarPlayYoutube(identifier:String)
    {
        //YTPlayerView.load(T##self: YTPlayerView##YTPlayerView);
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btSubNavBrandMain
            = StoryBoard.instantiateViewController(withIdentifier: "Youtube") as! WKYoutubeViewController;
        
        btSubNavBrandMain.m_strVideoID = identifier;
        
    m_ParentViewController.navigationController!.pushViewController(btSubNavBrandMain, animated: true)
        
    }
    
    @objc func moviePlayerPlayBackDidFinish(notification: NSNotification)
    {
        print("moviePlayerPlayBackDidFinish")
        //self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    
    func play() {
        m_player?.play()
    }
    
    
    func stop() {
        m_player?.pause()
    }
    
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        MainHScrollTableViewCell.MainHeight =  Int(650 *  (UIScreen.main.bounds.width)/1080) + m_iSpace;
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.m_scrollView.frame =  CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: MainHScrollTableViewCell.MainHeight - m_iSpace);
        
        
        ///self.m_scrollView.panGestureRecognizer.delaysTouchesBegan = true
        
        
       
        
       
       
       
        
        m_scrollView.isPagingEnabled = true
        m_scrollView.delegate = self
        m_scrollView.showsHorizontalScrollIndicator = false;
        m_scrollView.isUserInteractionEnabled = true;
        m_scrollView.isScrollEnabled  = true;
        
        self.contentView.addSubview(m_scrollView);
        
        mPageControl.frame =  CGRect(x: 0, y: MainHScrollTableViewCell.MainHeight - 37, width: Int(UIScreen.main.bounds.width), height: 37);
        
        // mPageControl.frame =  CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 37);
        
        mPageControl.currentPageIndicatorTintColor = UIColor(red: 211/255.0, green: 18/255.0, blue: 119/255.0, alpha: 1)
        
        self.contentView.addSubview(mPageControl)
        
        
        
        
        //////////////////////////////////////////////////////////////////////////////
        //======修改這邊.......
        m_timer = Timer.scheduledTimer(timeInterval: TimeInterval(m_iInterval), target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
        
    }
    
    
    
    func ResetTimer(interval:Int)
    {
        m_timer.invalidate();
        
        m_iInterval  = interval;
        
        startTimeTick();
        
        m_timer = Timer.scheduledTimer(timeInterval: TimeInterval(m_iInterval), target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    
    func downloaded(from url: URL, iIndex:Int) {
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard
                
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                               let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                               let data = data, error == nil,
                               let image = UIImage(data: data)
                   else { return }
            
            
               DispatchQueue.main.async() { [weak self] in
                   //self?.image = image
                self!.m_imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                self!.AddImageToScrollView(image: image,iIndex: iIndex);
                
               }
           }.resume()
       }
    
    
    
    func LoadData(dataArray:[NSDictionary])
    {
        var iIndex   = 0
        m_imageBigMain.removeAll();
        
        ////////////////////////////////////////////
        ///add at 2022  05  05
        let subviews = self.m_scrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
        if(dataArray.count == 0)
        {
            return;
        }
        
        for dir in dataArray
        {
            
            let strImageName  = dir.object(forKey: "ImageName") as! String
            
            let url = URL.initPercent(string: strImageName);
            //let url = URL(string:strImageName);
            
            let iUploadType = Int32(dir.object(forKey: "UploadType") as! String)
            
            if  let cachedImage = m_imageCache.object(forKey: url.absoluteString as NSString)
            {
                
                AddImageToScrollView(image: cachedImage as! UIImage,iIndex: iIndex);
                
            }else
            {
                    //var image:UIImage! = nil;
                    if(iUploadType == 0 || iUploadType == 2)
                    {
                        self.downloaded(from: url,iIndex: iIndex);
                    }else  if(iUploadType == 1)
                    {
                        let strYoutubeID = dir.object(forKey:"YoutubeID") as! String
                        ////////////////////////////////////////////////////////////
                        //MP4 檔案路徑
                        let strURL = dir.object(forKey: "ImageName") as! String
                        
                        AddVideoToScrollView(strURL: strURL, strYoutubeID: strYoutubeID, iIndex: iIndex)                        
                    }/*else  if(iUploadType == 2)
                    {
                        let strYoutubeID = dir.object(forKey:"YoutubeID") as! String                                                                        
                        AddFBVideoToScrollView(strFBURL: strYoutubeID, iIndex: iIndex)
                   }*/
            }
            iIndex += 1;
            m_imageBigMain.append(dir);
        }
        
        
        
        mPageControl.numberOfPages  = dataArray.count;
        
        //let width = CGFloat(mPageControl.numberOfPages - 1) * 16 + 7
        //mPageControl.frame.size.width = width
        
        mPageControl.frame.origin.x  = (UIScreen.main.bounds.width - mPageControl.frame.size.width)/2;
        
        //mPageControl.backgroundColor = UIColor.black;
        
        ResizeImageView();
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func AddImageToScrollView(image:UIImage,iIndex:Int)
    {        
             //put your code here
             let iLeft = CGFloat(iIndex) * UIScreen.main.bounds.width;
             
             let imageView = UIImageView.init(frame: CGRect(x: iLeft, y: 0, width: UIScreen.main.bounds.width, height: self.m_scrollView.frame.size.height))
        
             imageView.image = image
        
             imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        
             imageView.tag = iIndex;
        
             self.m_scrollView.addSubview(imageView);
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    //
    //
    func AddFBVideoToScrollView(strFBURL:String, iIndex:Int)
       {
                    //put your code here
               
                    let iLeft = CGFloat(iIndex) * UIScreen.main.bounds.width;
           
           
                    let viewVideo = UIView(frame:  CGRect(x: iLeft, y: 0, width: UIScreen.main.bounds.width, height:       self.m_scrollView.frame.size.height));
                    //viewVideo.backgroundColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
           
                    let m_FBPlayer = FBPlayer();
           
                    let    fbWebView  = WKWebView(frame: CGRect(x: iLeft, y: 0, width: UIScreen.main.bounds.width, height:       self.m_scrollView.frame.size.height), configuration: WKWebViewConfiguration())
           
                    fbWebView.backgroundColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    
                    //fbWebView.isUserInteractionEnabled  = true;
                    //fbWebView.isOpaque  = true;
                    m_FBPlayer.LoadHtmlFile(FBWebView: fbWebView, video_url: strFBURL);
           
                    self.m_scrollView.addSubview(fbWebView);
                    self.m_scrollView.addSubview(viewVideo);
       }
    
    
    ////////////////////////////////////////////////////////////////////////
    //
    //
    func AddVideoToScrollView(strURL:String, strYoutubeID:String, iIndex:Int)
       {
                //put your code here
                if let url = URL(string: strURL)
                {
                    //2. Create AVPlayer object
                    let asset = AVAsset(url: url)
                    let playerItem = AVPlayerItem(asset: asset)
                    
                    let player = AVPlayer(playerItem: playerItem)
                    let iLeft = CGFloat(iIndex) * UIScreen.main.bounds.width;
                    let viewVideo = UIView(frame:  CGRect(x: iLeft, y: 0, width: UIScreen.main.bounds.width, height:       self.m_scrollView.frame.size.height));
                    
                    viewVideo.backgroundColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    
                    //3. Create AVPlayerLayer object
                    player.isMuted = true;
                    let playerLayer = AVPlayerLayer(player: player)
                    
                    playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:       self.m_scrollView.frame.size.height)
                    
                    playerLayer.videoGravity = .resizeAspect
                    
                    //4. Add playerLayer to view's layer
                    viewVideo.layer.addSublayer(playerLayer)
                    
                    self.m_scrollView.addSubview(viewVideo);
                    
                    m_dirVideos.setValue(player, forKey: "\(iIndex)")
                   // self.m_scrollView.insertSubview(imageView, aboveSubview: viewVideo)
                    
                }
                                                   
       }
    
    
    
    
    
    func ResizeImageView()
    {
        let fWidth  =  UIScreen.main.bounds.width * CGFloat(m_imageBigMain.count);
        
        self.m_scrollView.contentSize = CGSize(width: fWidth, height: self.m_scrollView.frame.size.height)
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         
         if scrollView.isEqual(m_scrollView) {
             
         let width = UIScreen.main.bounds.width
         let currentPage:Int  = Int(((scrollView.contentOffset.x - width / 2) / width) + 1)
             
             
         mPageControl.currentPage = currentPage;
         scrollView.tag = currentPage;
             
         switch scrollView.panGestureRecognizer.state {
         case .began:
         // User began dragging
         m_TounchAD  = true;
         print("began")
             break;
         case .changed:
         // User is currently dragging the scroll view
         print("changed")
         PlayVideo(index: currentPage);
             break;
         case .possible:
             //print("possible")
             if(m_TounchAD)
             {
                 self.m_iIndex = currentPage + 1;
                 m_TounchAD  = false;
             }
             break;
         default:
         break
         }
             
        }
    }
    
    
//====================================================//
    func PlayVideo(index:Int)
    {
        let player = m_dirVideos.object(forKey: "\(index)");
        if(player != nil)
        {
             if(self.m_player != nil)
             {
                self.m_player?.pause();                
             }
             self.m_player = (player as! AVPlayer)
            
             self.m_player!.seek(to: CMTimeMake(value: 0, timescale: 1));
             self.m_player!.play();
            
        }else
        {
            if(self.m_player != nil)
            {
                self.m_player?.pause();
                //self.m_player!.play();
            }
        }
    }
    
    @objc func updateTimer() {
        
        if(m_TounchAD)
        {
            return;
        }
        
        self.stopTimeTick();
        print("duration = \(self.durationSeconds())\n" );
        
        if(m_player != nil)
        {
            if ((m_player!.rate != 0) && (m_player?.error == nil)) {
                // player is playing
                return;
            }
        }
        
        
        //////////////////////////////////////////////
        // move  11 /05
        if(m_iIndex >= m_imageBigMain.count)
        {
            m_iIndex = 0;
        }
        
        //m_timer.invalidate();
        if(m_iIndex==0)
        {
             m_scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(self.m_iIndex), y: 0), animated: false)
            
            //Player Video
        }else
        {
           m_scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(self.m_iIndex), y: 0), animated: true)
        }
        
        PlayVideo(index: m_iIndex);
        
        
        self.m_iIndex += 1;
        
        self.startTimeTick();
        
    }
    
    
    
    
//==========================================================//
    func GetVideoImage(fileURL:URL)->UIImage!
    {
        let avAsset = AVURLAsset(url: fileURL, options: nil)
        let imageGenerator = AVAssetImageGenerator(asset: avAsset)
        imageGenerator.appliesPreferredTrackTransform = true
        var thumbnail: UIImage!
        
        do {
            thumbnail = try UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
        } catch let e as NSError {
            print("Error: \(e.localizedDescription)")
        }
        return thumbnail;
    }
    
}






