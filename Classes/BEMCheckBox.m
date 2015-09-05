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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addGestureRecognizer:_tap];
}

- (void)commonInit {
    _on = NO;
    _hideBox = NO;
    _onTintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _onCheckColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _tintColor = [UIColor lightGrayColor];
    _lineWidth = 2.0;
    _animationDuration = 0.5;
    _onAnimationType = BEMAnimationTypeStroke;
    _offAnimationType = BEMAnimationTypeFade;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCheckBox:)];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark Setters
- (void)setOn:(BOOL)on animated:(BOOL)animated {
    [self setOn:on];
    [self drawEntireCheckBox];
    
    if (self.on) {
        if (animated) {
            [self addOnAnimation];
        }
        [self.layer addSublayer:self.onBoxLayer];
        [self.layer addSublayer:self.checkMarkLayer];
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
    self.onBoxLayer.rasterizationScale = 4.0 * [UIScreen mainScreen].scale;
    self.onBoxLayer.shouldRasterize = YES;

    if (self.onAnimationType == BEMAnimationTypeFill) {
        self.onBoxLayer.fillColor = self.onTintColor.CGColor;
        self.onBoxLayer.strokeColor = self.onTintColor.CGColor;
    } else {
        self.onBoxLayer.fillColor = [UIColor clearColor].CGColor;
        self.onBoxLayer.strokeColor = self.onTintColor.CGColor;
    }
}

- (void)drawCheckMark {
    [self.checkMarkLayer removeFromSuperlayer];
    self.checkMarkLayer = [CAShapeLayer layer];
    self.checkMarkLayer.frame = self.bounds;
    self.checkMarkLayer.path = [self pathForCheckMark].CGPath;
    self.checkMarkLayer.strokeColor = self.onCheckColor.CGColor;
    self.checkMarkLayer.lineWidth = self.lineWidth;
    self.checkMarkLayer.fillColor = [UIColor clearColor].CGColor;
    
    self.checkMarkLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.checkMarkLayer.shouldRasterize = YES;
}

#pragma mark Paths
- (UIBezierPath *)pathForBox {
    UIBezierPath* path;
    switch (self.boxType) {
        case BEMBoxTypeSquare:
            path = [UIBezierPath bezierPathWithRect:self.bounds];
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

#pragma mark Animations
- (void)addOnAnimation {
    if (self.animationDuration == 0.0) {
        return;
    }
    
    CABasicAnimation *animation;
    NSString *keyPath;
    
    animation = [CABasicAnimation animation];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    
    switch (self.onAnimationType) {
        case BEMAnimationTypeStroke: {
            keyPath = @"strokeEnd";
        }
            break;
            
        case BEMAnimationTypeFill: {
            keyPath = @"transform";
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0)];
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        }
            break;
            
        default: {
            keyPath = @"opacity";
        }
            break;
    }
    
    animation.keyPath = keyPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = self.animationDuration;

    [self.onBoxLayer addAnimation:animation forKey:keyPath];
    [self.checkMarkLayer addAnimation:animation forKey:keyPath];
}

- (void)addOffAnimation {
    if (self.animationDuration == 0.0) {
        [self.onBoxLayer removeFromSuperlayer];
        [self.checkMarkLayer removeFromSuperlayer];
    }

    CABasicAnimation *animation;
    NSString *keyPath;
    
    switch (self.offAnimationType) {
        case BEMAnimationTypeStroke: {
            keyPath = @"strokeEnd";
        }
            break;
            
        default: {
            keyPath = @"opacity";
        }
            break;
    }
    
    animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = self.animationDuration;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [self.onBoxLayer addAnimation:animation forKey:keyPath];
    [self.checkMarkLayer addAnimation:animation forKey:keyPath];
}

@end
