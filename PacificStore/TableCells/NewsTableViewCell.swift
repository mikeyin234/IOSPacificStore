//
//  NewsTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/30.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    static  let MainWidth  =  160;    
    static  let MainHeight =  120;
    
    let m_imageView = UIImageView();
    let m_labelText = UILabel();
    //let m_labelViewText = UILabel();
    
     let m_imagePlayView = UIImageView();
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.m_imageView.frame =  CGRect(x: 10, y: 0, width: NewsTableViewCell.MainHeight, height: NewsTableViewCell.MainHeight);
        
        self.addSubview(m_imageView);
        m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        
        
//==============================================================//
        let PlayViewWidth = 60;
        let  iHeight  = NewsTableViewCell.MainHeight;//(NewsTableViewCell.MainHeight) / 2;
        
        m_labelText.frame = CGRect(x: NewsTableViewCell.MainHeight + 25, y: 0, width: Int(UIScreen.main.bounds.width)-NewsTableViewCell.MainHeight - 25 - PlayViewWidth, height: iHeight);
        
        m_labelText.numberOfLines = 0;
        m_labelText.textAlignment  = .left
        m_labelText.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        
//=======================================================================================//
        self.addSubview(m_labelText)
        
        /*
        m_labelViewText.frame = CGRect(x: NewsTableViewCell.MainHeight + 25, y: iHeight, width: Int(UIScreen.main.bounds.width)-NewsTableViewCell.MainHeight-25-PlayViewWidth,
                                              height: 30);
               
        m_labelViewText.numberOfLines = 0;
        m_labelViewText.lineBreakMode = NSLineBreakMode.byWordWrapping;
        self.addSubview(m_labelViewText)
        */
        
//=========================================//
        m_imagePlayView.frame  = CGRect(x: Int(UIScreen.main.bounds.width)-PlayViewWidth, y: 30, width: PlayViewWidth, height: PlayViewWidth);
        self.addSubview(m_imagePlayView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
