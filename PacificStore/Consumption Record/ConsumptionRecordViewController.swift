//
//  ConsumptionRecordViewController.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/2/8.
//  Copyright © 2021 greatsoft. All rights reserved.
//

import UIKit

class ConsumptionRecordViewController:BaseViewController,
      UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet var m_labelTitleName : UILabel!
    @IBOutlet var m_labelTradeType : UILabel!
    @IBOutlet var m_labelTradeName : UILabel!
    @IBOutlet var m_labelInvoice : UILabel!
    @IBOutlet var m_labelDate : UILabel!
    
    
    
    @IBOutlet var m_tableView : UITableView!
    var   m_dicInfo:NSDictionary!
    
    
//================================
    var m_iType = 0;  //0 = 消費 1 = 收
    var m_iCurrentSelect = 0;
    var m_ListConsumeInfo:[NSDictionary] =  [];
    
    var m_strRandom_code = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_labelTradeType.text  = (m_dicInfo.object(forKey: "process_code") as! String);
        m_labelTradeName.text  = (m_dicInfo.object(forKey: "counter") as! String);
        m_labelInvoice.text  = "發票號碼:\(m_dicInfo.object(forKey: "invoice_no") as! String )"
        m_strRandom_code  = (m_dicInfo.object(forKey: "random_code") as! String);
        
        
        print(("Random_code = \(m_strRandom_code)\n"))
        
        
        
        var date = m_dicInfo.object(forKey: "trans_date") as! String
        
        date.insert("/", at: date.index(date.startIndex, offsetBy: 4))
        date.insert("/", at: date.index(date.startIndex, offsetBy: 7))
        
        var time =  m_dicInfo.object(forKey: "trans_time") as! String
        time.insert(":", at: date.index(date.startIndex, offsetBy: 2))
        
        let index = time.index(time.startIndex, offsetBy: 5)
        let timeCur = time.prefix(upTo: index) // Hello
        m_labelDate.text   = "\(date) \(timeCur)"
        
        
//======================================================================
        let goodsArray  = m_dicInfo.object(forKey: "goods") as! NSArray
        
        for DataDicCur  in goodsArray
        {
            let dicCur  = DataDicCur as! NSDictionary
            m_ListConsumeInfo.append(dicCur)
        }
        
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        
        self.SetTitleColor();
        super.viewWillAppear(animated)
        
//==================================================//
        self.startTimeTick();
        
    }
    
    
    
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self);
        
        RemoveTitleBar()
        
        self.stopTimeTick();
        
        
        DCUpdater.shared()?.addAppClickLog(Int32(self.TYPE_POINT_QUERY), andDuration: Int32(self.durationSeconds()), andFunctionCount: 1, andAccessToken: ConfigInfo.m_strAccessToken);
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onBackClick(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row < m_ListConsumeInfo.count)
        {
            var Mycell:ConsumptionRecordTableViewCell!;
            
            let cell = ConsumptionRecordTableViewCell(style: .default, reuseIdentifier: "ExpensesRecord")
            
            cell.LoadDetailData(dictionary: m_ListConsumeInfo[indexPath.row],strName: m_labelTradeName.text!)
            
            
            Mycell = cell;
            
            return Mycell
            
            
        }else if(indexPath.row == m_ListConsumeInfo.count)
        {
            var Mycell:ConsumptionRecordTableViewCell!;
            
            let cell = ConsumptionRecordTableViewCell(style: .default, reuseIdentifier: "ExpensesRecord")
            
            
            let iTrans_amt  = m_dicInfo.object(forKey: "trans_amt") as! Int
            let iInvoiceNum  = m_dicInfo.object(forKey: "invoice_amt") as! Int
            let iProm_amt  = m_dicInfo.object(forKey: "prom_amt") as! Int
            
            cell.LoadBalanceData(strTotal: iTrans_amt, strInvoiceNum: iInvoiceNum, strRawordNum: iProm_amt)
            
            Mycell = cell;
            
            return Mycell
        }else if(indexPath.row == (m_ListConsumeInfo.count+1))
        {            
            var Mycell:ConsumptionRecordTableViewCell!;
            
            let cell = ConsumptionRecordTableViewCell(style: .default, reuseIdentifier: "ExpensesRecord")
            
            cell.LoadCardData(dictionary:m_dicInfo)
            
            Mycell = cell;
            
            return Mycell
        }else
        {
            var Mycell:ConsumptionRecordTableViewCell!;
            
            let cell = ConsumptionRecordTableViewCell(style: .default, reuseIdentifier: "ExpensesRecord")
            
            cell.LoadRandomData(strRandomCode: m_strRandom_code)
            
            Mycell = cell;
            
            return Mycell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return m_strRandom_code.count != 4 ? m_ListConsumeInfo.count + 2 : m_ListConsumeInfo.count + 3;
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          return m_iType == 0 ? CGFloat(ConsumptionRecordTableViewCell.MainHeight) :
                CGFloat(CollectPointTableViewCell.MainHeight);
        
    }
    
    
   
    
    
}
