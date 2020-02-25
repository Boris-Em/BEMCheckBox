//
//  BEMAnimationManager.swift
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

import UIKit

public final class BEMAnimationManager: NSObject {
    /** The duration of the animation created by the `BEMAnimationManager` object. */
    @objc public var animationDuration: CFTimeInterval = 0.0
    
    /** Designated initializer.
     * @param animationDuration The duration of the animations created with the `BEMAnimationManager` object.
     * @return Returns the a fully initialized `BEMAnimationManager` object.
     */
    @objc public init(animationDuration: CFTimeInterval) {
        super.init()
        self.animationDuration = animationDuration
    }
    
    /** Returns a `CABasicAnimation` which the stroke.
     * @param reverse The direction of the animation. Set to YES if the animation should go from opacity 0 to 1, or NO for the opposite.
     * @return Returns the `CABasicAnimation` object.
     */
    @objc public func strokeAnimationReverse(_ reverse: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        if reverse {
            animation.fromValue = NSNumber(value: 1.0)
            animation.toValue = NSNumber(value: 0.0)
        } else {
            animation.fromValue = NSNumber(value: 0.0)
            animation.toValue = NSNumber(value: 1.0)
        }
        animation.duration = animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
    
    /** Returns a `CABasicAnimation` which animates the opacity.
     * @param reverse The direction of the animation. Set to YES if the animation should go from opacity 0 to 1, or false for the opposite.
     * @return Returns the `CABasicAnimation` object.
     */
    @objc public func opacityAnimationReverse(_ reverse: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        if reverse {
            animation.fromValue = NSNumber(value: 1.0)
            animation.toValue = NSNumber(value: 0.0)
        } else {
            animation.fromValue = NSNumber(value: 0.0)
            animation.toValue = NSNumber(value: 1.0)
        }
        animation.duration = animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
    
    /** Returns a `CABasicAnimation` which animates between two paths.
     * @param fromPath The path to transform (morph) from.
     * @param toPath The path to transform (morph) to.
     * @return Returns the `CABasicAnimation` object.
     */
    @objc public func morphAnimation(from fromPath: UIBezierPath?, to toPath: UIBezierPath?) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animation.fromValue = fromPath?.cgPath
        animation.toValue = toPath?.cgPath
        
        return animation
    }
    
    /** Animation engine to create a fill animation.
     * @param bounces The number of bounces for the animation.
     * @param amplitude How far does the animation bounce.
     * @param reverse Flag to track if the animation should fill or empty the layer.
     * @return Returns the `CAKeyframeAnimation` object.
     */
    @objc public func fillAnimation(withBounces bounces: Int, amplitude: CGFloat, reverse: Bool) -> CAKeyframeAnimation {
        var values: [AnyHashable] = []
        var keyTimes: [NSNumber] = []
        
        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))
        } else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 0)))
        }
        
        keyTimes.append(0.0)
        
        for i in 1...bounces {
            let scale = (i % 2) != 0 ? (1 + amplitude / CGFloat(i)) : (1 - amplitude / CGFloat(i))
            let time: Double = Double(i) * 1.0 / Double((bounces + 1))
            
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, scale)))
            keyTimes.append(NSNumber(value: time))
        }
        
        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)))
        } else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))
        }
        
        keyTimes.append(NSNumber(value: 1.0))
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = values
        animation.keyTimes = keyTimes
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
}
