//
//  QRCodeScanViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/5/20.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit
import AVFoundation


class QRCodeScanViewController:BaseViewController,AVCaptureMetadataOutputObjectsDelegate{   //MARK: Properties

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


@IBOutlet var  m_ContentView:UIView!
    
// @IBOutlet weak var labelBarcodeResult: UILabel!
@IBOutlet var barcodeResultButton: UIBarButtonItem!
//@IBOutlet weak var barcodeToolbar: UIToolbar!
@IBOutlet weak var logoLabel: UILabel!

var   m_strID  = "";
var   m_bChanging = false;
var   m_iType = 0;
    
    
//MARK: Functions
override func viewDidLoad() {
    super.viewDidLoad()
    
    //Set capture device
    
    
    ConfigInfo.m_bChangeOfferStatus  = false;
    
    
}

    override func viewDidLayoutSubviews() {
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        
        var error:NSError? = nil    //Possible Error to be thrown
        let captureDeviceInput:AnyObject?
        
        //Tries to get device input, shows alert if theres an error
        do{
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice!) as AVCaptureDeviceInput
        } catch let someError as NSError{
            error = someError   //get Error to throw
            captureDeviceInput = nil
        }
        
        //Shows Error if failure to get Input
        if error != nil{
            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
            return
        }
        
        //Creates capture session and adds input
        session = AVCaptureSession()
        session?.addInput(captureDeviceInput as! AVCaptureInput)
        
        //Get metadata output from session
        let metadataOutput = AVCaptureMetadataOutput()
        session?.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = barcodeTypes
        
        
        
        //Add the video preview layer to the main view
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
        videoPreviewLayer?.frame = self.m_ContentView.bounds
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.m_ContentView.layer.addSublayer(videoPreviewLayer!)
        
        
        //Run session
        session?.startRunning()
        
        //creates the selection box
        selectionView = UIView()
        
        selectionView?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        selectionView?.layer.borderColor = UIColor.red.cgColor
        selectionView?.layer.borderWidth = selectionBorderWidth
        selectionView?.frame = CGRect(x: 0,y: 0, width: pointerSize , height: pointerSize)
        
        selectionView?.center = CGPoint(x: self.m_ContentView.bounds.midX, y: self.m_ContentView.bounds.midY)
        
        self.m_ContentView.addSubview(selectionView!)
        self.m_ContentView.bringSubviewToFront(selectionView!)
        
        
    }
    
//Validates the URL to see if it is opennable with any application on the device
func validateURL(_ url:String)->Bool{
    if let testURL = URL(string: url){
        return UIApplication.shared.canOpenURL(testURL)
    }
    return false
}

//resets view to default
func resetToDefault(){
    
    selectionView?.frame = CGRect(x: 0,y: 0, width: pointerSize , height: pointerSize)
    
    selectionView?.center = CGPoint(x: self.m_ContentView.bounds.midX, y: self.m_ContentView.bounds.midY)
    
    selectionView?.layer.borderColor = UIColor.red.cgColor
    
    //Reset result button

}
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            self.resetToDefault()
            return
        }
        
        //Get each metadataObject and check if it is a barcode type
        let metadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        for barcodeType in barcodeTypes{
            if metadataMachineReadableCodeObject.type == barcodeType {
                
                let barcode = videoPreviewLayer?.transformedMetadataObject(for: metadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                
                //Set selection to the barcode's bounds
                selectionView?.frame = barcode.bounds;
                selectionView?.layer.borderColor = UIColor.green.cgColor
                
                //Sets the result button text to the value of the bar code object
                if metadataMachineReadableCodeObject.stringValue != nil {
                    let type = metadataMachineReadableCodeObject.type.rawValue.components(separatedBy: ".").last
                    
                    let strCode  = metadataMachineReadableCodeObject.stringValue!
                    //執行兌換......
                    if(!m_bChanging)
                    {
                        m_bChanging = true;
                        MBProgressHUDObjC.showHUDAdded(to: self.view, animated: true)
                        if(m_iType == 1)
                        {
                            DCUpdater.shared()?.chenageExclusiveOffer(ConfigInfo.m_strAccessToken,
                                                                                             andCode: strCode,
                                                                                             andID: m_strID);
                        }else  if(m_iType == 10)
                        {
                            DCUpdater.shared()?.changeGameECCuspon(ConfigInfo.m_strAccessToken,
                                                                                                                       andCode: strCode,
                                                                                                                       andID: m_strID);
                        }
                        
                    }
                }
            }
    }
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
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector:#selector(didGetBrandDetailResult), name:NSNotification.Name(rawValue: kDCChangeExclusiveOffer), object: nil)
        
        self.SetTitleColor();
    }
    
    @objc func didGetBrandDetailResult(notification: NSNotification){
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
                ConfigInfo.m_bChangeOfferStatus  = true;
                
               CuponDetailViewController.m_strUseDate = dic.object(forKey: "UseDate") as! String;
                
                self.navigationController?.popViewController(animated: true);               
            }else
            {
                ShowAlertControl(Message:  dic.object(forKey: "ReturnMessage") as! String);
                m_bChanging = false;
            }
        }else
        {
            ShowAlertControl(Message: "您的網路連線不通，請檢查您的網路狀態，或至網路通暢的環境下使用");
            m_bChanging = false;
        }
        
       
    }
    
    
    
    
}
