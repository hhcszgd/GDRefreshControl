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
public enum GDLoadResult {
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
public enum GDLoadStatus {
    case idle
    case pulling
    case loading
    case backing
    case nomore
}

public class GDLoadControl: GDBaseControl {
    public var loadHeight : CGFloat = 64
    public var pullingImages : [UIImage] = pullingImgsForLoad(){
        didSet{
        }
    }
    public var loadingImages : [UIImage] = loadingImgs(){
        didSet{
            
        }
    }
    
    public var networkErrorImage : UIImage = networkErrorImageForLoad(){
        didSet{
            
        }
    }
    
    public var successImage : UIImage = successImagesForLoad(){
        didSet{
            
        }
    }
    
    public var failureImage : UIImage = failureImagesForLoad(){
        didSet{
            
        }
    }
    public var nomoreImage : UIImage = nomoreImageForLoad(){
        didSet{
            
        }
    }
    public var pullingStr = "拖动以加载"
    public var loosenStr = "松开加载"
    public var loadingStr = "加载中"
    public var successStr = "加载成功"
    public var failureStr = "加载失败"
    public var networkErrorStr = "网络错误"
    public var nomoreStr = "没有更多数据"
    /**
     
     title = "加载成功"
     self.imageView.image = self.successImage
     //加载成功
     }else if showStatus ==  GDLoadShowStatus.loadFailure && actionType == GDLoadShowStatus.loaded{
     title = "加载失败"
     self.imageView.image = self.failureImage
     //加载失败
     }else if showStatus ==  GDLoadShowStatus.netWorkError && actionType == GDLoadShowStatus.loaded{
     title = "网络错误"
     self.imageView.image = self.networkErrorImage
     //网络错误
     }else if showStatus ==  GDLoadShowStatus.nomore && actionType == GDLoadShowStatus.loaded{
     title = "没有更多数据"
     */
    var priviousFrame : CGRect = CGRect.zero
    var showStatus = GDLoadShowStatus.idle
    
    
    private weak var loadTarget : AnyObject?
    private var loadAction : Selector?
    
    public var loadStatus = GDLoadStatus.idle{
        
        didSet{
            if loadStatus != GDLoadStatus.loading {    return  }
            if oldValue == loadStatus {return}
            
            switch self.direction {
            case  GDDirection.top:
                let y =  -(loadHeight + originalContentInset.top) - 1.0 // 减 1 是为了满足触发刷新的条件
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
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.numberOfLines = 0
    }
    
    public convenience  init(target: AnyObject? , selector : Selector?) {
        self.init(frame: CGRect.zero)
        self.loadTarget = target
        self.loadAction = selector
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    ///:scroll view delegate
    
    public override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // MARK: 注释 a: 当用户拖动时 , 还原滚动控件的isPagingEnable
        if scrollView.isPagingEnabled != self.originalIspagingEnable {
            self.scrollView?.isPagingEnabled = self.originalIspagingEnable
        }
        
    }
    
    
    public override  func scrollViewDidEndDragging(_ scrollView: UIScrollView){
        mylog("松手了  ,当前偏移量是\(scrollView.contentOffset)")
        
        if self.loadStatus != GDLoadStatus.loading {
            self.setrefershStatusEndDrag(contentOffset: scrollView.contentOffset)
            
        }
        
    }
    
    public override func scrollViewContentSizeChanged(){
        
        if let scroll = self.scrollView {
            mylog("监听contentSize : \(String(describing: scroll.contentSize))")
            self.fixFrame(scrollView: scroll)//自动布局是 , scrollView的contentSize是动态变化的, 所以要实时调整加载控件的frame
        }
    }
    
    
    
    func performLoadAfterSetLoadingStatus(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复加载 , 换成loading状态驱动
        var inset  = UIEdgeInsets.zero
        var isNeedLoad = false
        
        
        //TODO  抽出目标contentOffset 分别赋值 , 再在底部动画与contentInset一起赋值(目前问题 , 达到加载条件后 ,松手会偶尔出现滚动视图乱跳)
        var tempContentOffset  = CGPoint.zero
        
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -(loadHeight + originalContentInset.top) {//可以加载
                inset.top = self.loadHeight + originalContentInset.top
                isNeedLoad = true
                //                let contentOffset = CGPoint(x: 0, y: 0)
                //                self.scrollView?.setContentOffset(contentOffset, animated: true )
                tempContentOffset.y = -(loadHeight + originalContentInset.top)
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
            
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.scrollView?.contentInset = inset
                self.scrollView?.contentOffset = tempContentOffset
            }, completion: { (bool ) in
                self.scrollView?.isPagingEnabled = false
                self.performLoad()
                
            })
            
        }
    }
    
    
    
    
    
    
    
