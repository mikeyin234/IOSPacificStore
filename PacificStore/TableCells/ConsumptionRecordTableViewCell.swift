//
//  ExpensesRecordTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2020/3/6.
//  Copyright © 2020 greatsoft. All rights reserved.
//////////////////////////////////////////////////////////

import UIKit


class ConsumptionRecordTableViewCell: UITableViewCell {
    
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
        
        m_labelTitle  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 30));
        
        m_labelTitle.font =  UIFont.systemFont(ofSize: 20.0)
        m_labelTitle.text = (dictionary.object(forKey: "process_code") as! String)
        iCurPos += 30;
        
        
        self.contentView.addSubview(m_labelTitle);
        
        
        
        
        
        let strItemName  = dictionary.object(forKey: "counter")
        let  m_labelItemName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2)-150 , height: 20));
        
        
        m_labelItemName.text   = (strItemName as! String)
        
        
        var date = dictionary.object(forKey: "trans_date") as! String
        
        date.insert("/", at: date.index(date.startIndex, offsetBy: 4))
        date.insert("/", at: date.index(date.startIndex, offsetBy: 7))
        
        var time =  dictionary.object(forKey: "trans_time") as! String
        time.insert(":", at: date.index(date.startIndex, offsetBy: 2))
        
        let index = time.index(time.startIndex, offsetBy: 5)
        let timeCur = time.prefix(upTo: index) // Hello
        
        
        let m_labelDate1  = UILabel(frame:CGRect(x: UIScreen.main.bounds.width - 160, y: iCurPos, width: 150, height: 20));
        m_labelDate1.text   = "\(date) \(timeCur)"
        
        
        
        
        m_labelItemName.numberOfLines = 0 ;
        m_labelItemName.lineBreakMode = .byWordWrapping;
        m_labelItemName.sizeToFit();
        m_labelItemName.autoresize();
        let iHeight = m_labelItemName.frame.height;
        
        
        self.contentView.addSubview(m_labelItemName);
        self.contentView.addSubview(m_labelDate1);
        
        
        iCurPos += iHeight;
       
        
        
        
        m_labelDate  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        
        m_labelDate.text  = "發票號碼:\(dictionary.object(forKey: "invoice_no") as! String)";
        self.contentView.addSubview(m_labelDate);
        iCurPos += 22;
        
        
        let  labelPoint  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        
//==================================================//
        let  get_wallet_amt  =  dictionary.object(forKey: "get_wallet_amt") as! Int64;
        var strGetWalletAmt = "\(get_wallet_amt)";
        
        if(get_wallet_amt>=0)
        {
            strGetWalletAmt  = "+\(get_wallet_amt)";
        }
        
        labelPoint.text  = "獲得點數:\(strGetWalletAmt)點";
        self.contentView.addSubview(labelPoint);
        iCurPos += 22;
        
        
        let  use_wallet_amt =  dictionary.object(forKey: "use_wallet_amt") as! Int64
        strGetWalletAmt = "\(use_wallet_amt)";
        
        if(use_wallet_amt >= 0)
        {
            strGetWalletAmt  = "+\(use_wallet_amt)";
        }
        
        let  MinusPoint  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        MinusPoint.text  = "折抵點數:\(strGetWalletAmt)點";
        self.contentView.addSubview(MinusPoint);
        
        
        
//=================================//
        let  labelMoney  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 250, y: iCurPos, width: 230, height: 30));
        
        labelMoney.textAlignment = .right;
        
        var strMoney = "消費金額：";
        let strPoint  = "\(dictionary.object(forKey: "trans_amt") as! Int64)";
        let iPoint = Int(strPoint)
        
        if(iPoint!>=0)
        {
            strMoney += strPoint
        }else
        {
            strMoney = strMoney + "-" + strPoint
        }
        
        
