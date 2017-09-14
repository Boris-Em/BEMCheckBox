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
#import "BEMCheckBoxGroup.h"

@interface BEMCheckBox ()

/** The layer where the box is drawn when the check box is set to On.
 */
@property (strong, nonatomic) CAShapeLayer *onBoxLayer;

/** The layer where the box is drawn when the check box is set to Off.
 */
@property (strong, nonatomic) CAShapeLayer *offBoxLayer;

/** The layer where the check mark is drawn when the check box is set to On.
 */
@property (strong, nonatomic) CAShapeLayer *checkMarkLayer;

/** The BEMAnimationManager object used to generate animations.
 */
@property (strong, nonatomic) BEMAnimationManager *animationManager;

/** The BEMPathManager object used to generate paths.
 */
@property (strong, nonatomic) BEMPathManager *pathManager;

/** The group this box is associated with.
 */
@property (strong, nonatomic, nullable) BEMCheckBoxGroup *group;

@end

/** Defines private methods that we can call to update our group's status.
 */
@interface BEMCheckBoxGroup ()

- (void)_checkBoxSelectionChanged:(BEMCheckBox *)checkBox;

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
    _offFillColor = [UIColor clearColor];
    _onCheckColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _tintColor = [UIColor lightGrayColor];
    _lineWidth = 2.0;
    _cornerRadius = 3.0;
    _animationDuration = 0.5;
    _minimumTouchSize = CGSizeMake(44, 44);
    _onAnimationType = BEMAnimationTypeStroke;
    _offAnimationType = BEMAnimationTypeStroke;
    self.backgroundColor = [UIColor clearColor];
    
    [self initPathManager];
    [self initAnimationManager];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCheckBox:)]];
}

- (void)initPathManager {
    _pathManager = [BEMPathManager new];
    _pathManager.lineWidth = _lineWidth;
    _pathManager.cornerRadius = _cornerRadius;
    _pathManager.boxType = _boxType;
}

- (void)initAnimationManager {
    _animationManager = [[BEMAnimationManager alloc] initWithAnimationDuration:_animationDuration];
}

- (void)layoutSubviews {
    self.pathManager.size = CGRectGetHeight(self.frame);
    
    [super layoutSubviews];
}

- (CGSize)intrinsicContentSize {
    return self.frame.size;
}

- (void)reload {
    [self.offBoxLayer removeFromSuperlayer];
    self.offBoxLayer = nil;
    
    [self.onBoxLayer removeFromSuperlayer];
    self.onBoxLayer = nil;
    
    [self.checkMarkLayer removeFromSuperlayer];
    self.checkMarkLayer = nil;
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

#pragma mark Setters
- (void)_setOn:(BOOL)on animated:(BOOL)animated notifyGroup:(BOOL)notifyGroup {
    _on = on;
    
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
    
    if(notifyGroup){
        [self.group _checkBoxSelectionChanged:self];
    }
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    [self _setOn:on animated:animated notifyGroup:YES];
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
    _animationManager.animationDuration = animationDuration;
}

- (void)setBoxType:(BEMBoxType)boxType {
    _boxType = boxType;
    _pathManager.boxType = boxType;
    [self reload];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _pathManager.lineWidth = lineWidth;
    [self reload];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _pathManager.cornerRadius = cornerRadius;
    [self reload];
}

- (void)setOffAnimationType:(BEMAnimationType)offAnimationType {
    _offAnimationType = offAnimationType;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self drawOffBox];
}

- (void)setOnTintColor:(UIColor *)onTintColor {
    _onTintColor = onTintColor;
    [self reload];
}

- (void)setOnFillColor:(UIColor *)onFillColor {
    _onFillColor = onFillColor;
    [self reload];
}

- (void)setOffFillColor:(UIColor *)offFillColor {
    _offFillColor = offFillColor;
    [self reload];
}

- (void)setOnCheckColor:(UIColor *)onCheckColor {
    _onCheckColor = onCheckColor;
    [self reload];
}