    func setrefershStatusEndDrag(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复加载 , 换成loading状态驱动
        if self.loadStatus == GDLoadStatus.nomore {
            return
        }
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y <  -(loadHeight + originalContentInset.top) {//可以加载
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
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //                mylog(newPoint)//下拉变小
        
        if self.loadStatus != GDLoadStatus.loading {
            self.adjustContentInset(contentOffset: scrollView.contentOffset)
        }
    }
    
    func adjustContentInset(contentOffset:CGPoint)  {//实时更新图片和显示标签
        if self.loadStatus == GDLoadStatus.loading || self.loadStatus == GDLoadStatus.nomore {
            return
        }
        //        var inset  = UIEdgeInsets.zero
        //        mylog(self.frame)
        //        mylog(self.scrollView?.contentOffset)
        switch self.direction {
        case  GDDirection.top:
            var scale : CGFloat   = 0
            
            if contentOffset.y <=  -originalContentInset.top && contentOffset.y >=  -(loadHeight + originalContentInset.top)    {
                
                scale = (-contentOffset.y - originalContentInset.top)  / loadHeight
                mylog(scale)
                
            }
            
            
            if contentOffset.y < -(loadHeight + originalContentInset.top) {//可以加载
                //                inset.top = self.loadHeight
                self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
            }else{//下拉以加载
                if contentOffset.y  >= self.priviousContentOffset.y{//backing
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing, scale: scale)
                }else{//pulling
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale: scale)
                }
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -loadHeight {//可以加载
                //                inset.left = self.loadHeight
                self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
            }else{//右拉以加载
                //  self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                
                
                var scale : CGFloat   = 0
                
                if contentOffset.x <=  0 && contentOffset.x >=  -loadHeight   {
                    
                    scale = -contentOffset.x  / loadHeight
                    mylog(scale)
                    
                }
                
                
                
                if contentOffset.x  >= self.priviousContentOffset.x{//backing
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale:  scale)
                    //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                    //                        mylog("回去")
                }else{//pulling
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale:  scale)
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
                    
                    var scale : CGFloat   = 0
                    
                    if contentOffset.y >=  0 && contentOffset.y <=  loadHeight   {
                        
                        scale = contentOffset.y  / loadHeight
                        mylog(scale)
                        
                    }
                    
                    
                    
                    if contentOffset.y  <= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
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
                    var scale : CGFloat   = 0
                    
                    if contentOffset.y <=  (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + loadHeight && contentOffset.y >=  (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 )   {
                        
                        scale = (contentOffset.y - ((scrollView?.contentSize.height ?? 0)  - (scrollView?.bounds.size.height ?? 0 ) ) ) / loadHeight
                        mylog(scale)
                        
                    }
                    
                    if contentOffset.y  <= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        //                        mylog("上拉以加载")
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
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
                    
                    var scale : CGFloat   = 0
                    
                    if contentOffset.x >=  0 && contentOffset.x <=  loadHeight   {
                        
                        scale = contentOffset.x  / loadHeight
                        mylog(scale)
                        
                    }
                    
                    
                    
                    if contentOffset.x  <= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
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
                    
                    var scale : CGFloat   = 0
                    
                    if contentOffset.x <=  (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + loadHeight && contentOffset.x >=  (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 )   {
                        
                        scale = (contentOffset.x - ((scrollView?.contentSize.width ?? 0)  - (scrollView?.bounds.size.width ?? 0 ) ) ) / loadHeight
                        mylog(scale)
                        
                    }
                    
                    
                    
                    
                    if contentOffset.x  <= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
                        //                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                    }
                }
            }
            break
        }
        self.priviousContentOffset = contentOffset
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
//        mylog("开始加载 frame \(String(describing: self.frame))")
//        mylog("contentOffset : String(describing: \(self.scrollView?.contentOffs)et))")
        self.updateTextAndImage(showStatus: GDLoadShowStatus.loading , actionType: GDLoadShowStatus.loading)
        mylog(scrollView?.contentInset)
        if self.loadAction != nil && self.loadTarget != nil {
            _  = self.loadTarget!.perform(self.loadAction!)
        }
    }
    
