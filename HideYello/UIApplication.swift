//
//  UIApplication.swift
//  OtoLink
//
//  Created by Maulik Pandya on 20/05/20.
//  Copyright © 2020 Rajan Shah. All rights reserved.
//

import AVKit
import Foundation

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 2_147_483_646
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            return value(forKey: "statusBar") as? UIView
        }
    }

    public class func topViewControllr(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewControllr(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewControllr(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewControllr(presented)
        }
        return base
    }
}
extension NSNotification.Name {
    public static let UIHomeScreenDidUpdate = Notification.Name("iXoppUpdateHomeScreenUI")
    public static let UIActivityUpdate = Notification.Name("iXoppAnimatingActivity")
    public static let InternetIsAvailableNow = Notification.Name("iXoppInternetIsAvailableNow")
    public static let RateIsPossibleNow = Notification.Name("iXoppRateIsPossibleNow")
}
