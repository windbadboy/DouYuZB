//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by Ted on 2018/6/30.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var rIconImageView: UIImageView!
    @IBOutlet weak var rTitleLabel: UILabel!
    var group : AnchorGroup? {
        didSet {
            rTitleLabel.text = group?.tag_name
            rIconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
    
}
