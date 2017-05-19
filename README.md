# GDRefreshControl
## Description
这是一个拖动刷新控件 ,通常是下拉刷新和上拉加载 , 也就是此框架默认的方式 , 但也有比较奇葩的产品让实现左拉刷新\右拉加载 ,为响应奇葩产品的需求 , 此框架就诞生了, 它可以指定方向实现下拉刷新\左拉刷新\上拉刷新\右拉刷新 , 下拉加载\左拉加载\上拉加载\右拉加载 , 如果你有需求 , 来这就对了

## Getting Started
推荐使用cocoapods
pod 'GDRefreshControl', '~> 0.0.87'

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
