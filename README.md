# GDRefreshControl
## Description
这是一个拖动刷新控件 ,通常是下拉刷新和上拉加载 , 也就是此框架默认的方式 , 但也有比较奇葩的产品让实现左拉刷新\右拉加载 ,为响应奇葩产品的需求 , 此框架就诞生了, 它可以指定方向实现下拉刷新\左拉刷新\上拉刷新\右拉刷新 , 下拉加载\左拉加载\上拉加载\右拉加载 , 如果你有需求 , 来这就对了

## Getting Started
推荐使用cocoapods
pod 'GDRefreshControl', '~> 0.1.8'
0.1.8 对应swift4.0

## Usage
let refresh = GDRefreshControl.init(target: self , selector: #selector(refreshFunction))
self.collectionView?.gdRefreshControl = refresh

你也可是设置相关参数实现想要的布局 和 图片及文字的显示
refresh.refreshHeight //刷新控件高度
refresh.direction //刷新控件所在的位置 , (top ,left ,bottom , right)
refresh.networkErrorImage //网络错误时展示的图片
refresh.pullingImages //拖拽时的图片集合
refresh.refreshingImages //刷新时的图片集合
refresh.pullingStr  // 文字显示


```override func viewDidLoad() {
super.viewDidLoad()
collectionView?.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(performRefresh))
collectionView?.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
}
@objc func loadMore()  {
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
self.collectionView?.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
}
}
@objc func performRefresh() {
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
self.collectionView?.gdRefreshControl?.endRefresh(result: GDRefreshResult.networkError)
}
}
```
## note
图片取自美团 , 商用请换成自己的图片
![image](http://ozstzd6mp.bkt.gdipper.com/right.gif)

