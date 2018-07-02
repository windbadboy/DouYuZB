//
//  AnchorGroup.swift
//  DYZB
//
//  Created by Ted on 2018/7/1.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    //房间列表，是一个数组 room list an Array
    @objc var room_list : [[String : NSObject]]? {
        didSet {
            guard let rooms = room_list else {return}
            for dict in rooms {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    //频道名 channel name
    @objc var tag_name : String = ""
    //频道图标 channel icon name
    @objc var icon_name : String = "home_header_normal"
    
    @objc lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    override init() {

    }
    
    init(dict : [String : NSObject]) {
        super.init()
        //can corretly output to command line.
        //print(dict["tag_name"]!)
        //not work,when I reference a instance in somewhere,it get nothing.
        setValuesForKeys(dict)

        
        
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //print("key is \(key) and value is \(value)")
    }
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "room_list" {
//            guard let rooms = value as? [[String : NSObject]] else {return}
//            for room in rooms {
//                anchors.append(AnchorModel(dict : room))
//            }
//        }
//    }
}
