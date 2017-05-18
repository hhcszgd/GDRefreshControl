//
//  CollectionViewController.swift
//  GDRefreshControl
//
//  Created by WY on 18/05/2017.
//  Copyright © 2017 hhcszgd. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    var rows  : Int = 1
    
    func dddddd()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            self.collectionView?.gdRefreshControl?.endRefresh(result: GDRefreshResult.failure)
        }
    }
    
    func load(/***/)  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            if self.rows > 13 {
                self.collectionView?.reloadData()
                self.collectionView?.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
            }else{
                self.rows = self.rows + 1
                self.collectionView?.reloadData()
                self.collectionView?.gdLoadControl?.endLoad(result: GDLoadResult.success)
            }
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        
        //            self.tableView.reloadData()
        //            self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
        //        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout  = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        }
        let refresh = GDRefreshControl.init(target: self , selector: #selector(dddddd))
        refresh.direction = GDDirection.right
        self.collectionView?.gdRefreshControl = refresh
        
        
        let load = GDLoadControl.init(target: self , selector: #selector(self.load))
        load.direction = GDDirection.left
        self.collectionView?.gdLoadControl = load
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        cell.backgroundColor = UIColor.red
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
