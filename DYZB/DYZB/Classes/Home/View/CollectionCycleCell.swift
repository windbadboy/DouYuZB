//
//  CollectionCycleCell.swift
//  DYZB
//
//  Created by Ted on 2018/7/3.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionCycleCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    var cycleModel : CycleModel? {
        didSet {
            titleLabel.text = cycleModel?.title
            guard let iconURL = NSURL(string: cycleModel?.pic_url ?? "") else {return}
            let resource = ImageResource(downloadURL: iconURL as URL)
            iconImageView.kf.setImage(with: resource)
            
        }
    }
}
