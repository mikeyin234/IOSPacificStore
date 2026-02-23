//
//  BaseViewController.swift
//  MiddleCarSales
//
//  Created by greatsoft on 2018/8/9.
//  Copyright © 2018年 greatsoft. All rights reserved.
////////////////////////////////////////////////////////／
import UIKit
import WebKit



//HTTPS PROBLEM......
class MySessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Check if the challenge is for server trust
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                // Use this to trust the specific problematic server during testing
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            }
        }
        // Fall back to default handling for all other challenges
        completionHandler(.performDefaultHandling, nil)
    }
}



extension UIImageView {
    
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}



extension URL{
    
    static func initPercent(string:String) -> URL
    {
        let urlwithPercentEscapes = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url = URL.init(string: urlwithPercentEscapes!)
        return url!
    }
}


extension UINavigationController {
    
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        
        var vcs = viewControllers
        
        vcs[vcs.count - 1] = viewController
        
        setViewControllers(vcs, animated: animated)
    }
}


extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}




extension UIView{
    
    func setBackgroundImage(img: UIImage){
        
        UIGraphicsBeginImageContext(self.frame.size)
        img.draw(in: self.bounds)
        let patternImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.backgroundColor = UIColor(patternImage: patternImage)
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}


extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        // Swift 4.1 and below
        //self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}


extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確定", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y:locationOfTouchInLabel.y - textContainerOffset.y);
        
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}


extension UIImage {
    
    
    var isPortrait:  Bool    { return size.height > size.width }
    
    var isLandscape: Bool    { return size.width > size.height }
    
    var breadth:     CGFloat { return min(size.width, size.height) }
    
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    
    var circleMasked: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        
        
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        
        
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
   
        func reSizeImage(reSize:CGSize)->UIImage {
            
            //UIGraphicsBeginImageContext(reSize);
            UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
            
            self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
            
            let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext();
            
            return reSizeImage;
        }
        
        /**
         *  等比率缩放
         */
        func scaleImage(scaleSize:CGFloat)->UIImage {
            
            let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
            
            return reSizeImage(reSize: reSize)
        }
    
}


extension String {
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()      
        dateFormatter.calendar = Calendar(identifier: .chinese)
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: self)

        return date

    }
    
    
}




class BaseViewController: UIViewController {
    
//=====================================================//
    var  TYPE_MAIN_HOME:Int32  = 2;
    var  TYPE_NEWS:Int32       = 3;
    var  TYPE_ONLIE_DM:Int32   = 4;
    var  TYPE_MEMBER:Int32     = 5;
    var  TYPE_VIDEO_VIEW:Int32 = 6;
    var  TYPE_GAME:Int32       = 7;
    var  TYPE_FOOD:Int32       = 8;
    
//=============================================//  
    var  TYPE_BRAND:Int32                   = 22;
    var  TYPE_CAR_PARING:Int32              = 23;
    var  TYPE_FACEBOOK:Int32                = 24;
    
    var  TYPE_MESSAGE:Int32                 = 50;
    var  TYPE_POINT_QUERY:Int32             = 51;
    var  TYPE_CHANGE_GIFT:Int32             = 52;
    var  TYPE_CONSUMPTION:Int32             = 53;
    
    
    var  TYPE_ALL_CHANGE:Int32              = 54;
    var  TYPE_EXCLUSIVE_OFFER:Int32         = 55;
    var  TYPE_MEMBER_EDIT:Int32             = 56;
    var  TYPE_PASSOWRD_CHANGE:Int32         = 57;
    var  TYPE_MEMBER_POLICE:Int32           = 58;
//======================================================//
    
    //@IBOutlet weak var m_labelTitle: UILabel!
    var m_viewBar:UIView!
    
//======================================================//
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*if(m_viewTitle != nil)
        {
            UIGraphicsBeginImageContext(self.m_viewTitle.frame.size)
            UIImage(named: "top_bar")?.draw(in:m_viewTitle.bounds)
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            m_viewTitle.backgroundColor = UIColor(patternImage:image);
        }*/
        
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
    
    func clearCache() {
        
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func  viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func  SetTitleColorExt(color:UIColor)
    {
        self.navigationController?.isNavigationBarHidden =  true
        
        UIApplication.shared.statusBarStyle = .lightContent
        //self.preferredStatusBarStyle = .lightContent
        
        if #available(iOS 13.0, *) {
            
            m_viewBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            
             m_viewBar.backgroundColor = color
            
             UIApplication.shared.keyWindow?.addSubview(m_viewBar)
            
        } else {
            
            UIApplication.shared.statusBarUIView?.backgroundColor = color
        }
    }
    
    
    
