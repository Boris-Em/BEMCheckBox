//
//  BEMPathManager.m
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "BEMPathManager.h"

@implementation BEMPathManager

#pragma mark Paths

- (UIBezierPath *)pathForBox {
    UIBezierPath* path;
    switch (self.boxType) {
        case BEMBoxTypeSquare:
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.lineWidth / (CGFloat)2.0f, self.lineWidth / (CGFloat)2.0f, self.size - self.lineWidth, self.size - self.lineWidth) cornerRadius:self.cornerRadius];
            [path applyTransform:CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat)(M_PI * 2.5))];
            [path applyTransform:CGAffineTransformMakeTranslation(self.size, 0)];
            break;
            
        default: {
            CGFloat radius = (self.size / (CGFloat)2.0f) - (self.lineWidth / (CGFloat)2.0f);
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.size / 2, self.size / 2)
                                                  radius: radius
                                              startAngle: - (CGFloat)(M_PI / 4.0)
                                                endAngle: (CGFloat)(2.0 * M_PI - M_PI / 4.0)
                                               clockwise:YES];
        }
            break;
    }
    return path;
}

- (UIBezierPath *)pathForCheckMark {
    UIBezierPath* checkMarkPath = [UIBezierPath bezierPath];
    
    [checkMarkPath moveToPoint: CGPointMake(self.size/(CGFloat)3.1578f, self.size/(CGFloat)2.0f)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size/(CGFloat)2.0618f, self.size/(CGFloat)1.57894f)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size/(CGFloat)1.3953f, self.size/(CGFloat)2.7272f)];
    
    if (self.boxType == BEMBoxTypeSquare) {
        // If we use a square box, the check mark should be a little bit bigger
        [checkMarkPath applyTransform:CGAffineTransformMakeScale(1.5, 1.5)];
        [checkMarkPath applyTransform:CGAffineTransformMakeTranslation(-self.size/4, -self.size/4)];
    }
    
    return checkMarkPath;
}

- (UIBezierPath *)pathForLongCheckMark {
    UIBezierPath* checkMarkPath = [UIBezierPath bezierPath];
    
    [checkMarkPath moveToPoint: CGPointMake(self.size/(CGFloat)3.1578f, self.size/(CGFloat)2.0f)];
    [checkMarkPath addLineToPoint: CGPointMake(self.size/(CGFloat)2.0618f, self.size/(CGFloat)1.57894f)];
    
    if (self.boxType == BEMBoxTypeSquare) {
        // If we use a square box, the check mark should be a little bit bigger
        [checkMarkPath addLineToPoint: CGPointMake(self.size/(CGFloat)1.2053f, self.size/(CGFloat)4.5272f)];
        [checkMarkPath applyTransform:CGAffineTransformMakeScale(1.5, 1.5)];
        [checkMarkPath applyTransform:CGAffineTransformMakeTranslation(-self.size/4, -self.size/4)];
    } else {
        [checkMarkPath addLineToPoint: CGPointMake(self.size/(CGFloat)1.1553f, self.size/(CGFloat)5.9272f)];
    }
    
    return checkMarkPath;
}

- (UIBezierPath *)pathForFlatCheckMark {
    UIBezierPath* flatCheckMarkPath = [UIBezierPath bezierPath];
    [flatCheckMarkPath moveToPoint: CGPointMake(self.size/4, self.size/2)];
    [flatCheckMarkPath addLineToPoint: CGPointMake(self.size/(CGFloat)2.0f, self.size/(CGFloat)2.0f)];
    [flatCheckMarkPath addLineToPoint: CGPointMake(self.size/(CGFloat)1.2f, self.size/(CGFloat)2.0f)];
    
    return flatCheckMarkPath;
}

@end
