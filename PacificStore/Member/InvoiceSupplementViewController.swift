//
//  QRCodeScanViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/5/20.
//  Copyright © 2019 greatsoft. All rights reserved.
//////////////////////////////////////////////////////////
import UIKit
import AVFoundation
import MercariQRScanner


class InvoiceSupplementViewController:BaseViewController,AVCaptureMetadataOutputObjectsDelegate, QRScannerViewDelegate{
    
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        
    }
    
    
    
   
   

let labelBorderWidth = 2
let selectionBorderWidth:CGFloat = 5
let pointerSize:CGFloat = 20

    
let barcodeTypes = [
    AVMetadataObject.ObjectType.dataMatrix,
    AVMetadataObject.ObjectType.interleaved2of5,
    AVMetadataObject.ObjectType.itf14,
    AVMetadataObject.ObjectType.upce,
    AVMetadataObject.ObjectType.code39,
    AVMetadataObject.ObjectType.code39Mod43,
    AVMetadataObject.ObjectType.ean13,
    AVMetadataObject.ObjectType.ean8,
    AVMetadataObject.ObjectType.code93,
    AVMetadataObject.ObjectType.code128,
    AVMetadataObject.ObjectType.pdf417,
    AVMetadataObject.ObjectType.qr,
    AVMetadataObject.ObjectType.aztec
]

var session:AVCaptureSession?
var videoPreviewLayer:AVCaptureVideoPreviewLayer?
var selectionView:UIView?
    
    
// @IBOutlet weak var labelBarcodeResult: UILabel!
@IBOutlet var barcodeResultButton: UIBarButtonItem!
//@IBOutlet weak var barcodeToolbar: UIToolbar!
@IBOutlet weak var logoLabel: UILabel!

var   m_strID  = "";
var   m_bChanging = false;
var   m_iType = 0;
    
    
    
@IBOutlet weak var m_btnContinueScan: UIButton!
@IBOutlet weak var m_btnFillLight: UIButton!

var  m_continueScan = false;
var  m_bFillLight = false;
    
    
    
@IBOutlet weak  var   m_viewQrocde:UIView!
var qrScannerView: QRScannerView!
    
//MARK: Functions
override func viewDidLoad() {
    super.viewDidLoad()
    
    //Set capture device
    ConfigInfo.m_bChangeOfferStatus  = false;
    //toggleTorch(on: true)
    
    
    
//=========================================================================================///
    qrScannerView = QRScannerView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: m_viewQrocde.frame.height));
    
    m_viewQrocde.addSubview(qrScannerView);
    
          
}
    
    
    /*
    // MARK: - Outlets
    @IBOutlet var qrScannerView: QRScannerView! {
        didSet {
            qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        }
    }
    */
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrScannerView.stopRunning()
    }

    override func viewDidLayoutSubviews() {
        ///qrScannerView.frame = CGRect(x: 0, y: 0, width: m_viewQrocde.frame.width, height: m_viewQrocde.frame.height);
       
    }
    
   
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        qrScannerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: m_viewQrocde.frame.height);
        
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        
        qrScannerView.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
       // qrScannerView.frame = CGRect(x: 0, y: 0, width: m_viewQrocde.frame.width, height: m_viewQrocde.frame.height);
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(didInvoiceMakeupResult), name:NSNotification.Name(rawValue: kDCInvoiceMakeup), object: nil)
        self.SetTitleColor();
        
   }
    
   //Validates the URL to see if it is opennable with any application on the device
   func validateURL(_ url:String)->Bool{
       if let testURL = URL(string: url){
           return UIApplication.shared.canOpenURL(testURL)
       }
       return false
   }
    
    
    @IBAction func onMemberCardInfo(_ sender: AnyObject) {
        
        let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
        
        let  btParkingInfo
            = StoryBoard.instantiateViewController(withIdentifier: "MemberCode");                self.navigationController?.pushViewController(btParkingInfo, animated: true)
    }
    
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
  
    
    @objc func didInvoiceMakeupResult(notification: NSNotification){
        //do stuff
        let userInfo = notification.userInfo as NSDictionary?;
        let strSuccess = userInfo?.object(forKey: "isSuccess") as! NSString
        
        MBProgressHUDObjC.hideHUD(for: self.view, animated: true)
        
        if(strSuccess.isEqual(to: "YES"))
        {
            let  dic   =  userInfo?.object(forKey: "data") as! NSDictionary;
            let  strCode = dic.object(forKey: "ReturnCode") as! String;
            
            
            if(Int(strCode) == 0)
            {
                m_bChanging = false;
                
                ShowQrcodeSuccessAlertControl(strTitle: "補登成功", Message: "發票補登成功");
                
            }else
            {
                
                let dicResult  = dic.object(forKey: "Data") as! NSDictionary;
                var strResultMessage  = "補登失敗";
                if(!(dicResult.object(forKey: "res_msg") is NSNull))
                {
                    strResultMessage  = dicResult.object(forKey: "res_msg") as! String;
                }
                
                ShowQrcodeAlertControl(strTitle: "補登失敗", Message:  strResultMessage);
                
                m_bChanging = false;                               
            }
            
            
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
            m_bChanging = false;
        }
    }
    
    
    func isNsnullOrNil(object : AnyObject?) -> Bool
    {
        if (object is NSNull) || (object == nil)
        {
            return true
        }
        else
        {
            return false
        }
    }

    
    
    func ShowQrcodeSuccessAlertControl(strTitle:String , Message:String)
    {
        let alert = UIAlertController(title: strTitle, message: Message, preferredStyle: .alert)
        
        let actionOK  = UIAlertAction(title: "確定", style: .default) { [self] (UIAlertAction) in
            if(!self.m_continueScan)
            {
                
                self.navigationController?.popViewController(animated: true);
                
            }else
            {
                qrScannerView.rescan();
            }
        }
        
        alert.addAction(actionOK)
        
        self.present(alert, animated: true)
    }
    
    
    func ShowQrcodeAlertControl(strTitle:String ,Message:String)
    {
        let alert = UIAlertController(title: strTitle, message: Message, preferredStyle: .alert)
        
        let actionOK  = UIAlertAction(title: "確定", style: .default) { [self] (UIAlertAction) in
            qrScannerView.rescan();
        }
        
        alert.addAction(actionOK)
        
        self.present(alert, animated: true)
    }
    
    
    
    
    
    @IBAction func onContinueScan(_ sender:UIButton)
    {
        m_continueScan  =  !m_continueScan;
       
        m_btnContinueScan.setBackgroundImage(UIImage(named: m_continueScan ? "continue_take_open" : "continue_take_close"), for: .normal)
       
        
    }
    
    //補光
    @IBAction func onFillLight(_ sender:UIButton)
    {
        m_bFillLight  = !m_bFillLight
        
        m_btnFillLight.setBackgroundImage( UIImage(named: m_bFillLight ? "continue_light_open" : "continue_light_close"), for: .normal)
        
        //toggleTorch(on: m_bFillLight ? true : false);
        
        qrScannerView.setTorchActive(isOn: m_bFillLight)
     
    }
    
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    
                    device.torchMode = .on
                    //try? device.setTorchModeOn(level: <#T##Float#>);
                    
                    
                    try? device.setTorchModeOn(level: 1.0)
                    
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        
        if(!m_bChanging)
        {
            m_bChanging = true;
            
            MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
            
            DCUpdater.shared()?.invoiceMakeup(ConfigInfo.m_strAccessToken, andInvoiceBarcode: code);
            
        }
        
    }
    
    
}



