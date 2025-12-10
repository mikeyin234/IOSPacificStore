//
//  ElectronVoucherTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/1/23.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

extension UILabel {

    func autoresize() {
        if let textNSString: NSString = self.text as NSString? {
            let rect = textNSString.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSAttributedString.Key.font: self.font],
                context: nil)
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: rect.height)
        }
    }

}


class ElectronVoucherTableViewCell: UITableViewCell {
    
    static  var MainHeight =  220;
    
//==============================================//
    var m_labelTitle:UILabel!
    var m_labelInvoiceNumber:UILabel!
    
    var m_labelDate:UILabel!
    var m_labelPoint:UILabel!
    var  m_iSpace =  3;
    
    var m_strUnit  = "";
    
    
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    func LoadData(dictionary:NSDictionary ,strUnit:String)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        m_strUnit  = strUnit;
        
//===================================================================================//
        let  labelWalletName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 180, height: 30));
        
        labelWalletName.numberOfLines = 0 ;
        labelWalletName.lineBreakMode = .byWordWrapping;
        labelWalletName.font  =  UIFont.systemFont(ofSize: 20.0);
        labelWalletName.text  = (dictionary.object(forKey: "wallet_name") as! String);
        labelWalletName.sizeToFit();
        labelWalletName.autoresize();
        
        
        self.contentView.addSubview(labelWalletName);
        
        
        let iHeight = labelWalletName.frame.height;
        
//=================================//
        let  textMoney  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 30));
        
        
        textMoney.textAlignment = .right
        let strPoint  = (dictionary.object(forKey: "wallet_amt") as! Int);
        //==============================
        let font = UIFont.systemFont(ofSize: 25)
        let firstAttributes: [NSAttributedString.Key: Any] =
        [
            .font: font,
            .foregroundColor: UIColor.red
        ]
        
        
        let  NormalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]        
        let firstString = NSMutableAttributedString(string: "餘額：", attributes: NormalAttributes)
        let secondString = NSAttributedString(string: "\(strPoint)", attributes: firstAttributes)
        let thirdString = NSAttributedString(string: strUnit, attributes: NormalAttributes)
        
        
        firstString.append(secondString)
        firstString.append(thirdString)
        
       
        
        textMoney.attributedText = firstString;
        
        self.contentView.addSubview(textMoney);
        
        
        iCurPos += iHeight;
        
        let m_labelRemark  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        m_labelRemark.text  = (dictionary.object(forKey: "remark") as! String);
        
        
//===============================================//
        m_labelRemark.numberOfLines = 0 ;
        m_labelRemark.lineBreakMode = .byWordWrapping;
        m_labelRemark.sizeToFit();
        m_labelRemark.autoresize();
        
        
        let iHeightRemark = m_labelRemark.frame.height;
        self.contentView.addSubview(m_labelRemark);
        
        iCurPos += iHeightRemark;
        
        
        let   dateStart =  (dictionary.object(forKey: "exp_date_start") as! String);
        let dateEnd  =  (dictionary.object(forKey: "exp_date_end") as! String);
        
        
       
        
        
        m_labelDate  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        m_labelDate.text  = "使用期限：\( ConfigInfo.FormatDateStirng(strDate: dateStart))-\( ConfigInfo.FormatDateStirng(strDate: dateEnd))";
        
        
        self.contentView.addSubview(m_labelDate);
        
        iCurPos += 30;
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ElectronVoucherTableViewCell.MainHeight = Int(iCurPos + 10);
        
    }
    
    
    func LoaQLotterydData(dictionary:NSDictionary , strUnit:String)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        
        
        let  labelWalletName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 30));
        
        labelWalletName.font  =  UIFont.systemFont(ofSize: 20.0);
        labelWalletName.text  = (dictionary.object(forKey: "process_code") as! String);
        self.contentView.addSubview(labelWalletName);
        
        
        
//=================================//
        let  textMoney  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 260, y: iCurPos, width: 230, height: 30));
        
        
        textMoney.textAlignment = .right
        
//=========================
        var strDate  = (dictionary.object(forKey: "trans_date") as! String);
        strDate  = ConfigInfo.FormatDateStirng(strDate: strDate)
        
        
        
        var strTime  = (dictionary.object(forKey: "trans_time") as! String);
        strTime  =  ConfigInfo.FormatTimeStirng(strDate: strTime);
        strTime =  String(strTime.prefix(5))
        
        
        textMoney.text = "\(strDate) \(strTime)";
        self.contentView.addSubview(textMoney);
        
        
        
        
        iCurPos += 30;
        
        
//================================================================================//
        let m_labelRemark  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        //m_labelRemark.text  = (dictionary.object(forKey: "counter") as! String);
        
//============================
        m_labelRemark.numberOfLines = 0 ;
        m_labelRemark.lineBreakMode = .byWordWrapping;
        m_labelRemark.font  =  UIFont.systemFont(ofSize: 20.0);
        m_labelRemark.text  =  (dictionary.object(forKey: "counter") as! String);
        m_labelRemark.sizeToFit();
        m_labelRemark.autoresize();
        
        let iHeight = m_labelRemark.frame.height;
        self.contentView.addSubview(m_labelRemark);
        
        iCurPos += iHeight;
        
        
