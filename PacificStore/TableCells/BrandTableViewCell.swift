//
//  BrandTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2019/3/5.
//  Copyright © 2019 greatsoft. All rights reserved.
//

import UIKit

class BrandTableViewCell: UITableViewCell {

    static  let MainHeight =  150;
    let m_imageView = UIImageView();
    let m_labelText = UILabel();
    
    var m_bisLeft = true;
    
    
    func Relocation()
    {
        if(m_bisLeft)
        {
            self.m_imageView.frame =  CGRect(x: 15, y: 0, width: BrandTableViewCell.MainHeight, height:
                BrandTableViewCell.MainHeight);
            
            
             m_labelText.frame = CGRect(x: BrandTableViewCell.MainHeight + 30, y: 0, width:Int(BrandTableViewCell.MainHeight-35), height: Int(BrandTableViewCell.MainHeight));
            
            
        }else
        {
            self.m_imageView.frame =  CGRect(x: Int(UIScreen.main.bounds.width)-BrandTableViewCell.MainHeight-15, y: 0, width: BrandTableViewCell.MainHeight, height: BrandTableViewCell.MainHeight);
            
            m_labelText.frame = CGRect(x: 15, y: 0, width: Int(UIScreen.main.bounds.width)-BrandTableViewCell.MainHeight-35, height: BrandTableViewCell.MainHeight);
        }
        
    }
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
            self.m_imageView.frame =  CGRect(x: 0, y: 0, width: BrandTableViewCell.MainHeight, height: BrandTableViewCell.MainHeight);
            
            self.addSubview(m_imageView);
            
            m_imageView.contentMode = UIView.ContentMode.scaleAspectFit;
            
            m_labelText.frame = CGRect(x: BrandTableViewCell.MainHeight + 15, y: 0, width: Int(UIScreen.main.bounds.width)-BrandTableViewCell.MainHeight, height: BrandTableViewCell.MainHeight);
        
                self.addSubview(m_labelText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
