//
//  RecommendViewModel.swift
//  DYZB
//
//  Created by Ted on 2018/7/1.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

class RecommendViewModel {
    //显示热门数据
    private lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    //显示颜值数据
    private lazy var prettyGroup : AnchorGroup = AnchorGroup()
    //显示轮播数据
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    
    //MARK: - 创建存放数据的模型数组，显示2-12组数据
     lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    

}

//MARK: - 网络请求


extension RecommendViewModel {


    
//请求房间数据
    func requestData(finishedCallback : @escaping () -> ()) {
        //定义参数
        let parameters = ["limit" : "4","offset":"0","time" : NSDate.getCurrentSystemSeconds() as NSString]
        //创建dispatchGroup
        let dGroup = DispatchGroup()
        dGroup.enter()
        //请求第一部分数据
         NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : NSDate.getCurrentSystemSeconds() as NSString], finishedCallback: {(result) in
            guard let resultDict = result as? [String : NSObject] else{return}
            //获取data下标数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            //遍历数据转成字典模型Anchor
            //分组（秀场、热门...）
//            let group = AnchorGroup()
            
            //设置组属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            for dict in dataArray {
                
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            dGroup.leave()
         })
        
        dGroup.enter()
        //请求第二部分数据(颜值）
        //http://capi.douyucdn.cn/api/v1/getVerticalRoom"
        //https://apiv2.douyucdn.cn/mgapi/livenc/home/getRecList1?token=&offset=0&limit=10&channel=31&client_sys=android
        //let parametersHttps = ["limit" : "4","offset":"0","channel" : "31","token" : "","client_sys" : "apple"]
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters, finishedCallback: {(result) in
            //将result转换成字典类型
            //print()
            guard let resultDict = result as? [String : NSObject] else{return}
            //获取data下标数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            //遍历数据转成字典模型Anchor
            //分组（秀场、热门...）
            //设置组属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
                //print(dict)
            }
            
            dGroup.leave()
           
        })
        //请求后面部分游戏数据
        //http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1530437435
        dGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters, finishedCallback: {(result) in

            //将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else {return}

            
            //获取下标为data的数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            
            for dict in dataArray {
                //let test : [String : NSObject] = ["tag_name" : "mytest" as NSString]
                let group = AnchorGroup(dict: dict)
                
                //print(dict)
                self.anchorGroups.append(group)
                
            }
            dGroup.leave()
            
            
        })
        dGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            finishedCallback()
            
        }
    }

//请求轮播图片数据
    func requestCycleData(finishedCallback : @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: "http://www.douyu.com/api/v1/slide/6", parameters: ["version" : "2.300"] ,finishedCallback: {
            (result) in
            //将result转换成[String : NSObject]字典形式数据
            guard let resultDict = result as? [String : NSObject] else {return}
            //将resultDict的data转换成[[String : NSObject]]形式
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            for dict in dataArray {
               self.cycleModels.append(CycleModel(dict: dict))
                //print()
            }
            
            finishedCallback()
        })
    }
}