//====================//
        let   strInvoice_no =  (dictionary.object(forKey: "invoice_no") as! String);
        m_labelDate  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        
        
        m_labelDate.text  = "發票號碼：\(strInvoice_no)";
        self.contentView.addSubview(m_labelDate);
        
        
//===============增加             扣除======================
        let   iWallet_Amt =  (dictionary.object(forKey: "wallet_amt") as! Int64);
        
        
        //=======================================//
        let font = UIFont.systemFont(ofSize: 30)
        var firstAttributes: [NSAttributedString.Key: Any] =
        [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
//===================================================//
        //var strTypeFormat  = "";
        var colColor       = UIColor.black;
        if(iWallet_Amt < 0)
        {
            colColor       = UIColor.red;
        }
        
        
//================================================================================//
        let  NormalAttributes = [NSAttributedString.Key.foregroundColor: colColor]
        //let firstString = NSMutableAttributedString(string: strTypeFormat, attributes: NormalAttributes)
        
        let firstString = NSAttributedString(string: "\(iWallet_Amt)\(strUnit)", attributes: firstAttributes)
        
        //firstString.append(secondString)
        
        let  textQPoint  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 30));
        
        textQPoint.textAlignment = .right;
        textQPoint.attributedText = firstString;
        self.contentView.addSubview(textQPoint);
        
        
        iCurPos += 30;
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ElectronVoucherTableViewCell.MainHeight = Int(iCurPos + 10);
        
    }
    
    
    
    func LoaElectronVoucherData(dictionary:NSDictionary , strUnit:String)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        
        
        let  labelWalletName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 30));
        
        labelWalletName.font  =  UIFont.systemFont(ofSize: 20.0);
        labelWalletName.text  = (dictionary.object(forKey: "process_code") as! String);
        self.contentView.addSubview(labelWalletName);
        
        
        
//=================================//
        let  textMoney  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 260, y: iCurPos, width: 230, height: 30));
        
        
        textMoney.textAlignment = .right
        
//=========================
        var strDate  = (dictionary.object(forKey: "trans_date") as! String);
        strDate  = ConfigInfo.FormatDateStirng(strDate: strDate)
        
        
        
        var strTime  = (dictionary.object(forKey: "trans_time") as! String);
        strTime  =  ConfigInfo.FormatTimeStirng(strDate: strTime);
        strTime =  String(strTime.prefix(5))
        
        
        textMoney.text = "\(strDate) \(strTime)";
        self.contentView.addSubview(textMoney);
        
        
        
        
        iCurPos += 30;
        
        
//================================================================================//
        let m_labelRemark  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        //m_labelRemark.text  = (dictionary.object(forKey: "counter") as! String);
        
//============================
        m_labelRemark.numberOfLines = 0 ;
        m_labelRemark.lineBreakMode = .byWordWrapping;
        m_labelRemark.font  =  UIFont.systemFont(ofSize: 20.0);
        m_labelRemark.text  =  (dictionary.object(forKey: "counter") as! String);
        m_labelRemark.sizeToFit();
        m_labelRemark.autoresize();
        
        let iHeight = m_labelRemark.frame.height;
        self.contentView.addSubview(m_labelRemark);
        
        iCurPos += iHeight;
        
        
//====================//
        let   strInvoice_no =  (dictionary.object(forKey: "invoice_no") as! String);
        m_labelDate  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 20));
        
        
        m_labelDate.text  = "發票號碼：\(strInvoice_no)";
        self.contentView.addSubview(m_labelDate);
        
        
//===============增加             扣除======================
        let   iWallet_Amt =  (dictionary.object(forKey: "total_amt") as! Int64);
        
        
        //=======================================//
        let font = UIFont.systemFont(ofSize: 30)
        let firstAttributes: [NSAttributedString.Key: Any] =
        [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
//===================================================//
        //var strTypeFormat  = "";
        var colColor       = UIColor.black;
        if(iWallet_Amt < 0)
        {
            colColor       = UIColor.red;
        }
        
        
//================================================================================//
        let  NormalAttributes = [NSAttributedString.Key.foregroundColor: colColor]
        //let firstString = NSMutableAttributedString(string: strTypeFormat, attributes: NormalAttributes)
        
        let firstString = NSAttributedString(string: "\(iWallet_Amt)\(strUnit)", attributes: firstAttributes)
        
        //firstString.append(secondString)
        
        let  textQPoint  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 30));
        
        textQPoint.textAlignment = .right;
        textQPoint.attributedText = firstString;
        self.contentView.addSubview(textQPoint);
        
        
        iCurPos += 30;
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ElectronVoucherTableViewCell.MainHeight = Int(iCurPos + 10);
        
    }
    
    
    
    
    
    
    
    func LoaLotteryNumberdData(dictionary:NSDictionary)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        
        
        let  labelWalletName  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 50, height: 30));
        
        labelWalletName.font  =  UIFont.systemFont(ofSize: 25.0);
        labelWalletName.text  = (dictionary.object(forKey: "ticket_no") as! String);
        self.contentView.addSubview(labelWalletName);
        
        
//=================================//
        let  textMoney  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 220, y: iCurPos, width: 200, height: 30));
        
        
        textMoney.textAlignment = .right
        textMoney.text = (dictionary.object(forKey: "is_wining") as! String);
        self.contentView.addSubview(textMoney);
        
        iCurPos += 30;
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ElectronVoucherTableViewCell.MainHeight = Int(iCurPos + 10);
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
