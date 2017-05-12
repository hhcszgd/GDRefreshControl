//
//  GDRefreshControl.swift
//  zjlao
//
//  Created by WY on 28/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

// MARK: 注释 : 加载结果
enum GDRefreshResult {
    case success
    case failure
    case networkError
    
}

//// MARK: 注释 : 刷新方式
//enum GDRefreshType {
//    case manual//手动
//    case auto//自动
//}

// MARK: 注释 : 刷新控件显示状态
enum GDShowStatus {
    case idle
    case pulling
    case prepareRefreshing
    case refreshing
    case refreshed
    case refreshSuccess
    case backing
    case refreshFailure
    case netWorkError
    
}
// MARK: 注释 : 刷新控件当前状态
enum GDRefreshStatus {
    case idle
    case pulling
    case refreshing
    case backing
}
// MARK: 注释 : 刷新控件的方向
enum GDDirection {
    case top
    case left
    case bottom
    case right
}
class GDRefreshControl: UIControl {
    lazy var titleLabel = UILabel()
    lazy var imageView  = UIImageView()
    var refreshHeight : CGFloat = 100
    
    
    fileprivate var originalIspagingEnable = false
    fileprivate var originalContentInset = UIEdgeInsets.zero
    fileprivate var originalContentOffset = CGPoint.zero
    
    fileprivate var priviousContentOffset = CGPoint.zero
    fileprivate var showStatus = GDShowStatus.idle
//    var refreshType  = GDRefreshType.auto
    
    
    var direction : GDDirection = GDDirection.top
    fileprivate var scrollView : UIScrollView?
    
    fileprivate weak var refreshTarget : AnyObject?
    fileprivate var refreshAction : Selector?
    
    var refreshStatus = GDRefreshStatus.idle{
        
        didSet{
            if refreshStatus != GDRefreshStatus.refreshing {    return  }
            if oldValue == refreshStatus {return}
            
            switch self.direction {
            case  GDDirection.top:
                let y = -refreshHeight - 1.0
//                self.setrefershStatusEndDrag(contentOffset:CGPoint(x: 0, y: y) )
                self.performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint(x: 0, y: y))
//                if (self.scrollView?.contentOffset.y ?? 0) < -refreshHeight {//可以刷新
//                    
//                }
                
                break
            case  GDDirection.left:
                if (self.scrollView?.contentOffset.x ?? 0 ) < -refreshHeight {//可以刷新
                }
                let x = -refreshHeight - 1.0
//                self.setrefershStatusEndDrag(contentOffset:CGPoint(x: x, y: 0) )
                self.performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint(x: x, y: 0))
                
                break
            case  GDDirection.bottom:
                
                if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){
//                    if (scrollView?.contentOffset.y ?? 0) >  refreshHeight { //可以刷新
//                       
//                        
//                    }
                    let y = refreshHeight + 1.0
//                    self.setrefershStatusEndDrag(contentOffset:CGPoint(x: 0, y: y))
                    self.performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint(x: 0, y: y))

                }else{
                    
//                    if (self.scrollView?.contentOffset.y ?? 0 ) > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight {//可以刷新
//                       
//                    }
                    
                    let y = (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight + 1.0
//                        self.setrefershStatusEndDrag(contentOffset:CGPoint(x: 0, y: y) )
                    self.performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint(x: 0, y: y))
                }
                break
            case  GDDirection.right:
                if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                        let x = refreshHeight + 1
//                       self.setrefershStatusEndDrag(contentOffset:CGPoint(x:x, y: 0) )
                    self.performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint(x: x, y: 0))
                    
                }else{
                    
//                    if (self.scrollView?.contentOffset.x ?? 0) > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight {//可以刷新
                        let x = (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight + 1
//                        self.setrefershStatusEndDrag(contentOffset:CGPoint(x:x, y: 0) )
                    self.performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint(x: x, y: 0))
                    
//                    }
                }
                break
            }
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
        self.addSubview(self.titleLabel)
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.numberOfLines = 0
    }
    
    convenience  init(target: AnyObject? , selector : Selector?) {
        self.init(frame: CGRect.zero)
        self.refreshTarget = target
        self.refreshAction = selector
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


}



