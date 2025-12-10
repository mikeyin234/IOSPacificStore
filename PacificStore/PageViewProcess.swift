////////////////////////////////////////////////////////
//  PageViewProcess.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2021/10/30.
//  Copyright © 2021 greatsoft. All rights reserved.
////////////////////////////////////////////////////////


import Foundation


class  PageViewInfo
{
    var m_PageViewInfoArray:[NSMutableDictionary] =  [];
    
    func GetDictionary(ID:Int)->NSMutableDictionary
    {
        let strCurDay  =   ConfigInfo.GetCurDate();
        
        for pageview in m_PageViewInfoArray {
            
             let  iID = pageview.object(forKey: "id") as! Int;
             let  strDay = pageview.object(forKey: "day") as! String;
             if(ID == iID  &&  strDay.elementsEqual(strCurDay))
             {
                 return  pageview;
             }
        }
        
        
        let nsDictionary   = NSMutableDictionary();
        m_PageViewInfoArray.append(nsDictionary)
        return nsDictionary;
        
    }
    
    
    func RemoveNotTodayDic()
    {
        let strCurDay  =   ConfigInfo.GetCurDate();
        var removeViewInfo:[NSDictionary] =  [];
        for pageview in m_PageViewInfoArray {
            let  strDay = pageview.object(forKey: "day") as! String;
             if(!strDay.elementsEqual(strCurDay))
             {
                 removeViewInfo.append(pageview)
             }
        }
        
        
        for pageview in removeViewInfo {
            let iIndex = m_PageViewInfoArray.firstIndex(of: pageview as! NSMutableDictionary)
            m_PageViewInfoArray.remove(at: iIndex!)
        }
    }
    
    
    func Save()
    {
               
        let data = try? JSONSerialization.data(withJSONObject: m_PageViewInfoArray, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        //Data转换成String打印输出
        let strJason = String(data:data!, encoding: String.Encoding.utf8)
        
        writeDefaults("PageView",context:  strJason as! NSString);
        
    }
    
    func Load()
    {
       
        let pageviewJson  =  readDefaults("PageView")
        
        if(pageviewJson.length >  0 )
        {

            let data = pageviewJson.data(using: String.Encoding.utf8.rawValue)
            
            let jsonArr = try! JSONSerialization.jsonObject(with: data!,
            options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSMutableDictionary]
                    
            m_PageViewInfoArray.append(contentsOf: jsonArr);
        }
        
        RemoveNotTodayDic();
    }
    
    
    private func writeDefaults(_ keyWord:NSString, context:NSString){
        
        
        let preferences = UserDefaults.standard
        
        let currentLevelKey = keyWord
        let currentLevel = context
        
        
        preferences.setValue(currentLevel, forKey: currentLevelKey as String)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("\(currentLevelKey) can't save")
        }
    }

    
    
    func readDefaults(_ keyWord:NSString)->NSString{
        let preferences = UserDefaults.standard
        let currentLevelKey = keyWord
        var currentLevel:String = ""
        
        if preferences.object(forKey: currentLevelKey as String) == nil {
            
        } else {
            currentLevel = preferences.string(forKey: currentLevelKey as String)!
        }
        return currentLevel as NSString
    }
    
    
}
