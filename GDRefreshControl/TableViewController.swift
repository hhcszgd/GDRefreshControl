//
//  TableViewController.swift
//  TestGDRefresh
//
//  Created by WY on 12/05/2017.
//  Copyright © 2017 hhcszgd. All rights reserved.
//

import UIKit
class TableViewController: UITableViewController {
    
    var rows  : Int = 3
    
    func refresh()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            self.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.failure)
        }
    }
    
    func load(/***/)  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
 
            if self.rows > 13 {
                self.tableView.reloadData()
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
            }else{
                self.rows = self.rows + 1
                self.tableView.reloadData()
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
            }
        }
    
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        
//            self.tableView.reloadData()
//            self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
//        }
    }
    func testProperty() {
        var count: UInt32 = 3
        let objc_property_tS = class_copyPropertyList(UIScrollView.self  , &count)
        for i in 0 ..< count {
            let objc_property_tO = objc_property_tS![Int(i)]
            let name = property_getName(objc_property_tO)
            mylog(String(cString: name!))
        }
        free(objc_property_tS)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIDevice.current.systemVersion)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.contentInset = UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0    )
//        self.tableView.rowHeight = 99
        let refresh = GDRefreshControl.init(target: self , selector: #selector(self.refresh))
        refresh.direction = GDDirection.bottom
//        refresh.pullingStr  = "阿利亚多"
        self.tableView.gdRefreshControl = refresh
        
        
        let load = GDLoadControl.init(target: self , selector: #selector(self.load))
        load.direction = GDDirection.top
//        load.pullingStr = "thank you "
        self.tableView.gdLoadControl = load
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell = tableView.dequeueReusableCell(withIdentifier: "ididid")
        if cell == nil  {
            cell = TableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ididid")
            
        }
        if let realCell = cell as? TableViewCell {
            realCell.txt = "那年萨拉斯柯达;阿里斯顿解放路控件来拉看似简单;浪费空间;李克军ki0opuwe9ur 拉斯克奖分类阿拉山口记得发\(indexPath.row)"
        }else{
            cell?.textLabel?.text = "哈哦啊热油爱上了历史地看解放军爱丽丝打开房间啊; 卢卡斯柯耳机哦哦啊哦念书氨基酸空荡荡的拉拉队龙卷风\(indexPath.row)"
        }
        // Configure the cell...
        //        cell?.textLabel?.text = indexPath.row.description
        return cell!
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