// MARK: 注释 : control
extension GDRefreshControl {
    
    
    func addTarget(_ target: Any?, refreshAction: Selector) {
        self.refreshTarget = target as AnyObject
        self.refreshAction = refreshAction
    }
    
    
//    func prepareRefresh(contentOffset : CGPoint)  {
////        
//    }
    
    func performRefresh()  {//避免重复刷新TODO
        mylog("开始刷新  偏移量\(String(describing: self.scrollView?.contentOffset))")
        
        self.updateTextAndImage(showStatus: GDShowStatus.refreshing , actionType: GDShowStatus.refreshing)
        mylog(scrollView?.contentInset)
        if self.refreshAction != nil && self.refreshTarget != nil {
            _  = self.refreshTarget!.perform(self.refreshAction!)
        }
    }
    
    func endRefresh(result : GDRefreshResult = GDRefreshResult.success)  {
        var delay : TimeInterval = 1

        if  self.refreshStatus == GDRefreshStatus.refreshing {
            mylog("结束刷新 偏移量\(String(describing: self.scrollView?.contentOffset))")
            if result == GDRefreshResult.success {
                delay = 0 
                self.updateTextAndImage(showStatus: GDShowStatus.refreshSuccess , actionType:  GDShowStatus.refreshed)
            }else if result == GDRefreshResult.failure{
                self.updateTextAndImage(showStatus: GDShowStatus.refreshFailure , actionType:  GDShowStatus.refreshed)
            }else if result == GDRefreshResult.networkError{
                self.updateTextAndImage(showStatus: GDShowStatus.netWorkError , actionType:  GDShowStatus.refreshed)
            }
//            self.updateTextAndImage(contentOffset: CGPoint.zero)//
            UIView.animate(withDuration: 0.1, delay: delay, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                if self.scrollView != nil {
                    self.fixFrame(scrollView: self.scrollView!)
                }
            }) { (bool) in
                self.refreshStatus = GDRefreshStatus.idle
            }
        }
    }
}




// MARK: 注释 : updateUI
extension GDRefreshControl {
    
    
    
    func updateTextAndImage(showStatus : GDShowStatus , actionType : GDShowStatus = GDShowStatus.pulling/*拖动中还是弹回中*/,contentOffset : CGPoint = CGPoint.zero)  {
        var title  = ""
        
        if showStatus == GDShowStatus.pulling && actionType == GDShowStatus.pulling {
            //下拉以加载
            title = "拖动以刷新"
        }else if showStatus == GDShowStatus.pulling && actionType == GDShowStatus.backing && self.refreshStatus != GDRefreshStatus.refreshing{
            //下拉以加载
            title = "拖动以刷新"
        }else if showStatus == GDShowStatus.prepareRefreshing  {
            title = "松手刷新"
            //松手以刷新
        }else if showStatus == GDShowStatus.refreshing && actionType == GDShowStatus.refreshing{
            title = "刷新中"
            //刷新中
        }else if showStatus ==  GDShowStatus.refreshSuccess && actionType == GDShowStatus.refreshed{
            title = "刷新成功"
            //刷新成功
        }else if showStatus ==  GDShowStatus.refreshFailure && actionType == GDShowStatus.refreshed{
            title = "刷新失败"
            //刷新失败
        }else if showStatus ==  GDShowStatus.netWorkError && actionType == GDShowStatus.refreshed{
            title = "网络错误"
            //网络错误
        }
        
        
        
        
        let attributeTitle = NSMutableAttributedString.init(string: title)
        //            str.addAttribute(kCTVerticalFormsAttributeName as String, value: true , range:NSMakeRange(0, title.characters.count))
        
        //            str.addAttribute(NSVerticalGlyphFormAttributeName as String, value: NSNumber.init(value: 1) , range:NSMakeRange(0, title.characters.count))
        self.titleLabel.attributedText = attributeTitle
        
        self.showStatus = showStatus
        
    }
    
