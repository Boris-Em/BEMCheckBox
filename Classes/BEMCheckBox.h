//
//  BEMCheckBox.h
//  CheckBox
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE

typedef NS_ENUM(NSInteger, BEMCheckBoxMode) {
    BEMCheckBoxModeStroke,
    BEMCheckBoxModeFill
};

typedef NS_ENUM(NSInteger, BEMBoxType) {
    BEMBoxTypeCircle,
    BEMBoxTypeSquare
};

typedef NS_ENUM(NSInteger, BEMAnimationType) {
    BEMAnimationTypeStroke,
    BEMAnimationTypeFill,
    BEMAnimationTypeFade
};

@interface BEMCheckBox : UIView

/** This property allows you to retrieve and set (without animation) a value determining whether the UISwitch object is on or off.
    Default to NO. */
@property (nonatomic) IBInspectable BOOL on;

@property (nonatomic) IBInspectable CGFloat lineWidth;

@property (nonatomic) IBInspectable CGFloat animationDuration;

@property (nonatomic) IBInspectable BOOL hideBox;

@property (strong, nonatomic) IBInspectable UIColor *onTintColor;

@property (strong, nonatomic) IBInspectable UIColor *tintColor;

@property (strong, nonatomic) IBInspectable UIColor *onCheckColor;

@property (nonatomic) BEMBoxType boxType;

@property (nonatomic) BEMAnimationType onAnimationType;

@property (nonatomic) BEMAnimationType offAnimationType;

@property (nonatomic) BEMCheckBoxMode mode;

/** Set the state of the switch to On or Off, optionally animating the transition. */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