//==============================
        let foreColor  = UIColor.red
        let font = UIFont.systemFont(ofSize: 30)
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: foreColor
        ]

        
        
        let  NormalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        let firstString = NSMutableAttributedString(string: "消費金額：", attributes: NormalAttributes)
        let secondString = NSAttributedString(string: strPoint, attributes: firstAttributes)
        
        let thirdString = NSAttributedString(string: "元", attributes: NormalAttributes)
        
        firstString.append(secondString)
        firstString.append(thirdString)
      
        
        labelMoney.attributedText = firstString;
        self.contentView.addSubview(labelMoney);
        
        
        
        iCurPos += 40
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ConsumptionRecordTableViewCell.MainHeight = Int(iCurPos + 10);
    }
    
    
    
    func LoadDetailData(dictionary:NSDictionary , strName:String)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        
        /*
        m_labelTitle  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 30));
        m_labelTitle.font =  UIFont.systemFont(ofSize: 20.0)
        m_labelTitle.text = strName
        
        //============================
        m_labelTitle.numberOfLines = 0 ;
        m_labelTitle.lineBreakMode = .byWordWrapping;       
        m_labelTitle.sizeToFit();
        m_labelTitle.autoresize();
        let iHeight = m_labelTitle.frame.height;
         
        iCurPos += iHeight;
        self.contentView.addSubview(m_labelTitle);
        */
        
        
        let  goods_amt  = dictionary.object(forKey: "goods_amt") as! Int;
        let  goods_qty  = dictionary.object(forKey: "goods_qty") as! Int;
        let strItemName  = dictionary.object(forKey: "goods_code") as! String
        
        let  m_labelItemName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelItemName.text   = strItemName
        
        let m_labelDate1  = UILabel(frame:CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 20));
        m_labelDate1.textAlignment = .right;
        m_labelDate1.text   = "$\(goods_amt * goods_qty)"
        
        
        iCurPos += 32;
        self.contentView.addSubview(m_labelItemName);
        self.contentView.addSubview(m_labelDate1);
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ConsumptionRecordTableViewCell.MainHeight = Int(iCurPos + 10);
    }
    
    
    func LoadBalanceData(strTotal:Int , strInvoiceNum:Int , strRawordNum:Int)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        let strItemName  = "小計"; //dictionary.object(forKey: "ReceiptNumber")
        let  m_labelItemName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelItemName.text   = strItemName
        
        let m_labelDate1  = UILabel(frame:CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 20));
        
        m_labelDate1.textAlignment = .right;
        m_labelDate1.text   = "$\(strTotal)"
        
        self.contentView.addSubview(m_labelItemName);
        self.contentView.addSubview(m_labelDate1);
        
        iCurPos += 22;
        
        
        
        let  strInvoiceAmount  = "發票金額"; //dictionary.object(forKey: "ReceiptNumber")
        let  m_labelInvoiceAmount  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelInvoiceAmount.text   = strInvoiceAmount
        
        
        let m_labelInvoiceDate  = UILabel(frame:CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 20));
        
        m_labelInvoiceDate.textAlignment = .right;
        m_labelInvoiceDate.text   = "$\(strInvoiceNum)"
        
        self.contentView.addSubview(m_labelInvoiceAmount);
        self.contentView.addSubview(m_labelInvoiceDate);
        
        iCurPos += 22;
        
        
        let strAwardName  = "贈獎金額"; //dictionary.object(forKey: "ReceiptNumber")
        let  m_labelAwardName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelAwardName.text   = strAwardName
        
        
        let m_labelAwardDate  = UILabel(frame:CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 20));
        
        m_labelAwardDate.textAlignment = .right;
        m_labelAwardDate.text   = "$\(strRawordNum)"
        self.contentView.addSubview(m_labelAwardName);
        self.contentView.addSubview(m_labelAwardDate);
        
        iCurPos += 32;
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ConsumptionRecordTableViewCell.MainHeight = Int(iCurPos + 10);
    }
    
    
    func LoadCardData(dictionary:NSDictionary)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        
        //let strItemName  = "會員卡號：\(dictionary.object(forKey:"process_code") as! String)";
        let strItemName  = "會員卡號：\(ConfigInfo.m_strCardNumber)";
        
        let  m_labelItemName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelItemName.text   = strItemName
        self.contentView.addSubview(m_labelItemName);
        iCurPos += 22;
        
        
        let iPre_wallet_amt  = dictionary.object(forKey:"pre_wallet_amt") as! Int
        let iGet_wallet_amt  = dictionary.object(forKey:"get_wallet_amt") as! Int
        let iUse_wallet_amt  = dictionary.object(forKey:"use_wallet_amt") as! Int
        
        let iCurPoint = iPre_wallet_amt + iGet_wallet_amt + iUse_wallet_amt
        
        let  strMemberPoint  = "會員點數："; //dictionary.object(forKey: "ReceiptNumber")
        let  m_labelMemberPoint   = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelMemberPoint.text   = strMemberPoint
        self.contentView.addSubview(m_labelMemberPoint);
        iCurPos += 22;
        
        
//================================================================================//
        let iViewWidth  = (UIScreen.main.bounds.width - (LeftSpace * 2)) / 2;
        let iSpace = 20;
        
        
        let strBeforeUse  = "使用前：\(iPre_wallet_amt)";
        let  m_labelBeforeUse = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: iViewWidth - CGFloat(iSpace), height: 20));
        m_labelBeforeUse.text   = strBeforeUse
        self.contentView.addSubview(m_labelBeforeUse);
        
//===============//
        let strAdd  = "新增：\(iGet_wallet_amt)";
        let  m_labelAdd  = UILabel(frame: CGRect(x: iViewWidth + CGFloat(iSpace), y: iCurPos, width: iViewWidth - CGFloat(iSpace), height: 20));
        m_labelAdd.text   = strAdd
        self.contentView.addSubview(m_labelAdd);
        
        iCurPos += 22;
//=====================================================================//
        var strDiscount  = "折抵：\(iUse_wallet_amt)";
        if(iUse_wallet_amt == 0)
        {
            strDiscount  = "折抵：+\(iUse_wallet_amt)";
        }
        let  m_labelDisCount = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: iViewWidth, height: 20));
        m_labelDisCount.text   = strDiscount
        self.contentView.addSubview(m_labelDisCount);
        
        
        
        let strRemain  = "餘額：\(iCurPoint)點";
        let  m_labelRemain  = UILabel(frame: CGRect(x: iViewWidth + CGFloat(iSpace), y: iCurPos, width: iViewWidth - CGFloat(iSpace), height: 20));
        m_labelRemain.text   = strRemain
        self.contentView.addSubview(m_labelRemain);
        
        iCurPos += 22;
        
        ConsumptionRecordTableViewCell.MainHeight = Int(iCurPos + 10);
    }
    
    
    
    func LoadRandomData(strRandomCode:String)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 5.0;
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        iCurPos += 10;
        
        let strItemName  = "隨機碼：\(strRandomCode)";
        let  m_labelItemName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2), height: 20));
        m_labelItemName.text   = strItemName
        
        self.contentView.addSubview(m_labelItemName);
        iCurPos += 22;
        
        
        ConsumptionRecordTableViewCell.MainHeight = Int(iCurPos + 10);
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

