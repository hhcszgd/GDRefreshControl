   //
//  GDRefreshControl.swift
//  zjlao
//
//  Created by WY on 28/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

// MARK: 注释 : 加载结果
public enum GDRefreshResult {
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
public enum GDRefreshStatus {
    case idle
    case pulling
    case refreshing
    case backing
}
// MARK: 注释 : 刷新控件的方向
public enum GDDirection {
    case top
    case left
    case bottom
    case right
}
public class GDRefreshControl: GDBaseControl {
    public var refreshHeight : CGFloat = 88
    
    public var pullingImages : [UIImage] = pullingImagesForRefresh(){
        didSet{
        }
    }
    public var refreshingImages : [UIImage] = refreshingImgs(){
        didSet{
            
        }
    }
    
    public var networkErrorImage : UIImage = networkErrorImageForRefresh(){
        didSet{
            
        }
    }
    
    public var successImage : UIImage = successImagesForRefresh(){
        didSet{
            
        }
    }
    
    public var failureImage : UIImage = failureImagesForRefresh(){
        didSet{
            
        }
    }

    public var pullingStr = "拖动以刷新"
    public var loosenStr = "松开刷新"
    public var refreshingStr = "刷新中"
    public var successStr = "加载成功"
    public var failureStr = "加载失败"
    public var networkErrorStr = "网络错误"
    
    var showStatus = GDShowStatus.idle
    
    
    fileprivate weak var refreshTarget : AnyObject?
    fileprivate var refreshAction : Selector?
    
    public var refreshStatus = GDRefreshStatus.idle{
        
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
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.numberOfLines = 0
        self.direction = GDDirection.top
    }
    
    public convenience  init(target: AnyObject? , selector : Selector?) {
        self.init(frame: CGRect.zero)
        self.refreshTarget = target
        self.refreshAction = selector
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        if let load  = self.scrollView?.gdLoadControl  {
            load.loadStatus = GDLoadStatus.idle
        }
        self.updateTextAndImage(showStatus: GDShowStatus.refreshing , actionType: GDShowStatus.refreshing)
        mylog(scrollView?.contentInset)
        if self.refreshAction != nil && self.refreshTarget != nil {
            _  = self.refreshTarget!.perform(self.refreshAction!)
        }
    }
    
    /// call after reloadData(tableView)
    ///
    /// - Parameter result:  forExample : success , networkError or failure
    public func endRefresh(result : GDRefreshResult = GDRefreshResult.success)  {

        if  self.refreshStatus == GDRefreshStatus.refreshing {
            mylog("结束刷新 偏移量\(String(describing: self.scrollView?.contentOffset))")
            if result == GDRefreshResult.success {
                self.updateTextAndImage(showStatus: GDShowStatus.refreshSuccess , actionType:  GDShowStatus.refreshed)
            }else if result == GDRefreshResult.failure{
                self.updateTextAndImage(showStatus: GDShowStatus.refreshFailure , actionType:  GDShowStatus.refreshed)
            }else if result == GDRefreshResult.networkError{
                self.updateTextAndImage(showStatus: GDShowStatus.netWorkError , actionType:  GDShowStatus.refreshed)
            }

            if result == GDRefreshResult.success {
                self.scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                self.refreshStatus = GDRefreshStatus.idle
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

                }) { (bool) in
                    self.refreshStatus = GDRefreshStatus.idle
                }
                
            }
        }
    }
}




// MARK: 注释 : updateUI
extension GDRefreshControl {
    
    
    
