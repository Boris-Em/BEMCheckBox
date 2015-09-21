//
//  BEMAnimationManager.h
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import UIKit;

/*
 * Animation object used by BEMCheckBox to generate animations.
 */
@interface BEMAnimationManager : NSObject

@property (weak, nonatomic) id delegate;

@property (nonatomic) CGFloat animationDuration;

- (instancetype)initWithAnimationDuration:(CGFloat)animationDuration;

- (CABasicAnimation *)strokeAnimationReverse:(BOOL)reverse;

- (CABasicAnimation *)opacityAnimationReverse:(BOOL)reverse;

- (CABasicAnimation *)morphAnimationFromPath:(UIBezierPath *)fromPath toPath:(UIBezierPath *)toPath ;

/** Animation engine to create a fill animation.
 * @param bounces The number of bounces for the animation.
 * @param amplitue How far does the animation bounce.
 * @param reserve Flag to track if the animation should fill or empty the layer.
 * @return Returns the CAKeyframeAnimation object.
 */
- (CAKeyframeAnimation *)fillAnimationWithBounces:(NSUInteger)bounces amplitude:(CGFloat)amplitude reverse:(BOOL)reverse;

@end
