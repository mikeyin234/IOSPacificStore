//
//  CarParkingViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/6.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import WebKit



class CarParkingViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet weak var mMapView: GMSMapView!
    var   m_PolicyWebView : WKWebView!
    @IBOutlet     weak var   m_ViewContent:UIView!;
    
    
    var   m_Location = CLLocationCoordinate2D();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("台中市豐原區復興路2號", completionHandler: {
            placemarks, error in
            if error != nil {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // 取得第一個座標
                let placemark = placemarks[0]
                
                let Camera = GMSCameraPosition(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!, zoom: 16)
                
                self.mMapView.camera = Camera;
                
                let market = GMSMarker()
                
                market.position = CLLocationCoordinate2D(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                
                self.m_Location  = market.position;
                
                market.map  = self.mMapView;
                
                market.title = "豐原太平洋百貨";
                market.snippet = "420台中市豐原區復興路2號";
                
                self.mMapView.isMyLocationEnabled  = true;
                
            }
        })
        
        self.clearCache();
        
     
        
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
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
    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func onMapClick(_ sender:UIButton)
    {
      
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(m_Location.latitude),\(m_Location.longitude)&directionsmode=driving") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
  
    
    //===================================================//
    func InitWebView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        var   poliwebFrame = m_ViewContent.frame;
        poliwebFrame.origin.y = 0;
        
        m_PolicyWebView = WKWebView(frame:   poliwebFrame, configuration: webConfiguration)
        
        m_PolicyWebView.uiDelegate = self
        m_PolicyWebView.navigationDelegate = self
        
        m_ViewContent.addSubview(m_PolicyWebView)
        
    }
    
    
    override func  viewDidAppear(_ animated: Bool) {
        
        InitWebView();
        
        // Do any additional setup after loading the view.
        let myURL = URL(string:ConfigInfo.PARKING_SITE)
        let myRequest = URLRequest(url: myURL!)
        m_PolicyWebView.load(myRequest)
        
        self.startTimeTick();
        
    }
    
    
   override  func viewWillDisappear(_ animated: Bool) {
       //================================================================================//
       self.stopTimeTick();
       ///////////////////////////////////////////////////////////////////////
       //停車資訊
       DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_CAR_PARING), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
       
   }
    
    
}