    /// call after reloadData(tableView)
    ///
    /// - Parameter result:  forExample : success , networkError , nomore
    public func endLoad(result : GDLoadResult = GDLoadResult.success)  {
        mylog(Thread.current)
        if  self.loadStatus == GDLoadStatus.loading {
            mylog("结束加载 frame \(String(describing: self.frame))")
//            mylog("contentOffset : String(describing: \(self.scrollView?.contentOffs)et))")
            if result == GDLoadResult.success {
                self.updateTextAndImage(showStatus: GDLoadShowStatus.loadSuccess , actionType:  GDLoadShowStatus.loaded)
            }else if result == GDLoadResult.failure{
                self.updateTextAndImage(showStatus: GDLoadShowStatus.loadFailure , actionType:  GDLoadShowStatus.loaded)
            }else if result == GDLoadResult.networkError{
                self.updateTextAndImage(showStatus: GDLoadShowStatus.netWorkError , actionType:  GDLoadShowStatus.loaded)
            }else if result == GDLoadResult.nomore{
                self.updateTextAndImage(showStatus: GDLoadShowStatus.nomore , actionType:  GDLoadShowStatus.loaded)
            }
            
            if result == GDLoadResult.success {
//                self.scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                self.scrollView?.contentInset = originalContentInset
                self.loadStatus = GDLoadStatus.idle
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//                    mylog(Thread.current )
//                    self.scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                    self.scrollView?.contentInset = self.originalContentInset
                }) { (bool) in
                    if result == GDLoadResult.nomore {
                        self.loadStatus = GDLoadStatus.nomore
                    }else{
                        self.loadStatus = GDLoadStatus.idle
                    }
//                    mylog("加载完成 frame \(String(describing: self.frame))")
//                    mylog("contentOffset : String(describing: \(self.scrollView?.contentOffs)et))")
                }
            }

        }
    }
}




// MARK: 注释 : updateUI
extension GDLoadControl {
    
    
    
    func updateTextAndImage(showStatus : GDLoadShowStatus , actionType : GDLoadShowStatus = GDLoadShowStatus.pulling/*拖动中还是弹回中*/,scale : CGFloat = 0.0)  {
        if self.imageView.isAnimating {
            self.imageView.stopAnimating()
        }
        var title  = ""
        
        if showStatus == GDLoadShowStatus.pulling && actionType == GDLoadShowStatus.pulling {
            //下拉以加载
            title = pullingStr
            let a : Int =  Int(( CGFloat( self.pullingImages.count) * scale))
            if a > 0 && a < self.pullingImages.count {
                self.imageView.image = self.pullingImages[a]
                
            }
        }else if showStatus == GDLoadShowStatus.pulling && actionType == GDLoadShowStatus.backing && self.loadStatus != GDLoadStatus.loading{
            //下拉以加载
            title = pullingStr
            let a : Int =  Int(( CGFloat( self.pullingImages.count) * scale))
            if a > 0 && a < self.pullingImages.count {
                self.imageView.image = self.pullingImages[a]
                
            }
        }else if showStatus == GDLoadShowStatus.prepareLoading  {
            title = loosenStr
            //松手以加载
        }else if showStatus == GDLoadShowStatus.loading && actionType == GDLoadShowStatus.loading{
            title = loadingStr
            self.imageView.animationImages = self.loadingImages
            self.imageView.animationDuration = 0.5
            self.imageView.animationRepeatCount = 19
            self.imageView.startAnimating()
            //加载中
        }else if showStatus ==  GDLoadShowStatus.loadSuccess && actionType == GDLoadShowStatus.loaded{
            title = successStr
            self.imageView.image = self.successImage
            //加载成功
        }else if showStatus ==  GDLoadShowStatus.loadFailure && actionType == GDLoadShowStatus.loaded{
            title = failureStr
            self.imageView.image = self.failureImage
            //加载失败
        }else if showStatus ==  GDLoadShowStatus.netWorkError && actionType == GDLoadShowStatus.loaded{
            title = networkErrorStr
            self.imageView.image = self.networkErrorImage
            //网络错误
        }else if showStatus ==  GDLoadShowStatus.nomore && actionType == GDLoadShowStatus.loaded{
            title = nomoreStr
            self.imageView.image = self.nomoreImage
            //网络错误
        }
        
        
        
        
        let attributeTitle = NSMutableAttributedString.init(string: title)
        //            str.addAttribute(kCTVerticalFormsAttributeName as String, value: true , range:NSMakeRange(0, title.characters.count))
        
        //            str.addAttribute(NSVerticalGlyphFormAttributeName as String, value: NSNumber.init(value: 1) , range:NSMakeRange(0, title.characters.count))
        self.titleLabel.attributedText = attributeTitle
        
        self.showStatus = showStatus
        
    }
    
