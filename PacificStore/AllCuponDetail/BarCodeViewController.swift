//
//  BarCodeViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/3/7.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class BarCodeViewController: UIViewController {

    @IBOutlet var m_imageBarcode: UIImageView!
    
    var m_strBarcode  = "";
    
    var m_bIsUsed = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(!m_bIsUsed)
        {
            m_imageBarcode.image =  generateBarcode(from: m_strBarcode)
        }else
        {
            
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
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 4, y: 4)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    

}