#pragma mark Gesture Recognizer
- (void)handleTapCheckBox:(UITapGestureRecognizer *)recognizer {
    // If we have a group that requires a selection, and we're already selected, don't allow a deselection
    if(self.group && self.group.mustHaveSelection && self.on){
        return;
    }
    
    [self setOn:!self.on animated:YES];
    if ([self.delegate respondsToSelector:@selector(didTapCheckBox:)]) {
        [self.delegate didTapCheckBox:self];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma  mark - Helper methods -

#pragma mark Increase touch area
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
{
    BOOL found = [super pointInside:point withEvent:event];
    
    if (found) {
        return found;
    }
    
    CGSize minimumSize = self.minimumTouchSize;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    if (found == NO && (width < minimumSize.width || height < minimumSize.height)) {
        CGFloat increaseWidth = minimumSize.width - width;
        CGFloat increaseHeight = minimumSize.height - height;
        
        CGRect rect = CGRectInset(self.bounds, (-increaseWidth / 2), (-increaseHeight / 2));
        
        found = CGRectContainsPoint(rect, point);
    }
    
    return found;
}

#pragma mark Drawings
- (void)drawRect:(CGRect)rect {
    [self setOn:self.on animated:NO];
}

/** Draws the entire checkbox, depending on the current state of the on property.
 */
- (void)drawEntireCheckBox {
    if (!self.hideBox) {
        if (!self.offBoxLayer || CGRectGetHeight(CGPathGetBoundingBox(self.offBoxLayer.path)) == 0.0) {
            [self drawOffBox];
        }
        if (self.on) {
            [self drawOnBox];
        }
    }
    if (self.on) {
        [self drawCheckMark];
    }
}

/** Draws the box used when the checkbox is set to Off.
 */
- (void)drawOffBox {
    [self.offBoxLayer removeFromSuperlayer];
    self.offBoxLayer = [CAShapeLayer layer];
    self.offBoxLayer.frame = self.bounds;
    self.offBoxLayer.path = [self.pathManager pathForBox].CGPath;
    self.offBoxLayer.fillColor = self.offFillColor.CGColor;
    self.offBoxLayer.strokeColor = self.tintColor.CGColor;
    self.offBoxLayer.lineWidth = self.lineWidth;
    self.offBoxLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    self.offBoxLayer.shouldRasterize = YES;
    
    [self.layer addSublayer:self.offBoxLayer];
}

/** Draws the box when the checkbox is set to On.
 */
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

/** Draws the check mark when the checkbox is set to On.
 */
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
            animation.delegate = self;
            [self.checkMarkLayer addAnimation:animation forKey:@"strokeEnd"];
        }
            return;
            
        case BEMAnimationTypeFill: {
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:0.18 reverse:NO];
            CABasicAnimation *opacityAnimation = [self.animationManager opacityAnimationReverse:NO];
            opacityAnimation.delegate = self;
            
            [self.onBoxLayer addAnimation:wiggle forKey:@"transform"];
            [self.checkMarkLayer addAnimation:opacityAnimation forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeBounce: {
            CGFloat amplitude = (self.boxType == BEMBoxTypeSquare) ? 0.20 : 0.35;
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:amplitude reverse:NO];
            wiggle.delegate = self;
            
            CABasicAnimation *opacity = [self.animationManager opacityAnimationReverse:NO];
            opacity.duration = self.animationDuration / 1.4;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:wiggle forKey:@"transform"];
        }
            return;
            
        case BEMAnimationTypeFlat: {
            CABasicAnimation *morphAnimation = [self.animationManager morphAnimationFromPath:[self.pathManager pathForFlatCheckMark] toPath:[self.pathManager pathForCheckMark]];
            morphAnimation.delegate = self;
            
            CABasicAnimation *opacity = [self.animationManager opacityAnimationReverse:NO];
            opacity.duration = self.animationDuration / 5;
            
            [self.onBoxLayer addAnimation:opacity forKey:@"opacity"];
            [self.checkMarkLayer addAnimation:morphAnimation forKey:@"path"];
            [self.checkMarkLayer addAnimation:opacity forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeOneStroke: {
            // Temporary set the path of the checkmark to the long checkmark
            self.checkMarkLayer.path = [[self.pathManager pathForLongCheckMark] bezierPathByReversingPath].CGPath;
            
            CABasicAnimation *boxStrokeAnimation = [self.animationManager strokeAnimationReverse:NO];
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2;
            [self.onBoxLayer addAnimation:boxStrokeAnimation forKey:@"strokeEnd"];
            
            CABasicAnimation *checkStrokeAnimation = [self.animationManager strokeAnimationReverse:NO];
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3;
            checkStrokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            checkStrokeAnimation.fillMode = kCAFillModeBackwards;
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration;
            [self.checkMarkLayer addAnimation:checkStrokeAnimation forKey:@"strokeEnd"];
            
            CABasicAnimation *checkMorphAnimation = [self.animationManager morphAnimationFromPath:[self.pathManager pathForLongCheckMark] toPath:[self.pathManager pathForCheckMark]];
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6;
            checkMorphAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            checkMorphAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkStrokeAnimation.duration;
            checkMorphAnimation.removedOnCompletion = NO;
            checkMorphAnimation.fillMode = kCAFillModeForwards;
            checkMorphAnimation.delegate = self;
            [self.checkMarkLayer addAnimation:checkMorphAnimation forKey:@"path"];
        }
            return;
            
        default: {
            CABasicAnimation *animation = [self.animationManager opacityAnimationReverse:NO];
            [self.onBoxLayer addAnimation:animation forKey:@"opacity"];
            animation.delegate = self;
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
            animation.delegate = self;
            [self.checkMarkLayer addAnimation:animation forKey:@"strokeEnd"];
        }
            return;
            
        case BEMAnimationTypeFill: {
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:0.18 reverse:YES];
            wiggle.duration = self.animationDuration;
            wiggle.delegate = self;
            
            [self.onBoxLayer addAnimation:wiggle forKey:@"transform"];
            [self.checkMarkLayer addAnimation:[self.animationManager opacityAnimationReverse:YES] forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeBounce: {
            CGFloat amplitude = (self.boxType == BEMBoxTypeSquare) ? 0.20 : 0.35;
            CAKeyframeAnimation *wiggle = [self.animationManager fillAnimationWithBounces:1 amplitude:amplitude reverse:YES];
            wiggle.duration = self.animationDuration / 1.1;
            CABasicAnimation *opacity = [self.animationManager opacityAnimationReverse:YES];
            opacity.delegate = self;
            
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
            [self.checkMarkLayer addAnimation:opacity forKey:@"opacity"];
        }
            return;
            
        case BEMAnimationTypeOneStroke: {
            self.checkMarkLayer.path = [[self.pathManager pathForLongCheckMark] bezierPathByReversingPath].CGPath;
            
            CABasicAnimation *checkMorphAnimation = [self.animationManager morphAnimationFromPath:[self.pathManager pathForCheckMark] toPath:[self.pathManager pathForLongCheckMark]];
            checkMorphAnimation.delegate = nil;
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6;
            [self.checkMarkLayer addAnimation:checkMorphAnimation forKey:@"path"];
            
            CABasicAnimation *checkStrokeAnimation = [self.animationManager strokeAnimationReverse:YES];
            checkStrokeAnimation.delegate = nil;
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration;
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3;
            [self.checkMarkLayer addAnimation:checkStrokeAnimation forKey:@"strokeEnd"];
            
            __weak __typeof__(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.checkMarkLayer.lineCap = kCALineCapButt;
            });
            
            CABasicAnimation *boxStrokeAnimation = [self.animationManager strokeAnimationReverse:YES];
            boxStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration;
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2;
            boxStrokeAnimation.delegate = self;
            [self.onBoxLayer addAnimation:boxStrokeAnimation forKey:@"strokeEnd"];
        }
            return;
            
        default: {
            CABasicAnimation *animation = [self.animationManager opacityAnimationReverse:YES];
            
            [self.onBoxLayer addAnimation:animation forKey:@"opacity"];
            animation.delegate = self;
            [self.checkMarkLayer addAnimation:animation forKey:@"opacity"];
        }
            return;
    }
}

#pragma mark Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES) {
        if (self.on == NO) {
            [self.onBoxLayer removeFromSuperlayer];
            [self.checkMarkLayer removeFromSuperlayer];
        }
        
        if ([self.delegate respondsToSelector:@selector(animationDidStopForCheckBox:)]) {
            [self.delegate animationDidStopForCheckBox:self];
        }
    }
}

- (void)dealloc {
    self.delegate = nil;
}

@end