    func fixFrame(scrollView : UIScrollView)  {
        switch self.direction {
        case  GDDirection.top:
            self.frame = CGRect(x: 0, y: -refreshHeight, width: scrollView.bounds.size.width, height: refreshHeight)
            self.titleLabel.frame = CGRect(x: 0, y: self.bounds.size.height - self.titleLabel.font.lineHeight, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
            
            break
        case  GDDirection.left:
            self.frame = CGRect(x: -refreshHeight, y: 0, width: refreshHeight, height: scrollView.bounds.size.height)
            self.titleLabel.frame = CGRect(x: self.bounds.size.width - self.titleLabel.font.lineHeight, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
            break
        case  GDDirection.bottom:
            
            if scrollView.contentSize.height < scrollView.bounds.size.height{
                self.frame = CGRect(x: 0, y: scrollView.bounds.size.height, width:scrollView.bounds.size.width  ,  height: refreshHeight)
            }else{
                self.frame = CGRect(x: 0, y: scrollView.contentSize.height , width:scrollView.bounds.size.width  ,  height: refreshHeight)
            }
            self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
            break
        case  GDDirection.right:
            
            if scrollView.contentSize.width < scrollView.bounds.size.width{
                self.frame = CGRect(x: scrollView.bounds.size.width, y: 0, width: refreshHeight  ,  height: scrollView.bounds.size.height )
            }else{
                
                self.frame = CGRect(x: scrollView.contentSize.width, y: 0, width: refreshHeight, height: scrollView.bounds.size.height)
            }
            self.titleLabel.frame = CGRect(x: self.titleLabel.font.lineHeight, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
            break
        }
    }
    

    
}

// MARK: 注释 : KVO
extension GDRefreshControl {
    
    
    
    override func willMove(toSuperview newSuperview: UIView?) {//important
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil  {//将要从tableView上移除之前(提前与deinit),先移除scrollView的contentOffset的监听 , 否则会崩溃
//            if let scrollView = self.superview as? UIScrollView {
//                scrollView.removeObserver(self , forKeyPath: "contentOffset")
//            }
        }else{
            if let scrollView = newSuperview as? UIScrollView {
                self.scrollView = scrollView
                self.originalIspagingEnable = scrollView.isPagingEnabled
                self.originalContentInset = scrollView.contentInset
                self.originalContentOffset = scrollView.contentOffset
                mylog("最初赋值时 , 滚动控件的滚动范围\(scrollView.contentSize)")
                self.fixFrame(scrollView: scrollView)
                scrollView.delegate = self//监听contentOffset改用代理的形式
//                scrollView.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let scrollView = self.scrollView {
            self.scrollView = scrollView
            self.originalIspagingEnable = scrollView.isPagingEnabled
            self.originalContentInset = scrollView.contentInset
            self.originalContentOffset = scrollView.contentOffset
//            mylog("最初赋值时 , 滚动控件的滚动范围\(scrollView.contentSize)")//此时的contentSize才有值
            self.fixFrame(scrollView: scrollView)
//            scrollView.delegate = self//监听contentOffset改用代理的形式
            //                scrollView.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath != nil && keyPath! == "contentOffset" {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                //                mylog(newPoint)//下拉变小
                //                self.prepareRefresh(contentOffset: newPoint)
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
}



// MARK: 注释 : UIScrollViewDelegate
extension GDRefreshControl : UIScrollViewDelegate{
    
    // MARK: 注释 : 是否调用刷新控件的代理
    func whetherCallRefreshDelegate(_ scrollView:UIScrollView) -> GDLoadControl?  {
        if let _ =  scrollView.delegate as? GDRefreshControl {
            if let load  = scrollView.gdLoadControl  {
                return load
            }
        }
        return nil
    }
    
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.fixFrame(scrollView: scrollView)
        if let refresh  = self.whetherCallRefreshDelegate(scrollView) {
            refresh.scrollViewWillBeginDragging(scrollView)
        }
//        self.refreshType = GDRefreshType.manual
        // MARK: 注释 a: 当用户拖动时 , 还原滚动控件的isPagingEnable
        if scrollView.isPagingEnabled != self.originalIspagingEnable {
            self.scrollView?.isPagingEnabled = self.originalIspagingEnable
        }
        
    }
    
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        mylog("松手了  ,当前偏移量是\(scrollView.contentOffset)")
        if let refresh  = self.whetherCallRefreshDelegate(scrollView) {
            refresh.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        }
         self.backgroundColor = UIColor.orange
        if self.refreshStatus != GDRefreshStatus.refreshing {
            self.setrefershStatusEndDrag(contentOffset: scrollView.contentOffset)
            
        }
        
    }
    
    
    
    
    
    func performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复刷新 , 换成refreshing状态驱动
        var inset  = UIEdgeInsets.zero
        var isNeedRefresh = false
        
        
        //TODO  抽出目标contentOffset 分别赋值 , 再在底部动画与contentInset一起赋值(目前问题 , 达到刷新条件后 ,松手会偶尔出现滚动视图乱跳)
        var tempContentOffset  = CGPoint.zero
        
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -refreshHeight {//可以刷新
                inset.top = self.refreshHeight
                isNeedRefresh = true
//                let contentOffset = CGPoint(x: 0, y: 0)
//                self.scrollView?.setContentOffset(contentOffset, animated: true )
                tempContentOffset.y = -refreshHeight
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -refreshHeight {//可以刷新
                inset.left = self.refreshHeight
                isNeedRefresh = true
                tempContentOffset.x = -refreshHeight
//                self.scrollView?.setContentOffset(CGPoint.zero, animated: true )
            }
            break
        case  GDDirection.bottom:
            
            if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){//可滚动区域少于滚动控件frame
                if contentOffset.y >  refreshHeight { //可以刷新
                    inset.bottom = self.refreshHeight + ((scrollView?.bounds.size.height ?? 0) - (scrollView?.contentSize.height ?? 0))
                    isNeedRefresh = true
                    tempContentOffset.y = refreshHeight
//                    self.scrollView?.setContentOffset(CGPoint(x: 0, y: self.refreshHeight), animated: true )//确保能执行刷新时,才调这句代码 . 否则会出现 偏移后不执行刷新
                }
            }else{
                
                if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight {//可以刷新
                    inset.bottom = self.refreshHeight
                    isNeedRefresh = true
                    tempContentOffset.y = (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0) + self.refreshHeight
                    
//                    self.scrollView?.setContentOffset(CGPoint(x: 0, y: (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0) + self.refreshHeight ), animated: true )//确保能执行刷新时,才调这句代码 . 否则会出现 偏移后不执行刷新
                }
            }
            break
        case  GDDirection.right:
            if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                if contentOffset.x >  refreshHeight {//可以刷新
                    inset.right = self.refreshHeight + ((scrollView?.bounds.size.width ?? 0) - (scrollView?.contentSize.width ?? 0))
                    isNeedRefresh = true
                    tempContentOffset.x = self.refreshHeight
//                    self.scrollView?.setContentOffset(CGPoint(x: self.refreshHeight , y: 0), animated: true )
                }
            }else{
                
                if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight {//可以刷新
                    inset.right = self.refreshHeight
                    isNeedRefresh = true
                    tempContentOffset.x = (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0) + self.refreshHeight
//                    self.scrollView?.setContentOffset(CGPoint(x: (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0) + self.refreshHeight , y: 0), animated: true )//确保能执行刷新时,才调这句代码 . 否则会出现 偏移后不执行刷新
                }
            }
            break
        }
        if isNeedRefresh {
            // MARK: 注释 a: CollectionView的isPagingEnagle = true , 会影响contentInset的设置,不会发生预设的偏移 , 所以 , 设置contentInset之前, 设置为flase , 当用户拖动时再还原到用户设定的状态
            self.scrollView?.isPagingEnabled = false
            self.performRefresh()

            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView?.contentInset = inset
                self.scrollView?.contentOffset = tempContentOffset
            })
        }
    }
    

    
    
    
    
    
    func setrefershStatusEndDrag(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复刷新 , 换成refreshing状态驱动
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -refreshHeight {//可以刷新
                if self.refreshStatus != GDRefreshStatus.refreshing {
                    self.refreshStatus = .refreshing
                    return
                }
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -refreshHeight {//可以刷新
                if self.refreshStatus != GDRefreshStatus.refreshing {
                    self.refreshStatus = .refreshing
                    return
                }
            }
            break
        case  GDDirection.bottom:
            
            if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){//可滚动区域少于滚动控件frame
                if contentOffset.y >  refreshHeight { //可以刷新
                    if self.refreshStatus != GDRefreshStatus.refreshing {
                        self.refreshStatus = .refreshing
                        return
                    }
                }
            }else{
                
                if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight {//可以刷新
                    if self.refreshStatus != GDRefreshStatus.refreshing {
                        self.refreshStatus = .refreshing
                        return
                    }
                }
            }
            break
        case  GDDirection.right:
            if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                if contentOffset.x >  refreshHeight {//可以刷新
                    if self.refreshStatus != GDRefreshStatus.refreshing {
                        self.refreshStatus = .refreshing
                        return
                    }
                }
            }else{
                
                if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight {//可以刷新
                    if self.refreshStatus != GDRefreshStatus.refreshing {
                        self.refreshStatus = .refreshing
                        return
                    }
                }
            }
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //                mylog(newPoint)//下拉变小
        if let refresh  = self.whetherCallRefreshDelegate(scrollView) {
            refresh.scrollViewDidScroll(scrollView)
        }
        if self.refreshStatus != GDRefreshStatus.refreshing {
            self.adjustContentInset(contentOffset: scrollView.contentOffset)
        }
    }
    
    func adjustContentInset(contentOffset:CGPoint)  {//实时更新图片和显示标签
        if self.refreshStatus == GDRefreshStatus.refreshing {
            return
        }
        var inset  = UIEdgeInsets.zero
        var isNeedRefresh = false
        switch self.direction {
            case  GDDirection.top:
                if contentOffset.y < -refreshHeight {//可以刷新
                    inset.top = self.refreshHeight
                    isNeedRefresh = true
                    self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                }else{//下拉以刷新
                    if contentOffset.y  >= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing)
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling)
                    }
                }
                
                break
            case  GDDirection.left:
                if contentOffset.x < -refreshHeight {//可以刷新
                    inset.left = self.refreshHeight
                    isNeedRefresh = true
                    self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                }else{//右拉以刷新
//                    self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                    if contentOffset.x  >= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing)
//                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
//                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling)
                    }
                }
                break
            case  GDDirection.bottom:
                
                if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){
                    if contentOffset.y >  refreshHeight { //可以刷新
                        self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                        mylog("松手可刷新")
                        inset.bottom = self.refreshHeight + ((scrollView?.bounds.size.height ?? 0) - (scrollView?.contentSize.height ?? 0))
                        isNeedRefresh = true
                    }else{//上拉以刷新
                        if contentOffset.y  <= self.priviousContentOffset.y{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing)
                            //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                            //                        mylog("回去")
                        }else{//pulling
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling)
//                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                            mylog("上拉以刷新")
                        }
                    }
                }else{
                    
                    if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight {//可以刷新
                        self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                        mylog("松手可刷新")
                        inset.bottom = self.refreshHeight
                        isNeedRefresh = true
                    }else{//上拉以刷新
                        if contentOffset.y  <= self.priviousContentOffset.y{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing)
                            //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                            //                        mylog("回去")
                        }else{//pulling
                            mylog("上拉以刷新")
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling)
//                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                        }
                    }
                }
                break
            case  GDDirection.right:
                if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                    if contentOffset.x >  refreshHeight {//可以刷新
                        self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                        mylog("松手可刷新")
                        inset.right = self.refreshHeight + ((scrollView?.bounds.size.width ?? 0) - (scrollView?.contentSize.width ?? 0))
                        isNeedRefresh = true
                    }else{//左拉以刷新
                        mylog("左拉以刷新")
                        if contentOffset.x  <= self.priviousContentOffset.x{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing)
                            //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                            //                        mylog("回去")
                        }else{//pulling
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling)
//                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                        }
                    }
                }else{
                    
                    if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight {//可以刷新
                        self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                        mylog("松手可刷新")
                        inset.right = self.refreshHeight
                        isNeedRefresh = true
                    }else{//左拉以刷新
                        mylog("左拉以刷新")
                        if contentOffset.x  <= self.priviousContentOffset.x{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing)
                            //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                            //                        mylog("回去")
                        }else{//pulling
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling)
//                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                        }
                    }
                }
                break
        }
        self.priviousContentOffset = contentOffset
    }
}



