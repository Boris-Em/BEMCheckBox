//
//  BEMCheckBoxGroup.m
//  CheckBox
//
//  Created by Cory Imdieke on 10/17/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import "BEMCheckBoxGroup.h"
#import "BEMCheckBox.h"

@interface BEMCheckBoxGroup ()

@property (nonatomic, strong, nonnull) NSArray<BEMCheckBox *> *checkBoxes;

@end

/** Defines private methods that we can call on the check box.
 */
@interface BEMCheckBox ()

@property (weak, nonatomic, nullable) BEMCheckBoxGroup *group;

- (void)_setOn:(BOOL)on animated:(BOOL)animated notifyGroup:(BOOL)notifyGroup;

@end

@implementation BEMCheckBoxGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        _mustHaveSelection = NO;
        _checkBoxes = @[];
    }
    return self;
}

+ (nonnull instancetype)groupWithCheckBoxes:(nullable NSArray<BEMCheckBox *> *)checkBoxes {
    BEMCheckBoxGroup *group = [[BEMCheckBoxGroup alloc] init];
    for (BEMCheckBox *checkbox in checkBoxes) {
        [group addCheckBoxToGroup:checkbox];
    }
    
    return group;
}

- (void)addCheckBoxToGroup:(nonnull BEMCheckBox *)checkBox {
    if([checkBox group]){
        // Already has a group, remove first
        [[checkBox group] removeCheckBoxFromGroup:checkBox];
    }
    
    [checkBox _setOn:NO animated:NO notifyGroup:NO];
    [checkBox setGroup:self];
    self.checkBoxes = [self.checkBoxes arrayByAddingObject:checkBox];
}

- (void)removeCheckBoxFromGroup:(nonnull BEMCheckBox *)checkBox {
    if(![self.checkBoxes containsObject:checkBox]){
        // Not in this group
        return;
    }
    
    [checkBox setGroup:nil];
    NSMutableArray *mutableBoxes = [self.checkBoxes mutableCopy];
    [mutableBoxes removeObject:checkBox];
    self.checkBoxes = [NSArray arrayWithArray:mutableBoxes];
}

- (BEMCheckBox *)selectedCheckBox {
    BEMCheckBox *checkbox = nil;
    for (BEMCheckBox *b in self.checkBoxes) {
        if([b on]){
            checkbox = b;
            break;
        }
    }
    
    return checkbox;
}

- (void)setSelectedCheckBox:(BEMCheckBox *)selectedCheckBox {
    if(selectedCheckBox){
        for (BEMCheckBox *b in self.checkBoxes) {
            BOOL shouldBeOn = (b == selectedCheckBox);
            if([b on] != shouldBeOn){
                [b _setOn:shouldBeOn animated:YES notifyGroup:NO];
            }
        }
    } else {
        // Selection is nil
        if(self.mustHaveSelection && [self.checkBoxes count] > 0){
            // We must have a selected checkbox, so re-call this method with the first checkbox
            [self setSelectedCheckBox:[self.checkBoxes firstObject]];
        } else {
            for (BEMCheckBox *b in self.checkBoxes) {
                BOOL shouldBeOn = NO;
                if([b on] != shouldBeOn){
                    [b _setOn:shouldBeOn animated:YES notifyGroup:NO];
                }
            }
        }
    }
}

- (void)setMustHaveSelection:(BOOL)mustHaveSelection{
    _mustHaveSelection = mustHaveSelection;
    
    // If it must have a selection and we currently don't, select the first box
    if(mustHaveSelection && !self.selectedCheckBox){
        [self setSelectedCheckBox:[self.checkBoxes firstObject]];
    }
}

#pragma mark Private methods called by BEMCheckBox

- (void)_checkBoxSelectionChanged:(BEMCheckBox *)checkBox {
    if([checkBox on]){
        // Change selected checkbox to this one
        [self setSelectedCheckBox:checkBox];
    } else if(checkBox == self.selectedCheckBox) {
        // Selected checkbox was this one, clear it
        [self setSelectedCheckBox:nil];
    }
}

@end
