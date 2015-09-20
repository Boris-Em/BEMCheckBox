//
//  BEMCheckBox.m
//  CheckBox
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "BEMCheckBox.h"
#import "BEMAnimationManager.h"
#import "BEMPathManager.h"

@interface BEMCheckBox ()

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) CAShapeLayer *onBoxLayer;
@property (strong, nonatomic) CAShapeLayer *offBoxLayer;
@property (strong, nonatomic) CAShapeLayer *checkMarkLayer;

@property (strong, nonatomic) BEMAnimationManager *animationManager;
@property (strong, nonatomic) BEMPathManager *pathManager;

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
    _offAnimationType = BEMAnimationTypeStroke;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCheckBox:)];
    _animationManager = [[BEMAnimationManager alloc] initWithAnimationDuration:_animationDuration];
    self.backgroundColor = [UIColor clearColor];
    
    [self initPathManager];
}

- (void)initPathManager {
    _pathManager = [BEMPathManager new];
    _pathManager.lineWidth = _lineWidth;
    _pathManager.boxType = _boxType;
}

- (void)layoutSubviews {
    self.pathManager.size = self.frame.size.height;
    
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

- (void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
    _animationManager.animationDuration = animationDuration;
}

- (void)setBoxType:(BEMBoxType)boxType {
    _boxType = boxType;
    _pathManager.boxType = boxType;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _pathManager.lineWidth = lineWidth;
}

- (void)setOffAnimationType:(BEMAnimationType)offAnimationType {
    _offAnimationType = offAnimationType;
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
    self.offBoxLayer.path = [self.pathManager pathForBox].CGPath;
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
    self.onBoxLayer.path = [self.pathManager pathForBox].CGPath;
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
    self.checkMarkLayer.path = [self.pathManager pathForCheckMark].CGPath;
    self.checkMarkLayer.strokeColor = self.onCheckColor.CGColor;
    self.checkMarkLayer.lineWidth = self.lineWidth;
    self.checkMarkLayer.fillColor = [UIColor clearColor].CGColor;
    self.checkMarkLayer.lineCap = kCALineCapRound;
    self.checkMarkLayer.lineJoin = kCALineJoinRound;
    
    self.checkMarkLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.checkMarkLayer.shouldRasterize = YES;
    [self.layer addSublayer:self.checkMarkLayer];
}

#pragma mark Animations
- (void)addOnAnimation {
    if (self.animationDuration == 0.0) {
        return;
    }
    
    switch (self.onAnimationType) {
        case BEMAnimationTypeStroke: {
            CABasicAnimation *animation = [self.animationManager strokeAnimationReverse:NO];
            
            [self.onBoxLayer addAnimation:animation forKey:@"strokeEnd"];
            [self.checkMarkLayer addAnimation:animation forKey:@"strokeEnd"];
        }
            return;
            
        case BEMAnimationTypeFill: {
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:0.18 reverse:NO];
            
            [self.onBoxLayer addAnimation:wiggle forKey:@"transform"];
            [self.checkMarkLayer addAnimation:[self.animationManager opacityAnimationReverse:NO] forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeBounce: {
            CGFloat amplitude = (self.boxType == BEMBoxTypeSquare) ? 0.20 : 0.35;
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:amplitude reverse:NO];
            
            CABasicAnimation *opacity = [self.animationManager opacityAnimationReverse:NO];
            opacity.duration = self.animationDuration / 1.4;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:wiggle forKey:@"transform"];
        }
            return;
            
        case BEMAnimationTypeFlat: {
            CABasicAnimation *animation = [self.animationManager morphAnimationFromPath:[self.pathManager pathForFlatCheckMark] toPath:[self.pathManager pathForCheckMark]];
            
            CABasicAnimation *opacity = [self.animationManager opacityAnimationReverse:NO];
            opacity.duration = self.animationDuration / 5;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"path"];
        }
            return;
            
        default: {
            CABasicAnimation *animation = [self.animationManager opacityAnimationReverse:NO];
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
            CABasicAnimation *animation = [self.animationManager strokeAnimationReverse:YES];
            
            [self.onBoxLayer addAnimation:animation forKey:@"strokeEnd"];
            [self.onBoxLayer addAnimation:[self.animationManager opacityAnimationReverse:YES] forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"strokeEnd"];
        }
            return;
            
        case BEMAnimationTypeFill: {
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:0.18 reverse:YES];
            wiggle.duration = self.animationDuration;
            
            [self.onBoxLayer addAnimation:wiggle forKey:@"transform"];
            [self.checkMarkLayer addAnimation:[self.animationManager opacityAnimationReverse:YES] forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeBounce: {
            CGFloat amplitude = (self.boxType == BEMBoxTypeSquare) ? 0.20 : 0.35;
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:amplitude reverse:YES];
            wiggle.duration = self.animationDuration / 1.1;
            CABasicAnimation *opacity = [self.animationManager opacityAnimationReverse:YES];
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:wiggle forKey:@"transform"];
        }
            return;
            
        case BEMAnimationTypeFlat: {
            CABasicAnimation *animation = [self.animationManager morphAnimationFromPath:[self.pathManager pathForCheckMark] toPath:[self.pathManager pathForFlatCheckMark]];
            animation.delegate = self;
            
            CABasicAnimation *opacity = [self.animationManager opacityAnimationReverse:YES];
            opacity.duration = self.animationDuration;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:animation forKey:@"path"];
        }
            return;
            
        default: {
            CABasicAnimation *animation = [self.animationManager opacityAnimationReverse:YES];
            
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
