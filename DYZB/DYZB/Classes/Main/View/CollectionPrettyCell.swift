//
//  CollectionPrettyCell.swift
//  DYZB
//
//  Created by Ted on 2018/7/1.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit
import Kingfisher


class CollectionPrettyCell: CollectionBaseCell {

    @IBOutlet weak var locationButton: UIButton!

    override var anchor : AnchorModel? {
        didSet {
            super.anchor = anchor
            //guard let anchor = anchor else {return}
            //设置位置
            locationButton.setTitle(anchor?.anchor_city, for: .normal)
        }
    }

}
