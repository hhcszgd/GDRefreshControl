//
//  GDLoadControl.swift
//  zjlao
//
//  Created by WY on 28/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//
//

import UIKit

// MARK: 注释 : 加载结果
enum GDLoadResult {
    case success
    case failure
    case networkError
    case nomore
}

// MARK: 注释 : 加载控件显示状态
enum GDLoadShowStatus {
    case idle
    case pulling
    case prepareLoading
    case loading
    case loaded
    case loadSuccess
    case nomore
    case backing
    case loadFailure
    case netWorkError
    
}
// MARK: 注释 :  加载控件当前状态
enum GDLoadStatus {
    case idle
    case pulling
    case loading
    case backing
}

class GDLoadControl: UIControl {
    lazy var titleLabel = UILabel()
    lazy var imageView  = UIImageView()
    var loadHeight : CGFloat = 60
    
    
    fileprivate var originalIspagingEnable = false
    fileprivate var originalContentInset = UIEdgeInsets.zero
    fileprivate var originalContentOffset = CGPoint.zero
    
    fileprivate var priviousContentOffset = CGPoint.zero
    fileprivate var showStatus = GDLoadShowStatus.idle
    
    
    var direction : GDDirection = GDDirection.bottom
    fileprivate var scrollView : UIScrollView?
    
    fileprivate weak var loadTarget : AnyObject?
    fileprivate var loadAction : Selector?
    