    func updateTextAndImage(showStatus : GDShowStatus , actionType : GDShowStatus = GDShowStatus.pulling/*拖动中还是弹回中*/,scale : CGFloat = 0)  {
        var title  = ""
        if self.imageView.isAnimating {
            self.imageView.stopAnimating()
        }
        if showStatus == GDShowStatus.pulling && actionType == GDShowStatus.pulling {
            //下拉以加载
            title = pullingStr
            let a : Int =  Int(( CGFloat( self.pullingImages.count) * scale))
            if a > 0 && a < self.pullingImages.count {
                self.imageView.image = self.pullingImages[a]
                
            }
        }else if showStatus == GDShowStatus.pulling && actionType == GDShowStatus.backing && self.refreshStatus != GDRefreshStatus.refreshing{
            //下拉以加载
            title = pullingStr
            let a : Int =  Int(( CGFloat( self.pullingImages.count) * scale))
            if a > 0 && a < self.pullingImages.count {
                self.imageView.image = self.pullingImages[a]
                
            }
        }else if showStatus == GDShowStatus.prepareRefreshing  {
            title = loosenStr
            //松手以刷新
        }else if showStatus == GDShowStatus.refreshing && actionType == GDShowStatus.refreshing{
            title = refreshingStr
            self.imageView.animationImages = self.refreshingImages
            self.imageView.animationDuration = 0.5
            self.imageView.animationRepeatCount = 19
            self.imageView.startAnimating()
            //刷新中
        }else if showStatus ==  GDShowStatus.refreshSuccess && actionType == GDShowStatus.refreshed{
            title = successStr
            self.imageView.image = self.successImage
            //刷新成功
        }else if showStatus ==  GDShowStatus.refreshFailure && actionType == GDShowStatus.refreshed{
            title = failureStr
            self.imageView.image = self.failureImage
            //刷新失败
        }else if showStatus ==  GDShowStatus.netWorkError && actionType == GDShowStatus.refreshed{
            title = networkErrorStr
            self.imageView.image = self.networkErrorImage
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
            if self.labelFrame == CGRect.zero {
                self.titleLabel.frame = CGRect(x: 0, y: self.bounds.size.height * 0.5, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
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
            self.frame = CGRect(x: -refreshHeight, y: 0, width: refreshHeight, height: scrollView.bounds.size.height)
            if self.labelFrame == CGRect.zero {
                
                self.titleLabel.frame = CGRect(x: self.bounds.size.width  * 0.5, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
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
                self.frame = CGRect(x: 0, y: scrollView.bounds.size.height, width:scrollView.bounds.size.width  ,  height: refreshHeight)
            }else{
                self.frame = CGRect(x: 0, y: scrollView.contentSize.height , width:scrollView.bounds.size.width  ,  height: refreshHeight)
            }
            if self.labelFrame == CGRect.zero {
                self.titleLabel.frame = CGRect(x: 0, y:  self.bounds.size.height * 0.4, width: self.bounds.size.width, height: self.titleLabel.font.lineHeight)
            }else{
                self.titleLabel.frame  = self.labelFrame
            }
            if self.imageViewFrame == CGRect.zero {
                self.imageView.frame = CGRect(x: 10, y: self.bounds.size.height * 0.1, width: self.bounds.size.height * 0.8, height: self.bounds.size.height * 0.8)
            }else{
                self.imageView.frame = self.imageViewFrame
            }

            break
        case  GDDirection.right:
            
            if scrollView.contentSize.width < scrollView.bounds.size.width{
                self.frame = CGRect(x: scrollView.bounds.size.width, y: 0, width: refreshHeight  ,  height: scrollView.bounds.size.height )
            }else{
                self.frame = CGRect(x: scrollView.contentSize.width, y: 0, width: refreshHeight, height: scrollView.bounds.size.height)
            }
            if self.labelFrame == CGRect.zero {
                
                self.titleLabel.frame = CGRect(x: self.bounds.size.width * 0.4, y: 0, width: self.titleLabel.font.lineHeight, height: self.bounds.size.height)
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
    }
    

    
}



// MARK: 注释 : KVO
extension GDRefreshControl{
    

    public override func scrollViewContentSizeChanged(){
        
        if let scroll = self.scrollView {
            mylog("监听contentSize : \(String(describing: scroll.contentSize))")
            self.fixFrame(scrollView: scroll)//自动布局是 , scrollView的contentSize是动态变化的, 所以要实时调整加载控件的frame
        }
    }
    
    
    
    public override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        // MARK: 注释 a: 当用户拖动时 , 还原滚动控件的isPagingEnable
        if scrollView.isPagingEnabled != self.originalIspagingEnable {
            self.scrollView?.isPagingEnabled = self.originalIspagingEnable
        }
        
    }
    
    
    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView){
        mylog("松手了  ,当前偏移量是\(scrollView.contentOffset)")

        if self.refreshStatus != GDRefreshStatus.refreshing {
            self.setrefershStatusEndDrag(contentOffset: scrollView.contentOffset)
            
        }
        
    }
    
    
    
    
    
    func performRefreshAfterSetRefreshingStatus(contentOffset: CGPoint )  {//原计划松手驱动 , for避免重复刷新 , 换成refreshing状态驱动
        var inset  = UIEdgeInsets.zero
        var isNeedRefresh = false
        
        
        
        var tempContentOffset  = CGPoint.zero
        
        switch self.direction {
        case  GDDirection.top:
            if contentOffset.y < -refreshHeight {//可以刷新
                inset.top = self.refreshHeight
                isNeedRefresh = true
                tempContentOffset.y = -refreshHeight
            }
            
            break
        case  GDDirection.left:
            if contentOffset.x < -refreshHeight {//可以刷新
                inset.left = self.refreshHeight
                isNeedRefresh = true
                tempContentOffset.x = -refreshHeight
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

            UIView.animate(withDuration: 0.25, animations: { 
                self.scrollView?.contentInset = inset
                self.scrollView?.contentOffset = tempContentOffset
                
            }, completion: { (bool ) in
                
                self.scrollView?.isPagingEnabled = false
                self.performRefresh()
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
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //                mylog(newPoint)//下拉变小
//        if let refresh  = self.whetherCallRefreshDelegate(scrollView) {
//            refresh.scrollViewDidScroll(scrollView)
//        }
        if self.refreshStatus != GDRefreshStatus.refreshing {
            self.adjustContentInset(contentOffset: scrollView.contentOffset)
        }
    }
    
    func adjustContentInset(contentOffset:CGPoint)  {//实时更新图片和显示标签
        if self.refreshStatus == GDRefreshStatus.refreshing {
            return
        }
//        mylog(self.frame)
//        mylog(self.scrollView?.contentOffset)
        var inset  = UIEdgeInsets.zero
//        var isNeedRefresh = false
        switch self.direction {
            case  GDDirection.top:
                
                var scale : CGFloat   = 0
                
                if contentOffset.y <=  0 && contentOffset.y >=  -refreshHeight   {
                    
                    scale = -contentOffset.y  / refreshHeight
                    mylog(scale)
                    
                }
                
                
                if contentOffset.y < -refreshHeight {//可以刷新
                    inset.top = self.refreshHeight
//                    isNeedRefresh = true
                    self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                }else{//下拉以刷新
                    if contentOffset.y  >= self.priviousContentOffset.y{//backing
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing , scale:  scale)
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling , scale:  scale)
                    }
                }
                
                break
            case  GDDirection.left:
                if contentOffset.x < -refreshHeight {//可以刷新
                    inset.left = self.refreshHeight
//                    isNeedRefresh = true
                    self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                }else{//右拉以刷新
                    
                    
                    var scale : CGFloat   = 0
                    
                    if contentOffset.x <=  0 && contentOffset.x >=  -refreshHeight   {
                        
                        scale = -contentOffset.x  / refreshHeight
                        mylog(scale)
                        
                    }
                    
//                    self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                    if contentOffset.x  >= self.priviousContentOffset.x{//backing
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing , scale:  scale)
//                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
//                        mylog("回去")
                    }else{//pulling
                        self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling , scale:  scale)
                    }
                }
                break
            case  GDDirection.bottom:
                
                if (scrollView?.contentSize.height ?? 0) < (scrollView?.bounds.size.height ?? 0){
                    if contentOffset.y >  refreshHeight { //可以刷新
                        self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                        mylog("松手可刷新")
                        inset.bottom = self.refreshHeight + ((scrollView?.bounds.size.height ?? 0) - (scrollView?.contentSize.height ?? 0))
//                        isNeedRefresh = true
                    }else{//上拉以刷新
                        var scale : CGFloat   = 0
                        
                        if contentOffset.y >=  0 && contentOffset.y <=  refreshHeight   {
                            
                            scale = contentOffset.y  / refreshHeight
                            mylog(scale)
                            
                        }
                        
                        
                        
                        if contentOffset.y  <= self.priviousContentOffset.y{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing , scale: scale)
                           
                            
                        }else{//pulling
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling, scale: scale)

                            mylog("上拉以刷新")
                        }
                    }
                }else{

                    if contentOffset.y > (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight {//可以刷新
                        self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                        mylog("松手可刷新")
                        inset.bottom = self.refreshHeight
//                        isNeedRefresh = true
                    }else{//上拉以刷新
                        var scale : CGFloat   = 0
                        
                        if contentOffset.y <=  (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 ) + refreshHeight && contentOffset.y >=  (scrollView?.contentSize.height ?? 0) - (scrollView?.bounds.size.height ?? 0 )   {
                            
                            scale = (contentOffset.y - ((scrollView?.contentSize.height ?? 0)  - (scrollView?.bounds.size.height ?? 0 ) ) ) / refreshHeight
                            mylog(scale)
                            
                        }

                        if contentOffset.y  <= self.priviousContentOffset.y{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing, scale: scale)
                            //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                            //                        mylog("回去")
                        }else{//pulling
                            mylog("上拉以刷新")
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling, scale: scale)
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
//                        isNeedRefresh = true
                    }else{//左拉以刷新
                        mylog("左拉以刷新")
                        
                        var scale : CGFloat   = 0
                        
                        if contentOffset.x >=  0 && contentOffset.x <=  refreshHeight   {
                            
                            scale = contentOffset.x  / refreshHeight
                            mylog(scale)
                            
                        }
                        
                        
                        
                        
                        if contentOffset.x  <= self.priviousContentOffset.x{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing , scale : scale )
                            //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                            //                        mylog("回去")
                        }else{//pulling
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling , scale : scale )
//                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                        }
                    }
                }else{

                    
                    if contentOffset.x > (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight {//可以刷新
                        self.updateTextAndImage(showStatus: GDShowStatus.prepareRefreshing)
                        mylog("松手可刷新")
                        inset.right = self.refreshHeight
//                        isNeedRefresh = true
                    }else{//左拉以刷新
                        mylog("左拉以刷新")
                        
                        
                        
                        
                        var scale : CGFloat   = 0
                        
                        if contentOffset.x <=  (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 ) + refreshHeight && contentOffset.x >=  (scrollView?.contentSize.width ?? 0) - (scrollView?.bounds.size.width ?? 0 )   {
                            
                            scale = (contentOffset.x - ((scrollView?.contentSize.width ?? 0)  - (scrollView?.bounds.size.width ?? 0 ) ) ) / refreshHeight
                            mylog(scale)
                            
                        }

                        
                        if contentOffset.x  <= self.priviousContentOffset.x{//backing
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.backing , scale : scale )
                            //                        self.updateTextAndImage(showStatus: GDShowStatus.backing)
                            //                        mylog("回去")
                        }else{//pulling
                            self.updateTextAndImage(showStatus: GDShowStatus.pulling , actionType:  GDShowStatus.pulling , scale : scale )
//                            self.updateTextAndImage(showStatus: GDShowStatus.pulling)
                        }
                    }
                }
                break
        }
        self.priviousContentOffset = contentOffset
    }
}



public extension UIScrollView{
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

