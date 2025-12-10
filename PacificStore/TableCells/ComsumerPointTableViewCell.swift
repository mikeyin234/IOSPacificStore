//
//  ExpensesRecordTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/6.
//  Copyright © 2020 greatsoft. All rights reserved.
//////////////////////////////////////////////////////////

import UIKit


class ComsumerPointTableViewCell: UITableViewCell {
    
    static  var MainHeight =  220;
    
//==============================================//
    var m_labelTitle:UILabel!
    var m_labelInvoiceNumber:UILabel!
    
    var m_labelDate:UILabel!
    var m_labelPoint:UILabel!
    
    
    var  m_iSpace =  3;
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    func LoadData(dictionary:NSDictionary , frameTable:CGRect)
    {
        self.frame = CGRect(x: self.frame.origin.x,
                            y: self.frame.origin.y,
                            width: frameTable.width, height: self.frame.height);
        
        let LeftSpace:CGFloat = 20.0;
        var iCurPos:CGFloat = 5.0;
        
        let dateEnd  = dictionary.object(forKey: "exp_date_end") as! String
        let strDateEnd = ConfigInfo.FormatDateStirng(strDate: dateEnd)
        
        let  m_labelItemName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: 150, height: 30));
        m_labelItemName.font =  UIFont.systemFont(ofSize: 20.0)
        m_labelItemName.text   = strDateEnd
        self.contentView.addSubview(m_labelItemName);
        
        
        let wallet_qty = dictionary.object(forKey: "wallet_qty") as! Int64
        
        let m_labelDate1  = UILabel(frame:CGRect(x: self.frame.width - 100,
                                                 y: iCurPos,
                                                 width: 100, height: 30));
        
        m_labelDate1.text   = "\(wallet_qty)"
        m_labelDate1.font =  UIFont.systemFont(ofSize: 30.0)
        m_labelDate1.textColor =  UIColor.red
        m_labelDate1.textAlignment = .right
        //m_labelDate1.sizeToFit();
        //m_labelDate1.autoresize();
        //m_labelDate1.frame.origin.x = self.frame.width - m_labelDate1.frame.width;
        self.contentView.addSubview(m_labelDate1);
        
        
        iCurPos += 40
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: self.frame.width, height: 1));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        
        ComsumerPointTableViewCell.MainHeight = Int(iCurPos + 10);
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

