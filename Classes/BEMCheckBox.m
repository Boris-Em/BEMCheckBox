//
//  BEMCheckBox.m
//  CheckBox
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "BEMCheckBox.h"

@interface BEMCheckBox ()

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) CAShapeLayer *onBoxLayer;
@property (strong, nonatomic) CAShapeLayer *offBoxLayer;
@property (strong, nonatomic) CAShapeLayer *checkMarkLayer;

@end

@implementation BEMCheckBox

#pragma mark Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self commonInit];
    return self;
}

- (void)commonInit {
    // Default values
    _on = NO;
    _hideBox = NO;
    _onTintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _onFillColor = [UIColor clearColor];
    _onCheckColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _tintColor = [UIColor lightGrayColor];
    _lineWidth = 2.0;
    _animationDuration = 0.5;
    _onAnimationType = BEMAnimationTypeStroke;
    _offAnimationType = BEMAnimationTypeFade;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCheckBox:)];
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addGestureRecognizer:_tap];
}

#pragma mark Setters
- (void)setOn:(BOOL)on animated:(BOOL)animated {
    // Sets the property to the correct value
    [self setOn:on];
    
    [self drawEntireCheckBox];
    
    if (on) {
        if (animated) {
            [self addOnAnimation];
        }
    } else {
        if (animated) {
            [self addOffAnimation];
        } else {
            [self.onBoxLayer removeFromSuperlayer];
            [self.checkMarkLayer removeFromSuperlayer];
        }
    }
}

#pragma mark Gesture Recognizer
- (void)handleTapCheckBox:(UITapGestureRecognizer *)recognizer {
    [self setOn:!self.on animated:YES];
}

#pragma  mark - Helper methods -
#pragma mark Drawings
- (void)drawRect:(CGRect)rect {
    [self setOn:self.on animated:NO];
}

/// Draws the entire checkbox, depending on the current state of the on property.
- (void)drawEntireCheckBox {
    if (!self.hideBox) {
        if (!self.offBoxLayer) {
            [self drawOffBox];
        }
        if (self.on) {
            [self drawOnBox];
            [self drawCheckMark];
        }
    }
}

/// Draws the box used when the checkbox is set to NO.
- (void)drawOffBox {
    [self.offBoxLayer removeFromSuperlayer];
    self.offBoxLayer = [CAShapeLayer layer];
    self.offBoxLayer.frame = self.bounds;
    self.offBoxLayer.path = [self pathForBox].CGPath;
    self.offBoxLayer.fillColor = [UIColor clearColor].CGColor;
    self.offBoxLayer.strokeColor = self.tintColor.CGColor;
    self.offBoxLayer.lineWidth = self.lineWidth;
    
    self.offBoxLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.offBoxLayer.shouldRasterize = YES;
    
    [self.layer addSublayer:self.offBoxLayer];
}

/// Draws the box when the checkbox is set to YES.
- (void)drawOnBox {
    [self.onBoxLayer removeFromSuperlayer];
    self.onBoxLayer = [CAShapeLayer layer];
    self.onBoxLayer.frame = self.bounds;
    self.onBoxLayer.path = [self pathForBox].CGPath;
    self.onBoxLayer.lineWidth = self.lineWidth;
    self.onBoxLayer.fillColor = self.onFillColor.CGColor;
    self.onBoxLayer.strokeColor = self.onTintColor.CGColor;
    self.onBoxLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.onBoxLayer.shouldRasterize = YES;
    [self.layer addSublayer:self.onBoxLayer];
}

- (void)drawCheckMark {
    [self.checkMarkLayer removeFromSuperlayer];
    self.checkMarkLayer = [CAShapeLayer layer];
    self.checkMarkLayer.frame = self.bounds;
    self.checkMarkLayer.path = [self pathForCheckMark].CGPath;
    self.checkMarkLayer.strokeColor = self.onCheckColor.CGColor;
    self.checkMarkLayer.lineWidth = self.lineWidth;
    self.checkMarkLayer.fillColor = [UIColor clearColor].CGColor;
    self.checkMarkLayer.lineCap = kCALineCapRound;
    self.checkMarkLayer.lineJoin = kCALineJoinRound;
    
    self.checkMarkLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.checkMarkLayer.shouldRasterize = YES;
    [self.layer addSublayer:self.checkMarkLayer];
}

#pragma mark Paths
- (UIBezierPath *)pathForBox {
    UIBezierPath* path;
    switch (self.boxType) {
        case BEMBoxTypeSquare:
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:3.0];
            break;
            
        default:
            path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.lineWidth, self.lineWidth, self.bounds.size.width - self.lineWidth*2, self.bounds.size.height - self.lineWidth*2)];
            break;
    }
    return path;
}

