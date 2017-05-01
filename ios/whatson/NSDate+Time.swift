//
//  NSDate+Time.swift
//  whatson
//
//  Created by Alex on 27/02/2016.
//  Copyright © 2016 Alex Curran. All rights reserved.
//

import UIKit

extension Date {

    init(from time: SCTimestamp) {
        self.init(timeIntervalSince1970: TimeInterval(time.getMillis() / 1000))
    }

    @available(*, deprecated, renamed: "init(from:)")
    static func dateFromTime(_ time: SCTimestamp) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(time.getMillis() / 1000))
    }

}
