//
//  ExpensesRecordTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/6.
//  Copyright © 2020 greatsoft. All rights reserved.
//////////////////////////////////////////////////////////

import UIKit


class ExpensesRecordTableViewCell: UITableViewCell {
    
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
    
    
    func LoadData(dictionary:NSDictionary)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 0.0;
        
        m_labelTitle  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 40));
        
        m_labelTitle.font =  UIFont.systemFont(ofSize: 25.0)
        m_labelTitle.text = (dictionary.object(forKey: "ChangeName") as! String);
        //m_labelTitle.textAlignment = .center
        
        iCurPos += 50;
        
        let strReceiptNumber  = dictionary.object(forKey: "ReceiptNumber") as! String;
        let strBrandName = dictionary.object(forKey: "BrandName") as! String;
        
        m_labelInvoiceNumber  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelInvoiceNumber.text   = ""
        
        if(strReceiptNumber.count > 0)
        {
            m_labelInvoiceNumber.text  = "\(strReceiptNumber)(\(strBrandName))"
        }
        
        
        iCurPos += 40;
        
        m_labelDate  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        
        m_labelDate.text  = (dictionary.object(forKey: "ChangeDate") as! String);
        
        m_labelPoint  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 110, y: iCurPos, width: 100, height: 20));
        
        
        m_labelPoint.font =  UIFont.systemFont(ofSize: 25.0)
        m_labelPoint.textAlignment = .right;
        let strPoint  = (dictionary.object(forKey: "ChangePoint") as! String);
        let iPoint = Int(strPoint)
        if(iPoint!>=0)
        {
            m_labelPoint.textColor = UIColor.init(red: 0, green: 0x99/255.0, blue: 1, alpha: 1);
            m_labelPoint.text  = "+" + strPoint + "點"
        }else
        {
            m_labelPoint.textColor = UIColor.red;
            m_labelPoint.text  =  strPoint + "點"
        }
        
        self.contentView.addSubview(m_labelTitle);
        self.contentView.addSubview(m_labelInvoiceNumber);
        self.contentView.addSubview(m_labelDate);
        self.contentView.addSubview(m_labelPoint);
        
        
        iCurPos += 30
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ExpensesRecordTableViewCell.MainHeight = Int(iCurPos + 10);
        
        /*
        self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        */
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

