//
//  BEMCheckBoxGroup.h
//  CheckBox
//
//  Created by Cory Imdieke on 10/17/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BEMCheckBox;

@interface BEMCheckBoxGroup : NSObject

/** An array of check boxes in this group.
 */
@property (nonatomic, strong, nonnull, readonly) NSHashTable *checkBoxes;

/** The currently selected check box. Only can be nil if mustHaveSelection is NO. Setting this value will cause the other check boxes to deselect automatically.
 */
@property (nonatomic, strong, nullable) BEMCheckBox *selectedCheckBox;

/** If YES, don't allow the user to unselect all options, must have single selection at all times. Default to NO.
 */
@property (nonatomic) BOOL mustHaveSelection;

/** Creates a new group with the list of check boxes.
 */
+ (nonnull instancetype)groupWithCheckBoxes:(nullable NSArray<BEMCheckBox *> *)checkBoxes;

/** Adds a check box to this group. Check boxes can only belong to a single group, adding to a group removes it from its current group.
 */
- (void)addCheckBoxToGroup:(nonnull BEMCheckBox *)checkBox;

/** Removes a check box from this group.
 */
- (void)removeCheckBoxFromGroup:(nonnull BEMCheckBox *)checkBox;

@end
