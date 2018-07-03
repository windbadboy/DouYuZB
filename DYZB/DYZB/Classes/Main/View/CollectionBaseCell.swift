//
//  CollectionBaseCell.swift
//  DYZB
//
//  Created by Ted on 2018/7/3.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionBaseCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var anchor : AnchorModel? {
        didSet {
            //设置在线人数
            guard let anchor = anchor else {return}
            var onlineStr : String = ""
            if anchor.online > 10000 {
                onlineStr = "\(Int(anchor.online/10000))万人"
            } else {
                onlineStr = "\(anchor.online)人"
            }
            onlineButton.setTitle(onlineStr, for: .normal)
            
            //设置昵称
            nicknameLabel.text = anchor.nickname
            
            
            
            //设置图片
            guard let iconURL = NSURL(string: anchor.vertical_src) else {return}
            let resource = ImageResource(downloadURL: iconURL as URL)
            iconImageView.kf.setImage(with: resource)
        }
    }
}