    func  SetTitleColor()
    {
         //self.navigationController?.isNavigationBarHidden =  true
        // UIApplication.shared.statusBarStyle = .lightContent
        //self.preferredStatusBarStyle = .lightContent
        if #available(iOS 13.0, *) {
            
           m_viewBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            
             m_viewBar.backgroundColor =  UIColor(red: 1, green: 0, blue:0, alpha: 1)
            
             UIApplication.shared.keyWindow?.addSubview(m_viewBar)
        } else {
            
            UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(red: 1, green: 0, blue:0, alpha: 1)
        }
    }
    
    func RemoveTitleBar()
    {   
        if(m_viewBar != nil)
        {
             m_viewBar.removeFromSuperview();
        }
       
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func  AddOnTouchClick(vTouch:UIView!,action:Selector?)
    {
        let tapNoInstallRecognizer = UITapGestureRecognizer.init(target: self, action: action)
        
        tapNoInstallRecognizer.numberOfTapsRequired = 1;
        
        vTouch.addGestureRecognizer(tapNoInstallRecognizer);
        vTouch.isUserInteractionEnabled = true;
    }
    
    
    func  AddOnDoubleTouchClick(vTouch:UIView!,action:Selector?)
       {
           let tapNoInstallRecognizer = UITapGestureRecognizer.init(target: self, action: action)
           
           tapNoInstallRecognizer.numberOfTapsRequired = 2;
           
           vTouch.addGestureRecognizer(tapNoInstallRecognizer);
           vTouch.isUserInteractionEnabled = true;
       }
    
    
    
    func AddLastabelToRed(labelText:UILabel)
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: labelText.text!)
        attributedString.setColorForText(textForAttribute: "*", withColor: UIColor.red)
        
        // set label Attribute
        labelText.attributedText = attributedString
    }
    
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage,strName:String) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        
        let filename = strName;
        let filepath = directoryPath.appending(filename)
        
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try chosenImage.pngData()?.write(to: url, options: .atomic)
            return String.init("/Documents/\(filename)")
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    
    
    func LoadImageFromDoc(strName:String)->UIImage!
    {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        
        let filename = strName;
        let filepath = directoryPath.appending(filename)
        
        let success = FileManager.default.fileExists(atPath: filepath);
        if(success)
        {
            return  UIImage(contentsOfFile: filepath)!;
        }
        return  nil;
    }
    
    
    func ShowAlertControl(Message:String)
    {
        let alert = UIAlertController(title: "系統資訊", message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        
        //qrScannerView.rescan();
        self.present(alert, animated: true)
        
    }
    
    func ShowAlertControlWithTitle(Message:String,strTitle:String)
    {        
        let alert = UIAlertController(title: strTitle, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func onHomeClick(_ sender:UIButton)
    {
        self.navigationController?.popToRootViewController(animated: true)
        
        //mike add at 22/04/26
        let  viewController  =  UIApplication.topViewController()  as!  ViewController;
        viewController.RefershMainPage();
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
           self.RemoveTitleBar();
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       if motion == .motionShake {
           
           if(UIApplication.topViewController() != nil)
           {
               if(!(UIApplication.topViewController()  is TradeCodeViewController) &&
                  !(UIApplication.topViewController()  is LoginViewController))
               {
                   let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                   if(ConfigInfo.m_bMemberLogin)
                   {
                       ConfigInfo.m_fDefaultBright = UIScreen.main.brightness;
                       
                       let  btPTradeCodeInfo
                           = StoryBoard.instantiateViewController(withIdentifier: "TradeCode");
                       self.navigationController?.pushViewController(btPTradeCodeInfo, animated: true)
                   }else
                   {
                       let  btPurchaseDevice  =  StoryBoard.instantiateViewController(withIdentifier: "Login");
                       self.navigationController?.pushViewController(btPurchaseDevice, animated: true)
                   }
               }
           }
       }
    }
    
    
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // 1. Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL string")
            completion(nil)
            return
        }
        
        
        let delegate = MySessionDelegate()
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        
        // 2. Use a URLSession data task to asynchronously fetch the data
        let task = session.dataTask(with: url) { (data, response, error) in
            // 3. Handle errors
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // 4. Check if data was received and create a UIImage
            if let data = data, let image = UIImage(data: data) {
                // 5. Call the completion handler with the image
                completion(image)
            } else {
                print("Error: Could not create image from data")
                completion(nil)
            }
        }
        
        // 6. Start the task
        task.resume()
    }
    
    
    // Example usage within a UIViewController (or similar UI context)
    func setImage(to imageView: UIImageView ,imageUrlString:String ) {        
        fetchImage(from: imageUrlString) { image in
            // IMPORTANT: Update UI on the main thread
            DispatchQueue.main.async { [weak imageView] in
                imageView?.image = image ?? UIImage(named: "placeholder") // Use a placeholder image if loading fails
            }
        }
    }
    
    
    func downloadImage(from url: URL) async throws -> UIImage {
        // Use try await to pause execution until the data is downloaded
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Check if the data can be converted to a UIImage
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "InvalidImageDataError", code: 0, userInfo: nil)
        }
        
        // Return the image
        return image
    }

    // Example usage in an async context, such as a Task or another async function:
    func loadImage() async {
        do {
            let imageURL = URL(string: "https://picsum.photos/200/300")!
            let image = try await downloadImage(from: imageURL)
            
            // Update UI on the main thread (UIKit updates must be on main)
            DispatchQueue.main.async {
                // e.g., self.imageView.image = image
                print("Image downloaded and set")
            }
        } catch {
            // Handle any errors during download or image creation
            print("Error downloading image: \(error)")
        }
    }
    
    
    
    
    
    
}


extension Date {
    var age: Int {
              
        let CardAge = Calendar.current.dateComponents([.year,.month,.day], from: self, to: Date())
        var year  = CardAge.year;
        
        if(CardAge.month! > 0 || CardAge.day!>0)
        {
            year =  year! +  1 ;
        }
        return year!;
    }
    
}