- (UIBezierPath *)pathForCheckMark {
    UIBezierPath* checkMarkPath = [UIBezierPath bezierPath];
    
    [checkMarkPath moveToPoint: CGPointMake(self.bounds.size.height/3.1578, self.frame.size.height/2)];
    [checkMarkPath addLineToPoint: CGPointMake(self.frame.size.height/2.0618, self.frame.size.height/1.57894)];
    [checkMarkPath addLineToPoint: CGPointMake(self.frame.size.height/1.3953, self.frame.size.height/2.7272)];
    
    if (self.boxType == BEMBoxTypeSquare) {
        // If we use a square box, the check mark should be a little bit bigger
        [checkMarkPath applyTransform:CGAffineTransformMakeScale(1.5, 1.5)];
        [checkMarkPath applyTransform:CGAffineTransformMakeTranslation(-self.bounds.size.height/4, -self.bounds.size.height/4)];
    }
    
    return checkMarkPath;
}

- (UIBezierPath *)pathForFlatCheckMark {
    UIBezierPath* flatCheckMarkPath = [UIBezierPath bezierPath];
    [flatCheckMarkPath moveToPoint: CGPointMake(self.bounds.size.height/4, self.frame.size.height/2)];
    [flatCheckMarkPath addLineToPoint: CGPointMake(self.bounds.size.height/2, self.frame.size.height/2)];
    [flatCheckMarkPath addLineToPoint: CGPointMake(self.bounds.size.height/1.2, self.frame.size.height/2)];

    return flatCheckMarkPath;
}

#pragma mark Animations
- (void)addOnAnimation {
    if (self.animationDuration == 0.0) {
        return;
    }
    
    switch (self.onAnimationType) {
        case BEMAnimationTypeStroke: {
            CABasicAnimation *animation = [self strokeAnimationReverse:NO];
            
            [self.onBoxLayer addAnimation:animation forKey:@"strokeEnd"];
            [self.checkMarkLayer addAnimation:animation forKey:@"strokeEnd"];
        }
            return;
            
        case BEMAnimationTypeFill: {
            CAKeyframeAnimation *wiggle = [self fillAnimationWithBounces:1 amplitude:0.18 reverse:NO];
            
            [self.onBoxLayer addAnimation:wiggle forKey:@"transform"];
            [self.checkMarkLayer addAnimation:[self opacityAnimationReverse:NO] forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeBounce: {
            CGFloat amplitude = (self.boxType == BEMBoxTypeSquare) ? 0.20 : 0.35;
            CAKeyframeAnimation *wiggle = [self fillAnimationWithBounces:1 amplitude:amplitude reverse:NO];
            
            CABasicAnimation *opacity = [self opacityAnimationReverse:NO];
            opacity.duration = self.animationDuration / 1.4;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:wiggle forKey:@"transform"];
        }
            return;
            
        case BEMAnimationTypeFlat: {
            CABasicAnimation *animation = [self flatAnimationReverse:NO];
            
            CABasicAnimation *opacity = [self opacityAnimationReverse:NO];
            opacity.duration = self.animationDuration / 5;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"path"];
        }
            return;
            
        default: {
            CABasicAnimation *animation = [self opacityAnimationReverse:NO];
            [self.onBoxLayer addAnimation:animation forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"opacity"];
        }
            return;
    }
}

- (void)addOffAnimation {
    if (self.animationDuration == 0.0) {
        [self.onBoxLayer removeFromSuperlayer];
        [self.checkMarkLayer removeFromSuperlayer];
        return;
    }
    
    switch (self.offAnimationType) {
        case BEMAnimationTypeStroke: {
            CABasicAnimation *animation = [self strokeAnimationReverse:YES];
            
            [self.onBoxLayer addAnimation:animation forKey:@"strokeEnd"];
            [self.onBoxLayer addAnimation:[self opacityAnimationReverse:YES] forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"strokeEnd"];
        }
            return;
            
        case BEMAnimationTypeFill: {
            CAKeyframeAnimation *wiggle = [self fillAnimationWithBounces:1 amplitude:0.18 reverse:YES];
            wiggle.duration = self.animationDuration;
            
            [self.onBoxLayer addAnimation:wiggle forKey:@"transform"];
            [self.checkMarkLayer addAnimation:[self opacityAnimationReverse:YES] forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeBounce: {
            CGFloat amplitude = (self.boxType == BEMBoxTypeSquare) ? 0.20 : 0.35;
            CAKeyframeAnimation *wiggle = [self fillAnimationWithBounces:1 amplitude:amplitude reverse:YES];
            wiggle.duration = self.animationDuration / 1.1;
            CABasicAnimation *opacity = [self opacityAnimationReverse:YES];
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:wiggle forKey:@"transform"];
        }
            return;
            
        case BEMAnimationTypeFlat: {
            CABasicAnimation *animation = [self flatAnimationReverse:YES];
            
            CABasicAnimation *opacity = [self opacityAnimationReverse:YES];
            opacity.duration = self.animationDuration;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"path"];
        }
            return;
            
        default: {
            CABasicAnimation *animation = [self opacityAnimationReverse:YES];
            
            [self.onBoxLayer addAnimation:animation forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"opacity"];
        }
            return;
    }
}

#pragma mark Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES && self.on == NO) {
        [self.onBoxLayer removeFromSuperlayer];
        [self.checkMarkLayer removeFromSuperlayer];
    }
}

- (void)dealloc {
    NSLog(@"Dealloc");
}

@end
