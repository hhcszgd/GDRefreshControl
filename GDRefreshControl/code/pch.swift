//
//  pch.swift
//  GDRefreshControl
//
//  Created by WY on 12/05/2017.
//  Copyright © 2017 hhcszgd. All rights reserved.
//

import UIKit

//MARK:自定义打印方法
public func mylog <T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
        let url = URL.init(fileURLWithPath: fileName)
        /*
         //let a = (fileName as NSString).pathComponents.last
         let arr : NSArray = NSArray.init()
         URL.init(fileURLWithPath: "///").pathComponents
         
         let a = fileName.path
         fileName.compare(<#T##aString: String##String#>)
         let components = (fileName as NSString).pathComponents
         //arr.isKind(of: <#T##AnyClass#>)
         if components.isKind(of : NSArray.self ) {
         
         }
         if fileName {
         <#code#>
         }*/
        //print("👉[\(lineNumber)]\((fileName as NSString).pathComponents.last!) <--> \(methodName)  \n\(message)")
        //        print(url.pathComponents.last!)
        //        print(message)
        //        print(lineNumber)
        print("👉\(url.pathComponents.last!) [\(lineNumber)] 🛑\(message)👈")
        //        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

//MARK: 直接从Resource中获取文件

func gotResourceInSubBundle(_ name : String,type : String,directory : String) -> String? {
    guard let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle") else {return nil}
    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
    guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: directory) else {return nil}
    return itemPath
}
