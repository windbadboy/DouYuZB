//
//  CycleModel.swift
//  DYZB
//
//  Created by Ted on 2018/7/3.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit
//MARK: - 轮播数据模型
class CycleModel: NSObject {
    //房间标题
    @objc var title : String = ""
    //展示图片
    @objc var pic_url : String = ""
    //房间信息
    @objc var room : [String : NSObject]? {
        didSet {
            guard let room = room else {return}
            anchor = AnchorModel(dict: room)
        }
    }
    @objc var anchor : AnchorModel?
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
