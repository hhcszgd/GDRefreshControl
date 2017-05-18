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

func gotResourceInSubBundle(_ name : String,type : String,directory : String?) -> String? {
    let bundle : Bundle = Bundle(for: GDBaseControl.self)       //refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MJRefreshComponent class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
    
    guard let subBundlePath = bundle.path(forResource: "Resource", ofType: "bundle") else {return nil}
    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
    if let tempDirectory = directory {
        guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: tempDirectory) else {return nil}
        return itemPath
    }else{
        guard let  itemPath = subBundle.path(forResource: name, ofType: type) else {  return nil  }
        return itemPath
    }
//    guard let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle") else {return nil}
//    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
//    if let tempDirectory = directory {
//        guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: tempDirectory) else {return nil}
//        return itemPath
//    }else{
//        guard let  itemPath = subBundle.path(forResource: name, ofType: type) else {  return nil  }
//        return itemPath
//    }
}


func pullingImagesForRefresh() -> [UIImage] {
    var images  = [UIImage]()
    for index  in 1...5 {
        if let path = gotResourceInSubBundle("icon_pull_animation_\(index)", type: "png", directory: nil  ) {
            if let img  = UIImage(contentsOfFile:path) {
                images.append(img)
            }
        }
        
    }
    return images
}

func pullingImgsForLoad() -> [UIImage] {
    var images  = [UIImage]()
    for index  in 1...5 {
        if let path = gotResourceInSubBundle("icon_pull_animation_\(index)", type: "png", directory: nil  ) {
            if let img  = UIImage(contentsOfFile:path) {
                images.append(img)
            }
        }
        
    }
    return images
}
func refreshingImgs() -> [UIImage] {
    var images  = [UIImage]()
    for index  in 1...4 {
        if let path = gotResourceInSubBundle("loading_640x1136_\(index)@2x", type: "png", directory: nil  ) {
            if let img  = UIImage(contentsOfFile:path) {
                images.append(img)
            }
        }
        
    }
    return images
}

func loadingImgs() -> [UIImage] {
    var images  = [UIImage]()
    for index  in 1...4 {
        if let path = gotResourceInSubBundle("loading_640x1136_\(index)@2x", type: "png", directory: nil  ) {
            if let img  = UIImage(contentsOfFile:path) {
                images.append(img)
            }
        }
        
    }
    return images
}



func networkErrorImageForRefresh() -> UIImage {
    if let path = gotResourceInSubBundle("icon_rating_bad@2x", type: "png", directory: nil  ) {
        if let img  = UIImage(contentsOfFile:path) {
            return img
        }
    }
    return UIImage()
}
func failureImagesForRefresh() -> UIImage {
    if let path = gotResourceInSubBundle("icon_rating_normal_selected@2x", type: "png", directory: nil  ) {
        if let img  = UIImage(contentsOfFile:path) {
            return img
        }
    }
    return UIImage()
}

func successImagesForRefresh() -> UIImage {
    if let path = gotResourceInSubBundle("icon_rating_very_good_selected@2x", type: "png", directory: nil  ) {
        if let img  = UIImage(contentsOfFile:path) {
            return img
        }
    }
    return UIImage()
}

func networkErrorImageForLoad() -> UIImage {
    if let path = gotResourceInSubBundle("icon_rating_bad@2x", type: "png", directory: nil  ) {
        if let img  = UIImage(contentsOfFile:path) {
            return img
        }
    }
    return UIImage()
}
func failureImagesForLoad() -> UIImage {
    if let path = gotResourceInSubBundle("icon_rating_normal_selected@2x", type: "png", directory: nil  ) {
        if let img  = UIImage(contentsOfFile:path) {
            return img
        }
    }
    return UIImage()
}

func successImagesForLoad() -> UIImage {
    if let path = gotResourceInSubBundle("icon_rating_very_good_selected@2x", type: "png", directory: nil  ) {
        if let img  = UIImage(contentsOfFile:path) {
            return img
        }
    }
    return UIImage()
}

func nomoreImageForLoad() -> UIImage {
    if let path = gotResourceInSubBundle("icon_deal_empty@2x", type: "png", directory: nil  ) {
        if let img  = UIImage(contentsOfFile:path) {
            return img
        }
    }
    return UIImage()
}
