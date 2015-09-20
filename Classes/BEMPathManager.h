//
//  BEMPathManager.h
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import UIKit;
#import "BEMCheckBox.h"

/*
 * Path object used by BEMCheckBox to generate paths.
 */
@interface BEMPathManager : NSObject

@property (nonatomic) CGFloat size;

@property (nonatomic) CGFloat lineWidth;

/** The type of box.
 * @see BEMBoxType. */
@property (nonatomic) BEMBoxType boxType;

- (UIBezierPath *)pathForBox;

- (UIBezierPath *)pathForCheckMark;

- (UIBezierPath *)pathForFlatCheckMark;

@end
