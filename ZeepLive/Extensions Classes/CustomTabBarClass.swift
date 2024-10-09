//
//  CustomTabBarClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 29/12/23.
//

//import Foundation
//import UIKit
//
//class CustomTabBar: UITabBar {
//    @IBInspectable var height: CGFloat = 0.0
//
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        if height > 0.0 {
//            sizeThatFits.height = height
//        }
//        return sizeThatFits
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if let items = items {
//            for item in items {
//                if let selectedImage = item.selectedImage {
//                    item.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
//                }
//            }
//        }
//    }
//}

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    @IBInspectable var height: CGFloat = 0.0

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let items = items {
            for item in items {
                if let selectedImage = item.selectedImage {
                    item.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
                }

                // Adjust image insets here to modify the image position
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -4, right: 0)
            }
        }
    }
}

