//
//  AnchorModel.swift
//  DYZB
//
//  Created by Ted on 2018/7/1.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {
    //房间id
    @objc var room_id : Int = 0
    //房间截图
    @objc var vertical_src : String = ""
    //手机还是电脑直播，0:电脑，1:手机
    @objc var isVertical : Int = 0
    //房间名称
    @objc var room_name : String = ""
    //主播昵称
    @objc var nickname : String = ""
    //观看人数
    @objc var online : Int = 0
    //所在城市
    @objc var anchor_city : String = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    

    
}
