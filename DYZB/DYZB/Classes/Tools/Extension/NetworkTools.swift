//
//  NetworkTools.swift
//  DYZB
//
//  Created by Ted on 2018/7/1.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType {
    case GET,POST
}
class NetworkTools {
    class func requestData(type : MethodType,URLString : String,parameters : [String : NSString]? = nil,finishedCallback : @escaping (_ result : Any) -> () ) {
        //获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { response in
            guard let result = response.result.value else
            {
                print("Result:\(String(describing: response.result.error))")
                return
                
            }
                        finishedCallback(result)
        }
    }
}