extension UIScrollView{
    static var gdRefreshControl: Void?
    /** 刷新控件 */
    @IBInspectable var gdRefreshControl: GDRefreshControl? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.gdRefreshControl) as? GDRefreshControl
        }
        set(newValue) {
            gdRefreshControl?.removeFromSuperview()
            self.addSubview(newValue!)
            objc_setAssociatedObject(self, &UIScrollView.gdRefreshControl, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


}



/**
 
 func adjustContentInset(contentOffset:CGPoint)  {
 var inset  = UIEdgeInsets.zero
 var isNeedRefresh = false
 switch self.direction {
 case  GDDirection.top:
 if contentOffset.y < -refreshHeight {//可以刷新
 inset.top = self.refreshHeight
 isNeedRefresh = true
 self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
 }else{//下拉以刷新
 self.updateTextAndImage(showStatus: GDShowStatus.pulling)
 }
 
 break
 case  GDDirection.left:
 if contentOffset.x < -refreshHeight {//可以刷新
 inset.left = self.refreshHeight
 isNeedRefresh = true
 self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
 }else{//右拉以刷新
 self.updateTextAndImage(showStatus: GDShowStatus.pulling)
 }
 break
 case  GDDirection.bottom:
 
 if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){
 if contentOffset.y >  refreshHeight { //可以刷新
 self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
 mylog("松手可刷新")
 inset.bottom = self.refreshHeight + ((scrollView?.bounds.size.height ?? 0) - (scrollView?.contentSize.height ?? 0))
 isNeedRefresh = true
 }else{//上拉以刷新
 mylog("上拉以刷新")
 self.updateTextAndImage(showStatus: GDShowStatus.pulling)
 }
 }else{
 
 if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight {//可以刷新
 self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
 mylog("松手可刷新")
 inset.bottom = self.refreshHeight
 isNeedRefresh = true
 }else{//上拉以刷新
 mylog("上拉以刷新")
 self.updateTextAndImage(showStatus: GDShowStatus.pulling)
 }
 }
 break
 case  GDDirection.right:
 if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
 if contentOffset.x >  refreshHeight {//可以刷新
 self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
 mylog("松手可刷新")
 inset.right = self.refreshHeight + ((scrollView?.bounds.size.width ?? 0) - (scrollView?.contentSize.width ?? 0))
 isNeedRefresh = true
 }else{//左拉以刷新
 mylog("左拉以刷新")
 self.updateTextAndImage(showStatus: GDShowStatus.pulling)
 }
 }else{
 
 if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight {//可以刷新
 self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
 mylog("松手可刷新")
 inset.right = self.refreshHeight
 isNeedRefresh = true
 }else{//左拉以刷新
 mylog("左拉以刷新")
 self.updateTextAndImage(showStatus: GDShowStatus.pulling)
 }
 }
 
 
 
 break
 }
 mylog(scrollView?.contentSize.height)
 mylog(scrollView?.bounds.size.height)
 mylog(contentOffset.y)
 mylog((scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight)
 if isNeedRefresh {
 // MARK: 注释 a: CollectionView的isPagingEnagle = true , 会影响contentInset的设置,不会发生预设的偏移 , 所以 , 设置contentInset之前, 设置为flase , 当用户拖动时再还原到用户设定的状态
 self.scrollView?.isPagingEnabled = false
 UIView.animate(withDuration: 0.25, animations: {
 self.scrollView?.contentInset = inset
 }, completion: { (true ) in
 self.performRefresh()
 })
 }
 }

 
 */



/*
 
 
 func setrefershStatusEndDrag(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复刷新 , 换成refreshing状态驱动
 var inset  = UIEdgeInsets.zero
 var isNeedRefresh = false
 switch self.direction {
 case  GDDirection.top:
 if contentOffset.y < -refreshHeight {//可以刷新
 if self.refreshStatus != GDRefreshStatus.refreshing {
 self.refreshStatus = .refreshing
 return
 }
 inset.top = self.refreshHeight
 isNeedRefresh = true
 self.scrollView?.setContentOffset(CGPoint.zero, animated: true )
 }
 
 break
 case  GDDirection.left:
 if contentOffset.x < -refreshHeight {//可以刷新
 if self.refreshStatus != GDRefreshStatus.refreshing {
 self.refreshStatus = .refreshing
 return
 }
 inset.left = self.refreshHeight
 isNeedRefresh = true
 self.scrollView?.setContentOffset(CGPoint.zero, animated: true )
 }
 break
 case  GDDirection.bottom:
 
 if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){//可滚动区域少于滚动控件frame
 if contentOffset.y >  refreshHeight { //可以刷新
 if self.refreshStatus != GDRefreshStatus.refreshing {
 self.refreshStatus = .refreshing
 return
 }
 inset.bottom = self.refreshHeight + ((scrollView?.bounds.size.height ?? 0) - (scrollView?.contentSize.height ?? 0))
 isNeedRefresh = true
 self.scrollView?.setContentOffset(CGPoint(x: 0, y: self.refreshHeight), animated: true )//确保能执行刷新时,才调这句代码 . 否则会出现 偏移后不执行刷新
 }
 }else{
 
 if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight {//可以刷新
 if self.refreshStatus != GDRefreshStatus.refreshing {
 self.refreshStatus = .refreshing
 return
 }
 inset.bottom = self.refreshHeight
 isNeedRefresh = true
 self.scrollView?.setContentOffset(CGPoint(x: 0, y: (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0) + self.refreshHeight ), animated: true )//确保能执行刷新时,才调这句代码 . 否则会出现 偏移后不执行刷新
 }
 }
 //            if refreshType == GDRefreshType.auto {
 //            }
 break
 case  GDDirection.right:
 if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
 if contentOffset.x >  refreshHeight {//可以刷新
 if self.refreshStatus != GDRefreshStatus.refreshing {
 self.refreshStatus = .refreshing
 return
 }
 inset.right = self.refreshHeight + ((scrollView?.bounds.size.width ?? 0) - (scrollView?.contentSize.width ?? 0))
 isNeedRefresh = true
 self.scrollView?.setContentOffset(CGPoint(x: self.refreshHeight , y: 0), animated: true )
 }
 }else{
 
 if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight {//可以刷新
 if self.refreshStatus != GDRefreshStatus.refreshing {
 self.refreshStatus = .refreshing
 return
 }
 inset.right = self.refreshHeight
 isNeedRefresh = true
 self.scrollView?.setContentOffset(CGPoint(x: (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0) + self.refreshHeight , y: 0), animated: true )//确保能执行刷新时,才调这句代码 . 否则会出现 偏移后不执行刷新
 }
 }
 //            if refreshType == GDRefreshType.auto {
 //
 //            }
 break
 }
 return
 
 
 
 
 if isNeedRefresh {
 // MARK: 注释 a: CollectionView的isPagingEnagle = true , 会影响contentInset的设置,不会发生预设的偏移 , 所以 , 设置contentInset之前, 设置为flase , 当用户拖动时再还原到用户设定的状态
 self.scrollView?.isPagingEnabled = false
 //            if self.direction == GDDirection.bottom {
 //                self.scrollView?.setContentOffset(CGPoint(x: 0, y: refreshHeight ), animated: true )
 //            }
 UIView.animate(withDuration: 0.25, animations: {
 self.scrollView?.contentInset = inset
 
 }, completion: { (true ) in
 self.performRefresh()
 })
 }
 }
 
 

 */

