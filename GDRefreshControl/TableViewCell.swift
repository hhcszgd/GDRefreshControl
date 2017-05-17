//
//  TableViewCell.swift
//  TestGDRefresh
//
//  Created by WY on 13/05/2017.
//  Copyright © 2017 hhcszgd. All rights reserved.
//

import UIKit
import SnapKit
class TableViewCell: UITableViewCell {
    let txtLabel   = UILabel()
    let imgView = UIImageView()
    let subTxtLabel = UILabel()
    var txt  : String = ""{
        didSet{
            self.txtLabel.text = txt
            self.subTxtLabel.text = txt
//            self.imgView.bounds.size = CGSize(width: 55, height: 55 )

            if oldValue.characters.count > 0  {
                    self.reMakeConstraints()
            }else{
                self.makeConstraints()
            }
//            imgView.image = UIImage(named:"imgPicker")

            self.layoutIfNeeded()
        }
    }
    
    
    func makeConstraints()  {
        
         self.subTxtLabel.snp.makeConstraints { (make ) in
         make.top.right.equalTo(self.contentView)
         make.width.equalTo(100)
         }
         
         
         
         self.txtLabel.snp.remakeConstraints({ (make ) in
             make.top.equalTo(self.subTxtLabel)
             make.right.equalTo(self.subTxtLabel.snp.left)
             make.left.equalTo(self.contentView)
         })
         self.imgView.snp.makeConstraints { (make ) in
             make.left.equalTo(self.subTxtLabel)
             make.top.equalTo(self.subTxtLabel.snp.bottom)
            make.width.height.equalTo(55).priority(ConstraintPriority.high)
             make.bottom.equalTo(self.contentView)
         }
    }
    func reMakeConstraints()  {
        self.subTxtLabel.snp.remakeConstraints { (make ) in
            make.top.right.equalTo(self.contentView)
            make.width.equalTo(100)
        }
        
        self.txtLabel.snp.remakeConstraints({ (make ) in
            make.top.equalTo(self.subTxtLabel)
            make.right.equalTo(self.subTxtLabel.snp.left)
            make.left.equalTo(self.contentView)
        })
        self.imgView.snp.remakeConstraints { (make ) in
            make.left.equalTo(self.subTxtLabel)
            make.top.equalTo(self.subTxtLabel.snp.bottom)
            make.width.height.equalTo(55).priority(ConstraintPriority.high)
            make.bottom.equalTo(self.contentView)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(txtLabel)
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(subTxtLabel)
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        txtLabel.numberOfLines = 0
        imgView.backgroundColor = UIColor.blue
        subTxtLabel.numberOfLines = 0
//        self.imgView.translatesAutoresizingMaskIntoConstraints = false
//        self.subTxtLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.txtLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        txtLabel.text = "alskdjf;lkajsd;flkjalkjjjjjjjjjjjjjjaslkdjflkjkljkj😵"
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.txtLabel.snp.remakeConstraints({ (make ) in
//            make.center.equalTo(self.contentView)
//            make.width.height.equalTo(100)
//        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
