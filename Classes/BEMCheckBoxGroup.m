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

@property (nonatomic, strong, nonnull) NSHashTable *checkBoxes;

@end

/** Defines private methods that we can call on the check box.
 */
@interface BEMCheckBox ()

@property (strong, nonatomic, nullable) BEMCheckBoxGroup *group;

- (void)_setOn:(BOOL)on animated:(BOOL)animated notifyGroup:(BOOL)notifyGroup;

@end

@implementation BEMCheckBoxGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        _mustHaveSelection = NO;
        _checkBoxes = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
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
    if (checkBox.group) {
        [checkBox.group removeCheckBoxFromGroup:checkBox];
    }
    
    [checkBox _setOn:NO animated:NO notifyGroup:NO];
    checkBox.group = self;

    [self.checkBoxes addObject:checkBox];
}

- (void)removeCheckBoxFromGroup:(nonnull BEMCheckBox *)checkBox {
    if (![self.checkBoxes containsObject:checkBox]) {
        // Not in this group
        return;
    }
    
    checkBox.group = nil;
    [self.checkBoxes removeObject:checkBox];
}

#pragma mark Getters

- (BEMCheckBox *)selectedCheckBox {
    BEMCheckBox *selected = nil;
    for (BEMCheckBox *checkBox in self.checkBoxes) {
        if(checkBox.on){
            selected = checkBox;
            break;
        }
    }
    
    return selected;
}

#pragma mark Setters

- (void)setSelectedCheckBox:(BEMCheckBox *)selectedCheckBox {
    if (selectedCheckBox) {
        for (BEMCheckBox *checkBox in self.checkBoxes) {
            BOOL shouldBeOn = (checkBox == selectedCheckBox);
            if(checkBox.on != shouldBeOn){
                [checkBox _setOn:shouldBeOn animated:YES notifyGroup:NO];
            }
        }
    } else {
        // Selection is nil
        if(self.mustHaveSelection && [self.checkBoxes count] > 0){
            // We must have a selected checkbox, so re-call this method with the first checkbox
            self.selectedCheckBox = [self.checkBoxes anyObject];
        } else {
            for (BEMCheckBox *checkBox in self.checkBoxes) {
                BOOL shouldBeOn = NO;
                if(checkBox.on != shouldBeOn){
                    [checkBox _setOn:shouldBeOn animated:YES notifyGroup:NO];
                }
            }
        }
    }
}

- (void)setMustHaveSelection:(BOOL)mustHaveSelection {
    _mustHaveSelection = mustHaveSelection;
    
    // If it must have a selection and we currently don't, select the first box
    if (mustHaveSelection && !self.selectedCheckBox) {
        self.selectedCheckBox = [self.checkBoxes anyObject];
    }
}

#pragma mark Private methods called by BEMCheckBox

- (void)_checkBoxSelectionChanged:(BEMCheckBox *)checkBox {
    if ([checkBox on]) {
        // Change selected checkbox to this one
        self.selectedCheckBox = checkBox;
    } else if(checkBox == self.selectedCheckBox) {
        // Selected checkbox was this one, clear it
        self.selectedCheckBox = nil;
    }
}

@end
