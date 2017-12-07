//
//  BEMAnimationManager.h
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

/** Animation object used by BEMCheckBox to generate animations.
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_3
@interface BEMAnimationManager : NSObject <CAAnimationDelegate>
#else
@interface BEMAnimationManager : NSObject
#endif

/** The duration of the animation created by the BEMAnimationManager object.
 */
@property (nonatomic) CGFloat animationDuration;

@property (nonatomic, weak) id delegate;

/** Designated initializer.
 * @param animationDuration The duration of the animations created with the BEMAnimationManager object.
 * @return Returns the a fully initialized BEMAnimationManager object.
 */
- (instancetype)initWithAnimationDuration:(CGFloat)animationDuration delegate:(id)delegate;

/** Returns a CABasicAnimation which the stroke.
 * @param reverse The direction of the animation. Set to YES if the animation should go from opacity 0 to 1, or NO for the opposite.
 * @return Returns the CABasicAnimation object.
 */
- (CABasicAnimation *)strokeAnimationReverse:(BOOL)reverse;

/** Returns a CABasicAnimation which animates the opacity.
 * @param reverse The direction of the animation. Set to YES if the animation should go from opacity 0 to 1, or NO for the opposite.
 * @return Returns the CABasicAnimation object.
 */
- (CABasicAnimation *)opacityAnimationReverse:(BOOL)reverse;

/** Returns a CABasicAnimation which animates between two paths.
 * @param fromPath The path to transform (morph) from.
 * @param toPath The path to transform (morph) to.
 * @return Returns the CABasicAnimation object.
 */
- (CABasicAnimation *)morphAnimationFromPath:(UIBezierPath *)fromPath toPath:(UIBezierPath *)toPath ;

/** Animation engine to create a fill animation.
 * @param bounces The number of bounces for the animation.
 * @param amplitude How far does the animation bounce.
 * @param reverse Flag to track if the animation should fill or empty the layer.
 * @return Returns the CAKeyframeAnimation object.
 */
- (CAKeyframeAnimation *)fillAnimationWithBounces:(NSUInteger)bounces amplitude:(CGFloat)amplitude reverse:(BOOL)reverse;

@end
