//
//  PointGiftTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/4/2.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class PointGiftTableViewCell: UITableViewCell {
    
    static  var MainHeight =  120;
    
    static  var MainImageHeight =  220;
    
    let m_imageView = UIImageView()
    
    let  m_labelTitle  = UILabel();
    let  m_labelDetail  = UILabel();
    
    var  m_iSpace =  3;
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    func LoadData(image:UIImage)
    {
        self.m_imageView.frame =  CGRect(x: 3, y: 10, width: 120, height: 100);
        self.addSubview(m_imageView)
        
        
        
        self.m_labelTitle.frame = CGRect(x: 130, y: 10, width: UIScreen.main.bounds.width-130, height: 60);
        self.m_labelTitle.font  = UIFont.systemFont(ofSize: 25.0);
        
        
       
        
        m_labelTitle.numberOfLines = 2;
        m_labelTitle.lineBreakMode = .byWordWrapping;
        self.addSubview(m_labelTitle)
        
        
        self.m_labelDetail.font  = UIFont.systemFont(ofSize: 14.0);
        self.m_labelDetail.frame = CGRect(x: 130, y: 80, width: UIScreen.main.bounds.width-130, height: 20);
        self.addSubview(m_labelDetail)
        
        m_labelTitle.text  = "2020年度吉利卡點數贈品兌換";
        m_labelDetail.text  = "活動期限：2020/07/01 - 2020/08/01";
        
        m_imageView.image = image
        m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        
        
        
    }
    
    
    func LoadData(image:UIImage,strTitle:String,strDate:String)
    {
        self.m_imageView.frame =  CGRect(x: 3, y: 20, width: 70, height: 70);
        self.addSubview(m_imageView)
        
        self.m_labelTitle.frame = CGRect(x: 80, y: 10, width: UIScreen.main.bounds.width-80, height: 60);
        self.m_labelTitle.font  = UIFont.systemFont(ofSize: 25.0);
        
        m_labelTitle.numberOfLines = 2;
        m_labelTitle.lineBreakMode = .byWordWrapping;
        self.addSubview(m_labelTitle)
        
        self.m_labelDetail.font  = UIFont.systemFont(ofSize: 14.0);
        self.m_labelDetail.frame = CGRect(x: 80, y: 80, width: UIScreen.main.bounds.width-80, height: 20);
        self.addSubview(m_labelDetail)
        
        m_labelTitle.text  = strTitle;
        m_labelDetail.text  = strDate;
        
        m_imageView.image = image
        m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        
        
        
    }
    
    
    func LoadDataPointGift(image:UIImage!,strTitle:String,strDate:String)
    {
        self.m_imageView.frame =  CGRect(x: 3, y: 10, width: 120, height: 100);
        self.addSubview(m_imageView)
        
        self.m_labelTitle.frame = CGRect(x: 130, y: 10, width: UIScreen.main.bounds.width-130, height: 60);
        self.m_labelTitle.font  = UIFont.systemFont(ofSize: 25.0);
        
        m_labelTitle.numberOfLines = 2;
        m_labelTitle.lineBreakMode = .byWordWrapping;
        self.addSubview(m_labelTitle)
        
        self.m_labelDetail.font  = UIFont.systemFont(ofSize: 14.0);
        self.m_labelDetail.frame = CGRect(x: 130, y: 80, width: UIScreen.main.bounds.width-130, height: 20);
        self.addSubview(m_labelDetail)
        
        m_labelTitle.text  = strTitle;
        m_labelDetail.text  = strDate;
        
        m_imageView.image = image
        m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        
        
        
    }
    
    
    
    func LoadDataOnlyImage(image:UIImage)
    {
        
        let iWidth  = UIScreen.main.bounds.width;
        let iHeight  = iWidth / ConfigInfo.m_fImageRatio;
        
        //add at  2021  05  03
        PointGiftTableViewCell.MainImageHeight  = Int(iHeight + 10);
        
        self.m_imageView.frame =  CGRect(x: 3, y: 10, width: Int(UIScreen.main.bounds.width)-20, height: PointGiftTableViewCell.MainImageHeight - 10 );
        
        
        self.addSubview(m_imageView)
        
        m_imageView.image = image
        m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
                        
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
