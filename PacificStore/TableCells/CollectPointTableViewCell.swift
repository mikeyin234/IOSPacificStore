//
//  ExpensesRecordTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/6.
//  Copyright © 2020 greatsoft. All rights reserved.
//////////////////////////////////////////////////////////

import UIKit


class CollectPointTableViewCell: UITableViewCell {
    
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
        var iCurPos:CGFloat = 5.0;
        
        let strItemName  = dictionary.object(forKey: "process_code")
        let  m_labelItemName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 30));
        
        m_labelItemName.font =  UIFont.systemFont(ofSize: 20.0)
        
        m_labelItemName.text   = (strItemName as! String)
        var date = dictionary.object(forKey: "trans_date") as! String
        
        date.insert("/", at: date.index(date.startIndex, offsetBy: 4))
        date.insert("/", at: date.index(date.startIndex, offsetBy: 7))
        
        var time =  dictionary.object(forKey: "trans_time") as! String
        time.insert(":", at: date.index(date.startIndex, offsetBy: 2))
        
        let index = time.index(time.startIndex, offsetBy: 5)
        let timeCur = time.prefix(upTo: index) // Hello
        
        
        let m_labelDate1  = UILabel(frame:CGRect(x: UIScreen.main.bounds.width - 160, y: iCurPos, width: 150, height: 30));
        m_labelDate1.text   = "\(date) \(timeCur)"
        
        iCurPos += 30;
        
        
        
        self.contentView.addSubview(m_labelItemName);
        self.contentView.addSubview(m_labelDate1);
        
        let  MinusPoint  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        MinusPoint.text  = "異動點數:\(dictionary.object(forKey: "wallet_amt") as! Int64)點";
        self.contentView.addSubview(MinusPoint);
        iCurPos += 30
        
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        
        CollectPointTableViewCell.MainHeight = Int(iCurPos + 10);
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

