//
//  ImageTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/2/23.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    static  var MainHeight =  120;
    let m_imageView = UIImageView()
     var  m_iSpace =  3;
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        ////改成高度  400
        ImageTableViewCell.MainHeight  = Int(400 *  (UIScreen.main.bounds.width-6)/1080) + m_iSpace;
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
  
    
    
    func LoadData(image:UIImage)
    {
        self.m_imageView.frame =  CGRect(x: 3, y: 0, width: Int(UIScreen.main.bounds.width)-6, height: ImageTableViewCell.MainHeight - m_iSpace);
        
        self.addSubview(m_imageView)
        
        m_imageView.image = image
        m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
