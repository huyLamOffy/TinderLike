//
//  UIView+Extensions.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/12/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import UIKit

extension UIView {
    func applyCard(cornerRadius: CGFloat, shadowColor: UIColor, offset: CGSize, shadowOpacity: Float = 0.25, blur: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = blur / 2.0
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = offset
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// Add a rotation CABasicAnimation to current view's layer which is looped forever.
    func addRotation(withDuration duration: TimeInterval = 0.25, isClockWise: Bool = true, forKey key: String? = nil) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.repeatCount = .infinity
        rotation.duration = duration
        rotation.isRemovedOnCompletion = false
        rotation.fromValue = 0
        rotation.toValue = isClockWise ? CGFloat.pi*2 : -CGFloat.pi*2
        self.layer.add(rotation, forKey: key)
    }
}
