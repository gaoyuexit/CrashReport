//
//  LPKitUIApplication.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/8.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit
import CoreTelephony

extension UIApplication: NamespaceWrappable {}

public extension TypeWrapperProtocol where WrappedType == UIApplication {
    /// Check if the device can actually make a phone call
    func canMakePhoneCall() -> Bool {
        guard UIApplication.shared.canOpenURL(URL(string: "tel://")!) else { return false }
        
        let telephonyNetworkInfo = CTTelephonyNetworkInfo()
        
        let carrier = telephonyNetworkInfo.subscriberCellularProvider
        let mobileNetworkCode = carrier?.mobileNetworkCode
        if mobileNetworkCode?.characters.count == 0 || mobileNetworkCode == "65535" {
            return false
        } else {
            return true
        }
    }
}
