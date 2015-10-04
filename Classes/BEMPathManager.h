//
//  BEMPathManager.h
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import UIKit;
#import "BEMCheckBox.h"

/** Path object used by BEMCheckBox to generate paths.
 */
@interface BEMPathManager : NSObject

/** The paths are assumed to be created in squares. 
 * This is the size of width, or height, of the paths that will be created.
 */
@property (nonatomic) CGFloat size;

/** The width of the lines on the created paths.
 */
@property (nonatomic) CGFloat lineWidth;

/** The type of box.
 * Depending on the box type, paths may be created differently
 * @see BEMBoxType
 */
@property (nonatomic) BEMBoxType boxType;

/** Returns a UIBezierPath object for the box of the checkbox
 * @returns The path of the box.
 */
- (UIBezierPath *)pathForBox;

/** Returns a UIBezierPath object for the checkmark of the checkbox
 * @returns The path of the checkmark.
 */
- (UIBezierPath *)pathForCheckMark;

/** Returns a UIBezierPath object for an extra long checkmark which is in contact with the box.
 * @returns The path of the checkmark.
 */
- (UIBezierPath *)pathForLongCheckMark;

/** Returns a UIBezierPath object for the flat checkmark of the checkbox
 * @see BEMAnimationTypeFlat
 * @returns The path of the flat checkmark.
 */
- (UIBezierPath *)pathForFlatCheckMark;

@end
