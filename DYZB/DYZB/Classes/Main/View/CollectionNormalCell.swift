//
//  CollectionNormalCell.swift
//  DYZB
//
//  Created by Ted on 2018/6/30.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionNormalCell: CollectionBaseCell {


    @IBOutlet weak var roomLabel: UILabel!
    override var anchor : AnchorModel? {
        didSet {
            //将属性传递给父类
            super.anchor = anchor
            //设置在线人数
            //guard let anchor = anchor else {return}

            
            //设置房间名
            roomLabel.text = anchor?.room_name
        }
    }

}
