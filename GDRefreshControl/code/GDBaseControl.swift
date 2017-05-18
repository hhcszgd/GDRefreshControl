//
//  GDBaseControl.swift
//  GDRefreshControl
//
//  Created by WY on 16/05/2017.
//  Copyright © 2017 hhcszgd. All rights reserved.
//
//
//  GDLoadControl.swift
//  zjlao
//
//  Created by WY on 28/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//
//

import UIKit


public class GDBaseControl: UIView {
    public var customView : UIView?{
        didSet{
            oldValue?.removeFromSuperview()
            if customView != nil  {
                self.addSubview(customView!)
            }
        }
    }
    public lazy var titleLabel = UILabel()
    public lazy var imageView  = UIImageView()
    var pan : UIPanGestureRecognizer?
    
    /// if you want change titleLable's frame , by this var
    public var labelFrame = CGRect.zero
    /// if you want change imageView's frame , by this var
    public var imageViewFrame = CGRect.zero
    
    
    var originalIspagingEnable = false
    var originalContentInset = UIEdgeInsets.zero
    var originalContentOffset = CGPoint.zero
    
    var priviousContentOffset = CGPoint.zero

    public var direction : GDDirection = GDDirection.bottom
    var scrollView : UIScrollView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.init(colorLiteralRed: 180 / 256, green: 180 / 256, blue: 180 / 256, alpha: 1)
        self.backgroundColor =  UIColor.init(colorLiteralRed: 251 / 256, green: 251 / 256, blue: 251 / 256, alpha: 1)
        
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}



// MARK: 注释 : control
extension GDBaseControl {
    

    
}




// MARK: 注释 : updateUI
extension GDBaseControl {
    
    
}

// MARK: 注释 : KVO
extension GDBaseControl {
    
    
    
    override public func willMove(toSuperview newSuperview: UIView?) {//important
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil  {//将要从tableView上移除之前(提前与deinit),先移除scrollView的contentOffset的监听 , 否则会崩溃
            if let scrollView = self.superview as? UIScrollView {

                self.removeObservers(scrollView: scrollView)
            }
        }else{
            if let scrollView = newSuperview as? UIScrollView {
                self.scrollView = scrollView
                self.originalIspagingEnable = scrollView.isPagingEnabled
                self.originalContentInset = scrollView.contentInset
                self.originalContentOffset = scrollView.contentOffset
                mylog("最初赋值时 , 滚动控件的滚动范围\(scrollView.contentSize)")
                self.addObservers(scrollView: scrollView)
            }
        }
    }
    
    func addObservers(scrollView:UIScrollView) {
        scrollView.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        scrollView.addObserver(self , forKeyPath: "contentInset", options: NSKeyValueObservingOptions.new, context: nil)
        scrollView.addObserver(self , forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.addObserver(self , forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        self.pan = scrollView.panGestureRecognizer;
        self.pan?.addObserver(self , forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: nil )
    }
    func removeObservers(scrollView:UIScrollView) {
        scrollView.removeObserver(self , forKeyPath: "contentOffset")
        scrollView.removeObserver(self , forKeyPath: "contentInset")
        scrollView.removeObserver(self , forKeyPath: "contentSize")
        self.pan?.removeObserver(self , forKeyPath: "state")
        self.removeObserver(self , forKeyPath: "frame")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let scrollView = self.scrollView {
            self.scrollView = scrollView
            self.originalIspagingEnable = scrollView.isPagingEnabled
//            self.originalContentInset = scrollView.contentInset
//            self.originalContentOffset = scrollView.contentOffset
            //            mylog("最初赋值时 , 滚动控件的滚动范围\(scrollView.contentSize)")//此时的contentSize才有值
        }
        
        if let collection  = self.scrollView as? UICollectionView {//保证Collection的滚动
            if let flowLayout  = collection.collectionViewLayout as? UICollectionViewFlowLayout {
                if flowLayout.scrollDirection == UICollectionViewScrollDirection.horizontal {
                    collection.bounces = true
                    collection.alwaysBounceVertical = false
                    collection.alwaysBounceHorizontal = true
                }else if flowLayout.scrollDirection == UICollectionViewScrollDirection.vertical {
                    collection.bounces = true
                    collection.alwaysBounceVertical = true
                    collection.alwaysBounceHorizontal = false
                }
                
            }
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        mylog(keyPath)
        if keyPath != nil && keyPath! == "contentOffset" {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                //                mylog("监听contentOffset\(newPoint)")//下拉变小
                if let scrollView = self.scrollView {
                    self.scrollViewDidScroll(scrollView)
                }

            }
        }else if keyPath != nil && keyPath! == "contentInset"{
            let newPoint = change?[NSKeyValueChangeKey.newKey]
            mylog("监听contentInset : \(String(describing: newPoint))")
            
            
        }else if keyPath != nil && keyPath! == "contentSize"{
            let newPoint = change?[NSKeyValueChangeKey.newKey]
            self.scrollViewContentSizeChanged()
            
        }else if keyPath != nil && keyPath! == "state"{
//            mylog((change?[NSKeyValueChangeKey.newKey]))
            if  let gestureStateRowValue = change?[NSKeyValueChangeKey.newKey] as? Int {
                //1即将开始  , 2 已经开始 , 3 拖拽结束
//                UIGestureRecognizerState.init(rawValue: 3)
                if gestureStateRowValue == 1 {//即将开始
                    if let scrollView = self.scrollView {
                        self.scrollViewWillBeginDragging(scrollView)
                    }
                }else if gestureStateRowValue == 2 {//拖拽中
                }else if gestureStateRowValue == 3 {//拖拽完毕
                    if let scrollView = self.scrollView {
                        self.scrollViewDidEndDragging(scrollView)
                        
                    }
                    
                }else if gestureStateRowValue == 4 {//取消
                    
                }else if gestureStateRowValue == 5 {//失败
                    
                }

            
            }
            
        }else if keyPath != nil && keyPath! == "frame"{
            let newPoint = change?[NSKeyValueChangeKey.newKey]
            mylog("监听frame : \(String(describing: newPoint))")
            
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
}



// MARK: 注释 : 子类实现
extension GDBaseControl{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView){ }
    public func scrollViewContentSizeChanged(){}
    
}





