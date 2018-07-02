//
//  UIBarButton_Extension.swift
//  DYZB
//
//  Created by Ted on 2018/6/28.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    //便利初始化函数，1.加关键字convenience，2.通过self调用一个init构造函数
    convenience init(normalName : String,hightLightName : String?,size:CGSize) {
        let btn = UIButton()
        btn.setImage(UIImage(named: normalName), for: .normal)
        if let okName = hightLightName {
            btn.setImage(UIImage(named: okName), for: .highlighted)
        }

        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        self.init(customView : btn)

    }
}