    var loadStatus = GDLoadStatus.idle{
        
        didSet{
            if loadStatus != GDLoadStatus.loading {    return  }
            if oldValue == loadStatus {return}
            
            switch self.direction {
            case  GDDirection.top:
                let y = -loadHeight - 1.0
                //                self.setrefershStatusEndDrag(contentOffset:CGPoint(x: 0, y: y) )
                self.performLoadAfterSetLoadingStatus(contentOffset: CGPoint(x: 0, y: y))
                //                if (self.scrollView?.contentOffset.y ?? 0) < -loadHeight {//可以加载
                //
                //                }
                
                break
            case  GDDirection.left:
                if (self.scrollView?.contentOffset.x ?? 0 ) < -loadHeight {//可以加载
                }
                let x = -loadHeight - 1.0
                //                self.setrefershStatusEndDrag(contentOffset:CGPoint(x: x, y: 0) )
                self.performLoadAfterSetLoadingStatus(contentOffset: CGPoint(x: x, y: 0))
                
                break
            case  GDDirection.bottom:
                
                if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){
                    //                    if (scrollView?.contentOffset.y ?? 0) >  loadHeight { //可以加载
                    //
                    //
                    //                    }
                    let y = loadHeight + 1.0
                    //                    self.setrefershStatusEndDrag(contentOffset:CGPoint(x: 0, y: y))
                    self.performLoadAfterSetLoadingStatus(contentOffset: CGPoint(x: 0, y: y))
                    
                }else{
                    
                    //                    if (self.scrollView?.contentOffset.y ?? 0 ) > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + loadHeight {//可以加载
                    //
                    //                    }
                    
                    let y = (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + loadHeight + 1.0
                    //                        self.setrefershStatusEndDrag(contentOffset:CGPoint(x: 0, y: y) )
                    self.performLoadAfterSetLoadingStatus(contentOffset: CGPoint(x: 0, y: y))
                }
                break
            case  GDDirection.right:
                if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                    let x = loadHeight + 1
                    //                       self.setrefershStatusEndDrag(contentOffset:CGPoint(x:x, y: 0) )
                    self.performLoadAfterSetLoadingStatus(contentOffset: CGPoint(x: x, y: 0))
                    
                }else{
                    
                    //                    if (self.scrollView?.contentOffset.x ?? 0) > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + loadHeight {//可以加载
                    let x = (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + loadHeight + 1
                    //                        self.setrefershStatusEndDrag(contentOffset:CGPoint(x:x, y: 0) )
                    self.performLoadAfterSetLoadingStatus(contentOffset: CGPoint(x: x, y: 0))
                    
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
        self.loadTarget = target
        self.loadAction = selector
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}



// MARK: 注释 : control
extension GDLoadControl {
    
    
    func addTarget(_ target: Any?, loadAction: Selector) {
        self.loadTarget = target as AnyObject
        self.loadAction = loadAction
    }
    
    

    
    func performLoad()  {//避免重复加载
//        mylog("开始加载  偏移量\(String(describing: self.scrollView?.contentOffset))")
        
        self.updateTextAndImage(showStatus: GDLoadShowStatus.loading , actionType: GDLoadShowStatus.loading)
        mylog(scrollView?.contentInset)
        if self.loadAction != nil && self.loadTarget != nil {
            _  = self.loadTarget!.perform(self.loadAction!)
        }
    }
    
    func endLoad(result : GDLoadResult = GDLoadResult.success)  {
        var delay : TimeInterval = 1
        
        if  self.loadStatus == GDLoadStatus.loading {
//            mylog("结束加载 偏移量\(String(describing: self.scrollView?.contentOffset))")
            if result == GDLoadResult.success {
                delay = 0
                self.updateTextAndImage(showStatus: GDLoadShowStatus.loadSuccess , actionType:  GDLoadShowStatus.loaded)
            }else if result == GDLoadResult.failure{
                self.updateTextAndImage(showStatus: GDLoadShowStatus.loadFailure , actionType:  GDLoadShowStatus.loaded)
            }else if result == GDLoadResult.networkError{
                self.updateTextAndImage(showStatus: GDLoadShowStatus.netWorkError , actionType:  GDLoadShowStatus.loaded)
            }else if result == GDLoadResult.nomore{
                self.updateTextAndImage(showStatus: GDLoadShowStatus.nomore , actionType:  GDLoadShowStatus.loaded)
            }
            //            self.updateTextAndImage(contentOffset: CGPoint.zero)//
            UIView.animate(withDuration: 0.1, delay: delay, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                if self.scrollView != nil {
                    self.fixFrame(scrollView: self.scrollView!)
                }
            }) { (bool) in
                self.loadStatus = GDLoadStatus.idle
            }
        }
    }
}




// MARK: 注释 : updateUI
extension GDLoadControl {
    
    
    
    func updateTextAndImage(showStatus : GDLoadShowStatus , actionType : GDLoadShowStatus = GDLoadShowStatus.pulling/*拖动中还是弹回中*/,contentOffset : CGPoint = CGPoint.zero)  {
        var title  = ""
        
        if showStatus == GDLoadShowStatus.pulling && actionType == GDLoadShowStatus.pulling {
            //下拉以加载
            title = "拖动以加载"
        }else if showStatus == GDLoadShowStatus.pulling && actionType == GDLoadShowStatus.backing && self.loadStatus != GDLoadStatus.loading{
            //下拉以加载
            title = "拖动以加载"
        }else if showStatus == GDLoadShowStatus.prepareLoading  {
            title = "松手加载"
            //松手以加载
        }else if showStatus == GDLoadShowStatus.loading && actionType == GDLoadShowStatus.loading{
            title = "加载中"
            //加载中
        }else if showStatus ==  GDLoadShowStatus.loadSuccess && actionType == GDLoadShowStatus.loaded{
            title = "加载成功"
            //加载成功
        }else if showStatus ==  GDLoadShowStatus.loadFailure && actionType == GDLoadShowStatus.loaded{
            title = "加载失败"
            //加载失败
        }else if showStatus ==  GDLoadShowStatus.netWorkError && actionType == GDLoadShowStatus.loaded{
            title = "网络错误"
            //网络错误
        }else if showStatus ==  GDLoadShowStatus.nomore && actionType == GDLoadShowStatus.loaded{
            title = "没有更多数据"
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
            self.frame = CGRect(x: 0, y: -loadHeight, width: scrollView.bounds.size.width, height: loadHeight)
            self.titleLabel.frame = CGRect(x: 0, y: self.bounds.size.height - self.titleLabel.font.lineHeight, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
            
            break
        case  GDDirection.left:
            self.frame = CGRect(x: -loadHeight, y: 0, width: loadHeight, height: scrollView.bounds.size.height)
            self.titleLabel.frame = CGRect(x: self.bounds.size.width - self.titleLabel.font.lineHeight, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
            break
        case  GDDirection.bottom:
            
            if scrollView.contentSize.height < scrollView.bounds.size.height{
                self.frame = CGRect(x: 0, y: scrollView.bounds.size.height, width:scrollView.bounds.size.width  ,  height: loadHeight)
            }else{
                self.frame = CGRect(x: 0, y: scrollView.contentSize.height , width:scrollView.bounds.size.width  ,  height: loadHeight)
            }
            self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
            break
        case  GDDirection.right:
            
            if scrollView.contentSize.width < scrollView.bounds.size.width{
                self.frame = CGRect(x: scrollView.bounds.size.width, y: 0, width: loadHeight  ,  height: scrollView.bounds.size.height )
            }else{
                
                self.frame = CGRect(x: scrollView.contentSize.width, y: 0, width: loadHeight, height: scrollView.bounds.size.height)
            }
            self.titleLabel.frame = CGRect(x: self.titleLabel.font.lineHeight, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
            break
        }
    }
    
    
    
}

// MARK: 注释 : KVO
extension GDLoadControl {
    
    
    
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
//            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                //                mylog(newPoint)//下拉变小

//            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
}



// MARK: 注释 : UIScrollViewDelegate
extension GDLoadControl : UIScrollViewDelegate{
    
    
    // MARK: 注释 : 是否调用刷新控件的代理
    func whetherCallRefreshDelegate(_ scrollView:UIScrollView) -> GDRefreshControl?  {
        if let _ =  scrollView.delegate as? GDLoadControl {
            if let refresh  = scrollView.gdRefreshControl  {
                return refresh
            }
        }
        return nil
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let refresh  = self.whetherCallRefreshDelegate(scrollView) {
            refresh.scrollViewWillBeginDragging(scrollView)
        }
        self.fixFrame(scrollView: scrollView)
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
        if self.loadStatus != GDLoadStatus.loading {
            self.setrefershStatusEndDrag(contentOffset: scrollView.contentOffset)
            
        }
        
    }
    
    
    
    
    
    func performLoadAfterSetLoadingStatus(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复加载 , 换成loading状态驱动
        var inset  = UIEdgeInsets.zero
        var isNeedLoad = false
        
        
        //TODO  抽出目标contentOffset 分别赋值 , 再在底部动画与contentInset一起赋值(目前问题 , 达到加载条件后 ,松手会偶尔出现滚动视图乱跳)
        var tempContentOffset  = CGPoint.zero
        
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -loadHeight {//可以加载
                inset.top = self.loadHeight
                isNeedLoad = true
                //                let contentOffset = CGPoint(x: 0, y: 0)
                //                self.scrollView?.setContentOffset(contentOffset, animated: true )
                tempContentOffset.y = -loadHeight
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -loadHeight {//可以加载
                inset.left = self.loadHeight
                isNeedLoad = true
                tempContentOffset.x = -loadHeight
                //                self.scrollView?.setContentOffset(CGPoint.zero, animated: true )
            }
            break
        case  GDDirection.bottom:
            
            if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){//可滚动区域少于滚动控件frame
                if contentOffset.y >  loadHeight { //可以加载
                    inset.bottom = self.loadHeight + ((scrollView?.bounds.size.height ?? 0) - (scrollView?.contentSize.height ?? 0))
                    isNeedLoad = true
                    tempContentOffset.y = loadHeight
                    
                }
            }else{
                
                if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + loadHeight {//可以加载
                    inset.bottom = self.loadHeight
                    isNeedLoad = true
                    tempContentOffset.y = (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0) + self.loadHeight
                }
            }
            break
        case  GDDirection.right:
            if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                if contentOffset.x >  loadHeight {//可以加载
                    inset.right = self.loadHeight + ((scrollView?.bounds.size.width ?? 0) - (scrollView?.contentSize.width ?? 0))
                    isNeedLoad = true
                    tempContentOffset.x = self.loadHeight
                    //                    self.scrollView?.setContentOffset(CGPoint(x: self.loadHeight , y: 0), animated: true )
                }
            }else{
                
                if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + loadHeight {//可以加载
                    inset.right = self.loadHeight
                    isNeedLoad = true
                    tempContentOffset.x = (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0) + self.loadHeight
                }
            }
            break
        }
        if isNeedLoad {
            // MARK: 注释 a: CollectionView的isPagingEnagle = true , 会影响contentInset的设置,不会发生预设的偏移 , 所以 , 设置contentInset之前, 设置为flase , 当用户拖动时再还原到用户设定的状态
            self.scrollView?.isPagingEnabled = false
            self.performLoad()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView?.contentInset = inset
                self.scrollView?.contentOffset = tempContentOffset
            })
        }
    }
    
    
    
    
    
    
    
    func setrefershStatusEndDrag(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复加载 , 换成loading状态驱动
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -loadHeight {//可以加载
                if self.loadStatus != GDLoadStatus.loading {
                    self.loadStatus = .loading
                    return
                }
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -loadHeight {//可以加载
                if self.loadStatus != GDLoadStatus.loading {
                    self.loadStatus = .loading
                    return
                }
            }
            break
        case  GDDirection.bottom:
            
            if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){//可滚动区域少于滚动控件frame
                if contentOffset.y >  loadHeight { //可以加载
                    if self.loadStatus != GDLoadStatus.loading {
                        self.loadStatus = .loading
                        return
                    }
                }
            }else{
                
                if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + loadHeight {//可以加载
                    if self.loadStatus != GDLoadStatus.loading {
                        self.loadStatus = .loading
                        return
                    }
                }
            }
            break
        case  GDDirection.right:
            if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                if contentOffset.x >  loadHeight {//可以加载
                    if self.loadStatus != GDLoadStatus.loading {
                        self.loadStatus = .loading
                        return
                    }
                }
            }else{
                
                if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + loadHeight {//可以加载
                    if self.loadStatus != GDLoadStatus.loading {
                        self.loadStatus = .loading
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
        if self.loadStatus != GDLoadStatus.loading {
            self.adjustContentInset(contentOffset: scrollView.contentOffset)
        }
    }
    
    func adjustContentInset(contentOffset:CGPoint)  {//实时更新图片和显示标签
        if self.loadStatus == GDLoadStatus.loading {
            return
        }
//        var inset  = UIEdgeInsets.zero
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -loadHeight {//可以加载
//                inset.top = self.loadHeight
                self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
            }else{//下拉以加载
                if contentOffset.y  >= self.priviousContentOffset.y{//backing
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing)
                }else{//pulling
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling)
                }
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -loadHeight {//可以加载
//                inset.left = self.loadHeight
                self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
            }else{//右拉以加载
                //                    self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                if contentOffset.x  >= self.priviousContentOffset.x{//backing
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing)
                    //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                    //                        mylog("回去")
                }else{//pulling
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling)
                }
            }
            break
        case  GDDirection.bottom:
            
            if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){
                if contentOffset.y >  loadHeight { //可以加载
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
//                    mylog("松手可加载")
//                    inset.bottom = self.loadHeight + ((scrollView?.bounds.size.height ?? 0) - (scrollView?.contentSize.height ?? 0))
                }else{//上拉以加载
                    if contentOffset.y  <= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing)
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling)
                        //                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
//                        mylog("上拉以加载")
                    }
                }
            }else{
                
                if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + loadHeight {//可以加载
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
//                    mylog("松手可加载")
//                    inset.bottom = self.loadHeight
                }else{//上拉以加载
                    if contentOffset.y  <= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing)
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
//                        mylog("上拉以加载")
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling)
                        //                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                    }
                }
            }
            break
        case  GDDirection.right:
            if (scrollView?.contentSize.width ?? 0) < (scrollView?.bounds.size.width ?? 0){
                if contentOffset.x >  loadHeight {//可以加载
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
//                    mylog("松手可加载")
//                    inset.right = self.loadHeight + ((scrollView?.bounds.size.width ?? 0) - (scrollView?.contentSize.width ?? 0))
                }else{//左拉以加载
//                    mylog("左拉以加载")
                    if contentOffset.x  <= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing)
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling)
                        //                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                    }
                }
            }else{
                
                if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + loadHeight {//可以加载
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
//                    mylog("松手可加载")
//                    inset.right = self.loadHeight
                }else{//左拉以加载
//                    mylog("左拉以加载")
                    if contentOffset.x  <= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing)
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling)
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
    static var gdLoadControl: Void?
    /** 加载控件 */
    @IBInspectable var gdLoadControl: GDLoadControl? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.gdLoadControl) as? GDLoadControl
        }
        set(newValue) {
            gdLoadControl?.removeFromSuperview()
            self.addSubview(newValue!)
            objc_setAssociatedObject(self, &UIScrollView.gdLoadControl, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
}

