//
//  UIColor_Extension.swift
//  DYZB
//
//  Created by Ted on 2018/6/28.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(R : CGFloat,G : CGFloat,B : CGFloat) {
        
        self.init(red : R / 255.0,green : G / 255.0,blue : B / 255.0,alpha : 1.0)
    }
}
