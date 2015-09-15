//
//  BEMCheckBox.h
//  CheckBox
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE

typedef NS_ENUM(NSInteger, BEMBoxType) {
    BEMBoxTypeCircle,
    BEMBoxTypeSquare
};

typedef NS_ENUM(NSInteger, BEMAnimationType) {
    BEMAnimationTypeStroke,
    BEMAnimationTypeFill,
    BEMAnimationTypeBounce,
    BEMAnimationTypeFade
};

@interface BEMCheckBox : UIView

/** This property allows you to retrieve and set (without animation) a value determining whether the UISwitch object is on or off.
    Default to NO. */
@property (nonatomic) IBInspectable BOOL on;

/// The width of the line of the check mark and around the box. Default to 2.0.
@property (nonatomic) IBInspectable CGFloat lineWidth;

/// The duration in seconds of the animation when the check box switches from on and off. Default to 0.5.
@property (nonatomic) IBInspectable CGFloat animationDuration;

/// BOOL to control if the box when the control if off should be hidden or not. Defaults to NO.
@property (nonatomic) IBInspectable BOOL hideBox;

/// The color of the line around the box when it is "on".
@property (strong, nonatomic) IBInspectable UIColor *onTintColor;

/// The color of the inside of the box when it is "on".
@property (strong, nonatomic) IBInspectable UIColor *onFillColor;

/// The color of the check mark (only visible when "on").
@property (strong, nonatomic) IBInspectable UIColor *onCheckColor;

/// The color of the box when it is "off"
@property (strong, nonatomic) IBInspectable UIColor *tintColor;

/** The type of box.
 * @see BEMBoxType. */
@property (nonatomic) BEMBoxType boxType;

/** The animation type when the check mark is gets set to "on".
 * @warning Some animations might not look as intended if the different colors of the control are not appropriatly configured.
 * @see BEMAnimationType. */
@property (nonatomic) BEMAnimationType onAnimationType;

/** The animation type when the check mark is gets set to "off".
 * @warning Some animations might not look as intended if the different colors of the control are not appropriatly configured.
 * @see BEMAnimationType. */
@property (nonatomic) BEMAnimationType offAnimationType;

/** Set the state of the switch to On or Off, optionally animating the transition. */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