    func fixFrame(scrollView : UIScrollView)  {
        if self.loadStatus == GDLoadStatus.loading {
//            return
        }
        switch self.direction {
        case  GDDirection.top:
            self.frame = CGRect(x: 0, y: -loadHeight, width: scrollView.bounds.size.width, height: loadHeight)
            if self.labelFrame == CGRect.zero {
                self.titleLabel.frame = CGRect(x: 10, y: self.bounds.size.height * 0.4, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
            }else{
                self.titleLabel.frame = self.labelFrame
            }
            if self.imageViewFrame == CGRect.zero {
                self.imageView.frame = CGRect(x: 10, y: self.bounds.size.height * 0.1, width: self.bounds.size.height * 0.8, height: self.bounds.size.height * 0.8)
            }else{
                self.imageView.frame = self.imageViewFrame
            }
            
            break
        case  GDDirection.left:
            self.frame = CGRect(x: -loadHeight, y: 0, width: loadHeight, height: scrollView.bounds.size.height)
            if self.labelFrame == CGRect.zero {
                self.titleLabel.frame = CGRect(x: self.bounds.size.width * 0.5, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
            }else{
                self.titleLabel.frame = self.labelFrame
            }
            
            if self.imageViewFrame == CGRect.zero {
                self.imageView.frame = CGRect(x: self.bounds.size.width * 0.1, y: 10, width: self.bounds.size.width * 0.8, height: self.bounds.size.width * 0.8)
            }else{
                self.imageView.frame = self.imageViewFrame
            }
            
            break
        case  GDDirection.bottom:
            
            if scrollView.contentSize.height < scrollView.bounds.size.height{
                self.frame = CGRect(x: 0, y: scrollView.bounds.size.height, width:scrollView.bounds.size.width  ,  height: loadHeight)
            }else{
                self.frame = CGRect(x: 0, y: scrollView.contentSize.height , width:scrollView.bounds.size.width  ,  height: loadHeight)
            }
            if self.labelFrame == CGRect.zero {
            
                self.titleLabel.frame = CGRect(x: 0, y: self.bounds.size.height * 0.4, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
            }else{
                self.titleLabel.frame = self.labelFrame
            }
            if self.imageViewFrame == CGRect.zero {
                
                self.imageView.frame = CGRect(x: 10, y: self.bounds.size.height * 0.2, width: self.bounds.size.height * 0.8, height: self.bounds.size.height * 0.8)
            }else{
                self.imageView.frame = self.imageViewFrame
            }
            break
        case  GDDirection.right:
            
            if scrollView.contentSize.width < scrollView.bounds.size.width{
                self.frame = CGRect(x: scrollView.bounds.size.width, y: 0, width: loadHeight  ,  height: scrollView.bounds.size.height )
            }else{
                
                self.frame = CGRect(x: scrollView.contentSize.width, y: 0, width: loadHeight, height: scrollView.bounds.size.height)
            }
            if self.labelFrame == CGRect.zero {
                self.titleLabel.frame = CGRect(x: self.titleLabel.font.lineHeight, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
            }else{
                self.titleLabel.frame = self.labelFrame
            }
            
            if self.imageViewFrame == CGRect.zero{
                self.imageView.frame = CGRect(x: self.bounds.size.width * 0.1, y: 10, width: self.bounds.size.width * 0.8, height: self.bounds.size.width * 0.8)
            }else{
                self.imageView.frame = self.imageViewFrame
            }
            
            break
        }
        
        self.priviousFrame = self.frame
    }
    
    
    
}

// MARK: 注释 : KVO
extension GDLoadControl {
    
    
    /*
    override public func willMove(toSuperview newSuperview: UIView?) {//important
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil  {//将要从tableView上移除之前(提前与deinit),先移除scrollView的contentOffset的监听 , 否则会崩溃
            if let scrollView = self.superview as? UIScrollView {
                scrollView.removeObserver(self , forKeyPath: "contentOffset")
                scrollView.removeObserver(self , forKeyPath: "contentInset")
                scrollView.removeObserver(self , forKeyPath: "contentSize")
            }
        }else{
            if let scrollView = newSuperview as? UIScrollView {
                self.scrollView = scrollView
                self.originalIspagingEnable = scrollView.isPagingEnabled
                self.originalContentInset = scrollView.contentInset
                self.originalContentOffset = scrollView.contentOffset
                mylog("最初赋值时 , 滚动控件的滚动范围\(scrollView.contentSize)")
                self.fixFrame(scrollView: scrollView)
//                scrollView.delegate = self//监听contentOffset改用代理的形式
                scrollView.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
                scrollView.addObserver(self , forKeyPath: "contentInset", options: NSKeyValueObservingOptions.new, context: nil)
                scrollView.addObserver(self , forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            }
        }
    }
    
    override public func layoutSubviews() {
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
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        mylog(keyPath)
        if keyPath != nil && keyPath! == "contentOffset" {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
//                mylog("监听contentOffset\(newPoint)")//下拉变小
                if self.loadStatus != GDLoadStatus.loading {
                    self.adjustContentInset(contentOffset: newPoint)
                }
            }
        }else if keyPath != nil && keyPath! == "contentInset"{
             let newPoint = change?[NSKeyValueChangeKey.newKey]
            mylog("监听contentInset\(String(describing: newPoint))")


        }else if keyPath != nil && keyPath! == "contentSize"{
            let newPoint = change?[NSKeyValueChangeKey.newKey]
            mylog("监听contentSize\(String(describing: newPoint))")
        
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    */
    
}



// MARK: 注释 : UIScrollViewDelegate
/*
 
extension GDLoadControl {
    
    

    
    public override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        // MARK: 注释 a: 当用户拖动时 , 还原滚动控件的isPagingEnable
        if scrollView.isPagingEnabled != self.originalIspagingEnable {
            self.scrollView?.isPagingEnabled = self.originalIspagingEnable
        }
        
    }
    
    
    public override  func scrollViewDidEndDragging(_ scrollView: UIScrollView){
        mylog("松手了  ,当前偏移量是\(scrollView.contentOffset)")

        if self.loadStatus != GDLoadStatus.loading {
            self.setrefershStatusEndDrag(contentOffset: scrollView.contentOffset)
            
        }
        
    }
    
    public override func scrollViewContentSizeChanged(){

        if let scroll = self.scrollView {
            mylog("监听contentSize : \(String(describing: scroll.contentSize))")
            self.fixFrame(scrollView: scroll)//自动布局是 , scrollView的contentSize是动态变化的, 所以要实时调整加载控件的frame
        }
    }
    
    
    
    func performLoadAfterSetLoadingStatus(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复加载 , 换成loading状态驱动
        var inset  = UIEdgeInsets.zero
        var isNeedLoad = false
        
        
        //TODO  抽出目标contentOffset 分别赋值 , 再在底部动画与contentInset一起赋值(目前问题 , 达到加载条件后 ,松手会偶尔出现滚动视图乱跳)
        var tempContentOffset  = CGPoint.zero
        
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -(loadHeight + originalContentInset.top) {//可以加载
                inset.top = self.loadHeight + originalContentInset.top
                isNeedLoad = true
                //                let contentOffset = CGPoint(x: 0, y: 0)
                //                self.scrollView?.setContentOffset(contentOffset, animated: true )
                tempContentOffset.y = -(loadHeight + originalContentInset.top)
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
            

            UIView.animate(withDuration: 0.25, animations: { 
                
                self.scrollView?.contentInset = inset
                self.scrollView?.contentOffset = tempContentOffset
            }, completion: { (bool ) in
                self.scrollView?.isPagingEnabled = false
                self.performLoad()
                
            })
            
        }
    }
    
    
    
    
    
    
    
    func setrefershStatusEndDrag(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复加载 , 换成loading状态驱动
        if self.loadStatus == GDLoadStatus.nomore {
            return
        }
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y <  -(loadHeight + originalContentInset.top) {//可以加载
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
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //                mylog(newPoint)//下拉变小

        if self.loadStatus != GDLoadStatus.loading {
            self.adjustContentInset(contentOffset: scrollView.contentOffset)
        }
    }
    
    func adjustContentInset(contentOffset:CGPoint)  {//实时更新图片和显示标签
        if self.loadStatus == GDLoadStatus.loading || self.loadStatus == GDLoadStatus.nomore {
            return
        }
//        var inset  = UIEdgeInsets.zero
//        mylog(self.frame)
//        mylog(self.scrollView?.contentOffset)
        switch self.direction {
        case  GDDirection.top:
            var scale : CGFloat   = 0
            
            if contentOffset.y <=  -originalContentInset.top && contentOffset.y >=  -(loadHeight + originalContentInset.top)    {
                
                scale = (-contentOffset.y - originalContentInset.top)  / loadHeight
                mylog(scale)
                
            }
            
            
            if contentOffset.y < -(loadHeight + originalContentInset.top) {//可以加载
//                inset.top = self.loadHeight
                self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
            }else{//下拉以加载
                if contentOffset.y  >= self.priviousContentOffset.y{//backing
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing, scale: scale)
                }else{//pulling
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale: scale)
                }
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -loadHeight {//可以加载
//                inset.left = self.loadHeight
                self.updateTextAndImage(showStatus: GDLoadShowStatus.prepareLoading)
            }else{//右拉以加载
                //  self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                
                
                var scale : CGFloat   = 0
                
                if contentOffset.x <=  0 && contentOffset.x >=  -loadHeight   {
                    
                    scale = -contentOffset.x  / loadHeight
                    mylog(scale)
                    
                }
                

                
                if contentOffset.x  >= self.priviousContentOffset.x{//backing
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale:  scale)
                    //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                    //                        mylog("回去")
                }else{//pulling
                    self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale:  scale)
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
                    
                    var scale : CGFloat   = 0
                    
                    if contentOffset.y >=  0 && contentOffset.y <=  loadHeight   {
                        
                        scale = contentOffset.y  / loadHeight
                        mylog(scale)
                        
                    }
                    
                    
                    
                    if contentOffset.y  <= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
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
                    var scale : CGFloat   = 0
                    
                    if contentOffset.y <=  (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + loadHeight && contentOffset.y >=  (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 )   {
                        
                         scale = (contentOffset.y - ((scrollView?.contentSize.height ?? 0)  - (scrollView?.bounds.size.height ?? 0 ) ) ) / loadHeight
                        mylog(scale)
                        
                    }
                    
                    if contentOffset.y  <= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
//                        mylog("上拉以加载")
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
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
                    
                    var scale : CGFloat   = 0
                    
                    if contentOffset.x >=  0 && contentOffset.x <=  loadHeight   {
                        
                        scale = contentOffset.x  / loadHeight
                        mylog(scale)
                        
                    }
                    
                    
                    
                    if contentOffset.x  <= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
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
                    
                    var scale : CGFloat   = 0
                    
                    if contentOffset.x <=  (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + loadHeight && contentOffset.x >=  (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 )   {
                        
                        scale = (contentOffset.x - ((scrollView?.contentSize.width ?? 0)  - (scrollView?.bounds.size.width ?? 0 ) ) ) / loadHeight
                        mylog(scale)
                        
                    }
                    

                    
                    
                    if contentOffset.x  <= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.backing , scale : scale )
                        //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                        //                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDLoadShowStatus.pulling , actionType:  GDLoadShowStatus.pulling , scale : scale )
                        //                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                    }
                }
            }
            break
        }
        self.priviousContentOffset = contentOffset
    }
    
    
}
*/


public extension UIScrollView{
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

