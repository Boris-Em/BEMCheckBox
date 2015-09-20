//
//  BEMAnimationManager.m
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "BEMAnimationManager.h"

@implementation BEMAnimationManager

- (CABasicAnimation *)strokeAnimationReverse:(BOOL)reverse {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (reverse) {
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:0.0];
    } else {
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
    }
    animation.duration = self.animationDuration;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

- (CABasicAnimation *)opacityAnimationReverse:(BOOL)reverse {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    if (reverse) {
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:0.0];
    } else {
        animation.fromValue = [NSNumber numberWithFloat:-1.0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
    }
    animation.duration = self.animationDuration;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

- (CABasicAnimation *)flatAnimationReverse:(BOOL)reverse {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = self.animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    UIBezierPath *flatCheckMarkPath = [self pathForFlatCheckMark];
    
    if (reverse) {
        animation.fromValue = (id)[self pathForCheckMark].CGPath;
        animation.toValue = (id)flatCheckMarkPath.CGPath;
    } else {
        animation.fromValue = (id)flatCheckMarkPath.CGPath;
        animation.toValue = (id)[self pathForCheckMark].CGPath;
    }
    
    return animation;
}

- (CAKeyframeAnimation *)fillAnimationWithBounces:(NSUInteger)bounces amplitude:(CGFloat)amplitude reverse:(BOOL)reverse {
    NSMutableArray *values = [NSMutableArray new];
    NSMutableArray *keyTimes = [NSMutableArray new];
    
    if (reverse) {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    } else {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)]];
    }
    
    [keyTimes addObject:@0.0];
    
    for (NSUInteger i = 1; i <= bounces; i++) {
        CGFloat scale = (i % 2) ? (1 + amplitude/i) : (1 - amplitude/i);
        CGFloat time = i * 1.0/(bounces + 1);
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, scale)]];
        [keyTimes addObject:[NSNumber numberWithFloat:time]];
    }
    
    if (reverse) {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0001, 0.0001, 0.0001)]];
    } else {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    }
    
    [keyTimes addObject:@1.0];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = values;
    animation.delegate = self;
    animation.keyTimes = keyTimes;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = self.animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

@end
