//
//  NSDate_extension.swift
//  DYZB
//
//  Created by Ted on 2018/7/1.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

extension NSDate {
    class func getCurrentSystemSeconds() -> String {
        let nowDate = NSDate()
        let currentSystemSeconds = Int(nowDate.timeIntervalSince1970)
        return "\(currentSystemSeconds)"
    }
}
