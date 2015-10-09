//
//  BEMCheckBox.h
//  CheckBox
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE

/**  Tasteful Checkbox for iOS.
 */
@interface BEMCheckBox : UIView

/** The different type of boxes available.
 * @see boxType
 */
typedef NS_ENUM(NSInteger, BEMBoxType) {
    /** Circled box.
     */
    BEMBoxTypeCircle,
    
    /** Squared box.
     */
    BEMBoxTypeSquare
};

/** The different type of animations available.
 * @see onAnimationType and offAnimationType.
 */
typedef NS_ENUM(NSInteger, BEMAnimationType) {
    /** Animates the box and the check as if they were drawn.
     *  Should be used with a clear colored onFillColor property.
     */
    BEMAnimationTypeStroke,
    
    /** When tapped, the checkbox is filled from its center.
     * Should be used with a colored onFillColor property.
     */
    BEMAnimationTypeFill,
    
    /** Animates the check mark with a bouncy effect.
     */
    BEMAnimationTypeBounce,
    
    /** Morphs the checkmark from a line.
     * Should be used with a colored onFillColor property.
     */
    BEMAnimationTypeFlat,
    
    /** Animates the box and check as if they were drawn in one continuous line.
     * Should be used with a clear colored onFillColor property.
     */
    BEMAnimationTypeOneStroke,
    
    /** When tapped, the checkbox is fading in or out (opacity).
     */
    BEMAnimationTypeFade
};

/** This property allows you to retrieve and set (without animation) a value determining whether the BEMCheckBox object is On or Off.
  * Default to NO.
 */
@property (nonatomic) IBInspectable BOOL on;

/** The width of the lines of the check mark and the box. Default to 2.0.
 */
@property (nonatomic) IBInspectable CGFloat lineWidth;

/** The duration in seconds of the animation when the check box switches from on and off. Default to 0.5.
 */
@property (nonatomic) IBInspectable CGFloat animationDuration;

/** BOOL to control if the box should be hidden or not. Defaults to NO.
 */
@property (nonatomic) IBInspectable BOOL hideBox;

/** The color of the line around the box when it is On.
 */
@property (strong, nonatomic) IBInspectable UIColor *onTintColor;

/** The color of the inside of the box when it is On.
 */
@property (strong, nonatomic) IBInspectable UIColor *onFillColor;

/** The color of the check mark when it is On.
 */
@property (strong, nonatomic) IBInspectable UIColor *onCheckColor;

/** The color of the box when the checkbox is Off.
 */
@property (strong, nonatomic) IBInspectable UIColor *tintColor;

/** The type of box.
 * @see BEMBoxType. 
 */
@property (nonatomic) BEMBoxType boxType;

/** The animation type when the check mark gets set to On.
 * @warning Some animations might not look as intended if the different colors of the control are not appropriatly configured.
 * @see BEMAnimationType. 
 */
@property (nonatomic) BEMAnimationType onAnimationType;

/** The animation type when the check mark gets set to Off.
 * @warning Some animations might not look as intended if the different colors of the control are not appropriatly configured.
 * @see BEMAnimationType. 
 */
@property (nonatomic) BEMAnimationType offAnimationType;

/** Set the state of the check box to On or Off, optionally animating the transition.
 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

/** Forces a redraw of the entire check box.
 * The current value of On is kept.
 */
- (void)reload;

@end
