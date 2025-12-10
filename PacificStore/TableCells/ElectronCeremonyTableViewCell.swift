//
//  ElectronCeremonyTableViewCell.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/1/23.
//  Copyright © 2021 greatsoft. All rights reserved.
///////////////////////////////////////////////////////

import UIKit


class ElectronCeremonyTableViewCell: UITableViewCell {

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
    
    
    func LoadData(dictionary:NSDictionary,strUnit:String)
    {
        let LeftSpace:CGFloat = 5.0;
        var iCurPos:CGFloat = 10.0;
        
        
        
        let  labelWallet_Name  = UILabel(frame: CGRect(x: LeftSpace, y: iCurPos, width: UIScreen.main.bounds.width - (LeftSpace * 2) - 180, height: 30));
        
        labelWallet_Name.font  =  UIFont.systemFont(ofSize: 20.0);
        labelWallet_Name.text  = (dictionary.object(forKey: "wallet_name") as! String)
        self.contentView.addSubview(labelWallet_Name);
        
    
//===============================================//
        labelWallet_Name.numberOfLines = 0 ;
        labelWallet_Name.lineBreakMode = .byWordWrapping;
        labelWallet_Name.sizeToFit();
        labelWallet_Name.autoresize();
//=======================================================//
        let iHeightRemark = labelWallet_Name.frame.height;
        self.contentView.addSubview(labelWallet_Name);
        
        
        
        
//=================================//
        let  textMoney  = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 200, y: iCurPos, width: 180, height: 30));
        
        
        textMoney.textAlignment = .right
        let strPoint  = dictionary.object(forKey: "wallet_amt") as! Int;
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
        
        iCurPos += (iHeightRemark + 8);
        
        
        //elf.contentView.addSubview(MinusPoint);
       
        
        let uiView  = UIView(frame:  CGRect(x: 0, y: iCurPos, width: UIScreen.main.bounds.width, height: 3));
        uiView.backgroundColor  =  UIColor(red: 0xB5/255.0, green: 0xB5/255.0, blue: 0xB6/255.0, alpha: 1)
        
        self.contentView.addSubview(uiView);
        
        ElectronCeremonyTableViewCell.MainHeight = Int(iCurPos + 10);
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
