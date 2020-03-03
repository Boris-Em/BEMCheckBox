//
//  BEMPathManager.swift
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

import UIKit

final class BEMPathManager: NSObject {
    /** The paths are assumed to be created in squares.
     * This is the size of width, or height, of the paths that will be created.
     */
    var size: CGFloat = 0.0
    
    /** The width of the lines on the created paths. */
    var lineWidth: CGFloat = 0.0
    
    /** The corner radius of the path when the boxType is BEMBoxTypeSquare. */
    var cornerRadius: CGFloat = 0.0
    
    /** The type of box.
     * Depending on the box type, paths may be created differently
     * @see BEMBoxType
     */
    var boxType: BEMCheckBox.BoxType = .circle
    
    /** Returns a UIBezierPath object for the box of the checkbox
     * @returns The path of the box.
     */
    func pathForBox() -> UIBezierPath {
        var path: UIBezierPath
        
        switch boxType {
        case .square:
            let offset = lineWidth / 2.0
            let size = self.size - lineWidth
            
            path = UIBezierPath(
                roundedRect: CGRect(
                    x: 0.0, y: 0.0,
                    width: size, height: size),
                cornerRadius: cornerRadius)
            path.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi * 2.5))
            path.apply(CGAffineTransform(translationX: size + offset, y: offset))
            
        default:
            let radius: CGFloat = (size - lineWidth) / 2
            
            path = UIBezierPath(
                arcCenter: CGPoint(x: size / 2, y: size / 2),
                radius: radius,
                startAngle: -.pi / 4,
                endAngle: 2 * .pi - .pi / 4,
                clockwise: true)
        }
        
        return path
    }
    
    /** Returns a UIBezierPath object for the checkmark of the checkbox
     * @returns The path of the checkmark.
     */
    func pathForCheckMark() -> UIBezierPath {
        let checkMarkPath = UIBezierPath()
        
        checkMarkPath.move(to: CGPoint(x: size / 3.1578, y: size / 2))
        checkMarkPath.addLine(to: CGPoint(x: size / 2.0618, y: size / 1.57894))
        checkMarkPath.addLine(to: CGPoint(x: size / 1.3953, y: size / 2.7272))
        
        if boxType == .square {
            // If we use a square box, the check mark should be a little bit bigger
            checkMarkPath.apply(CGAffineTransform(scaleX: 1.5, y: 1.5))
            checkMarkPath.apply(CGAffineTransform(translationX: -size / 4, y: -size / 4))
        }
        
        return checkMarkPath
    }
    
    /** Returns a UIBezierPath object for an extra long checkmark which is in contact with the box.
     * @returns The path of the checkmark.
     */
    func pathForLongCheckMark() -> UIBezierPath {
        let checkMarkPath = UIBezierPath()
        
        checkMarkPath.move(to: CGPoint(x: size / 3.1578, y: size / 2))
        checkMarkPath.addLine(to: CGPoint(x: size / 2.0618, y: size / 1.57894))
        
        if boxType == .square {
            // If we use a square box, the check mark should be a little bit bigger
            checkMarkPath.addLine(to: CGPoint(x: size / 1.2053, y: size / 4.5272))
            checkMarkPath.apply(CGAffineTransform(scaleX: 1.5, y: 1.5))
            checkMarkPath.apply(CGAffineTransform(translationX: -size / 4, y: -size / 4))
        } else {
            checkMarkPath.addLine(to: CGPoint(x: size / 1.1553, y: size / 5.9272))
        }
        
        return checkMarkPath
    }
    
    /** Returns a UIBezierPath object for the flat checkmark of the checkbox
     * @see BEMAnimationTypeFlat
     * @returns The path of the flat checkmark.
     */
    func pathForFlatCheckMark() -> UIBezierPath {
        let flatCheckMarkPath = UIBezierPath()
        flatCheckMarkPath.move(to: CGPoint(x: size / 4, y: size / 2))
        flatCheckMarkPath.addLine(to: CGPoint(x: size / 2, y: size / 2))
        flatCheckMarkPath.addLine(to: CGPoint(x: size / 1.2, y: size / 2))
        
        return flatCheckMarkPath
    }
}
