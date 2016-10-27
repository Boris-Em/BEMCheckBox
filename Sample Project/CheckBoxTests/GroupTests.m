//
//  GroupTests.m
//  CheckBox
//
//  Created by Bobo on 10/18/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <BEMCheckBox/BEMCheckBox.h>
#import <BEMCheckBox/BEMCheckBoxGroup.h>

@interface GroupTests : XCTestCase

@property (strong, nonatomic) NSArray <BEMCheckBox *> *checkBoxes;

@end

@implementation GroupTests

- (void)setUp {
    [super setUp];
    
    NSMutableArray <BEMCheckBox *> *checkBoxes = [NSMutableArray new];
    
    for (NSInteger i = 0; i < 5; i++) {
        [checkBoxes addObject:[BEMCheckBox new]];
    }
    self.checkBoxes = [NSArray arrayWithArray:checkBoxes];
}

- (void)testSelectedCheckBox {
    BEMCheckBoxGroup *group = [BEMCheckBoxGroup groupWithCheckBoxes:self.checkBoxes];
    XCTAssertNotNil(group);
    XCTAssertNil(group.selectedCheckBox);
    
    group.selectedCheckBox = [BEMCheckBox new];
    XCTAssertNil(group.selectedCheckBox);
    XCTAssertEqual([self selectedCheckBoxForGroup:group], group.selectedCheckBox);
    XCTAssertEqual([self numberOfSelectedCheckBoxesForGroup:group], 0);
    
    group.selectedCheckBox = self.checkBoxes[1];
    XCTAssertEqual(group.selectedCheckBox, self.checkBoxes[1]);
    XCTAssertEqual([self selectedCheckBoxForGroup:group], group.selectedCheckBox);
    XCTAssertEqual([self numberOfSelectedCheckBoxesForGroup:group], 1);
    
    group.selectedCheckBox = self.checkBoxes[2];
    XCTAssertEqual(group.selectedCheckBox, self.checkBoxes[2]);
    XCTAssertEqual([self selectedCheckBoxForGroup:group], group.selectedCheckBox);
    XCTAssertEqual([self numberOfSelectedCheckBoxesForGroup:group], 1);
    
    group.selectedCheckBox = self.checkBoxes[0];
    XCTAssertEqual(group.selectedCheckBox, self.checkBoxes[0]);
    XCTAssertEqual([self selectedCheckBoxForGroup:group], group.selectedCheckBox);
    XCTAssertEqual([self numberOfSelectedCheckBoxesForGroup:group], 1);
    
    group.selectedCheckBox = nil;
    XCTAssertNil(group.selectedCheckBox);
    XCTAssertEqual([self selectedCheckBoxForGroup:group], nil);
    XCTAssertEqual([self numberOfSelectedCheckBoxesForGroup:group], 0);
}

- (void)testAutoSelectFirstCheckBox {
    BEMCheckBoxGroup *group = [BEMCheckBoxGroup groupWithCheckBoxes:self.checkBoxes];
    XCTAssertNotNil(group);
    XCTAssertNil(group.selectedCheckBox);
    
    group.mustHaveSelection = YES;
    XCTAssertEqual(group.selectedCheckBox, [self.checkBoxes firstObject]);
    
    group.selectedCheckBox = nil;
    XCTAssertEqual(group.selectedCheckBox, [self.checkBoxes firstObject]);
}

- (void)testAddCheckBox {
    BEMCheckBoxGroup *group = [BEMCheckBoxGroup groupWithCheckBoxes:self.checkBoxes];
    XCTAssertNotNil(group);
    XCTAssertEqual(group.checkBoxes.count, self.checkBoxes.count);
    
    BEMCheckBox *checkBox = [BEMCheckBox new];
    [group addCheckBoxToGroup:checkBox];

    XCTAssertEqual(group.checkBoxes.count, self.checkBoxes.count + 1);
}

- (void)testRemoveCheckBox {
    BEMCheckBoxGroup *group = [BEMCheckBoxGroup groupWithCheckBoxes:self.checkBoxes];
    XCTAssertNotNil(group);
    XCTAssertEqual(group.checkBoxes.count, self.checkBoxes.count);
    
    [group removeCheckBoxFromGroup:[self.checkBoxes firstObject]];
    XCTAssertEqual(group.checkBoxes.count, self.checkBoxes.count - 1);
}

- (void)testEmptyGroup {
    BEMCheckBoxGroup *emptyGroup = [BEMCheckBoxGroup groupWithCheckBoxes:nil];
    XCTAssertNotNil(emptyGroup);
    XCTAssertEqual(emptyGroup.checkBoxes.count, 0);
    
    [emptyGroup removeCheckBoxFromGroup:[BEMCheckBox new]];
    XCTAssertEqual(emptyGroup.checkBoxes.count, 0);
    
    emptyGroup.mustHaveSelection = YES;
    XCTAssertEqual(emptyGroup.checkBoxes.count, 0);
    
    [emptyGroup addCheckBoxToGroup:[BEMCheckBox new]];
    XCTAssertEqual(emptyGroup.checkBoxes.count, 1);
}

#pragma mark Helper Methods

- (NSInteger)numberOfSelectedCheckBoxesForGroup:(BEMCheckBoxGroup *)group {
    NSInteger numberOfSelectedCheckBoxes = 0;
    for (BEMCheckBox *checkBox in group.checkBoxes) {
        if (checkBox.on == YES) {
            numberOfSelectedCheckBoxes++;
        }
    }

    return numberOfSelectedCheckBoxes;
}

- (BEMCheckBox *)selectedCheckBoxForGroup:(BEMCheckBoxGroup *)group {
    for (BEMCheckBox *checkBox in group.checkBoxes) {
        if (checkBox.on == YES) {
            return checkBox;
        }
    }
    
    return nil;
}

- (void)tearDown {
    [super tearDown];
}

@end
