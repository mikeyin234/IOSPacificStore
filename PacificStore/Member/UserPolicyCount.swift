//
//  UserPolicyCount.swift
//  PacificStore
//
//  Created by 尹竑翰 on 2023/8/4.
//  Copyright © 2023 greatsoft. All rights reserved.
/////////////////////////////////////////////////////////////
import Foundation

class  UserPolicyCount
{
    var m_PageViewInfoArray:[NSMutableDictionary] =  [];
    
    func GetDictionary()->NSMutableDictionary
    {
        let strCurDay  =   ConfigInfo.GetCurDate();
        for pageview in m_PageViewInfoArray {
             let  strDay = pageview.object(forKey: "day") as! String;
             if(strDay.elementsEqual(strCurDay))
             {
                 return  pageview;
             }
        }
        
        let nsDictionary   = NSMutableDictionary();
        m_PageViewInfoArray.append(nsDictionary)
        return nsDictionary;
        
    }
    
    
    private func RemoveNotTodayDic()
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
        
        writeDefaults("UserPolicyCount",context:  strJason! as NSString);
        
    }
    
    func Load()
    {
       
        let pageviewJson  =  readDefaults("UserPolicyCount")
        
        if(pageviewJson.length >  0 )
        {

            let data = pageviewJson.data(using: String.Encoding.utf8.rawValue)
            
            let jsonArr = try! JSONSerialization.jsonObject(with: data!,
            options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSMutableDictionary]
                    
            m_PageViewInfoArray.append(contentsOf: jsonArr);
        }
        
        RemoveNotTodayDic();
    }
    
    
    func writeDefaults(_ keyWord:NSString, context:NSString){
        
        
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



