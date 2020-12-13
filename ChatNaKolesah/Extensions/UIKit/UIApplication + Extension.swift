//
//  UIApplication + Extension.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 13.12.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func getTopViewContoller(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewContoller(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewContoller(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewContoller(base: presented)
        }
        return base
    }
}
