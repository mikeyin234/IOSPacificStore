//
//  ImageTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/2/23.
//  Copyright © 2019 greatsoft. All rights reserved.
//
import UIKit

class BuildTableViewCell: UITableViewCell {
    
    static  let MainHeight =  60;
    
    let m_imageView = UIImageView();
    let m_labelText = UILabel();
    
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.m_imageView.frame =  CGRect(x: 10, y: 0, width: BuildTableViewCell.MainHeight, height: BuildTableViewCell.MainHeight);
        
        self.addSubview(m_imageView);
        
        m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        
        m_labelText.frame = CGRect(x: BuildTableViewCell.MainHeight + 25, y: 0, width: Int(UIScreen.main.bounds.width)-BuildTableViewCell.MainHeight, height: BuildTableViewCell.MainHeight);
        
        self.addSubview(m_labelText)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
