//
//  CheckBoxTests.m
//  CheckBoxTests
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <BEMCheckBox/BEMCheckBox.h>

@interface CheckBoxTests : XCTestCase

@property (strong, nonatomic) BEMCheckBox *checkBox;

@end

@implementation CheckBoxTests

- (void)setUp {
    [super setUp];
    
    self.checkBox = [BEMCheckBox new];
}

- (void)tearDown {
    self.checkBox = nil;
    
    [super tearDown];
}

- (void)testInit {
    
    XCTAssertNotNil(self.checkBox);
    
    // Default values
    XCTAssert(self.checkBox.on == NO, @"The default value for 'on' should be 'NO'");
    XCTAssert(self.checkBox.hideBox == NO, @"The box shouldn't be hidden by default");
    XCTAssert([self.checkBox.onTintColor isEqual:[UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1]], @"Default on tint color");
    XCTAssert([self.checkBox.onFillColor isEqual:[UIColor clearColor]], @"Default on fill color");
    XCTAssert([self.checkBox.onCheckColor isEqual:[UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1]], @"Default on check color");
    XCTAssert([self.checkBox.tintColor isEqual:[UIColor lightGrayColor]], @"Default tint color");
    XCTAssert(self.checkBox.lineWidth == 2.0, @"Default line width should be 2.0");
    XCTAssert(self.checkBox.animationDuration == 0.5, @"Default animation duration should be 0.5");
    XCTAssert(self.checkBox.onAnimationType == BEMAnimationTypeStroke, @"Default on animation should be of type stroke");
    XCTAssert(self.checkBox.offAnimationType == BEMAnimationTypeStroke, @"Default off animation should be of type stroke");
    XCTAssert([self.checkBox.backgroundColor isEqual:[UIColor clearColor]], @"Background color should be transparent");
}

- (void)testSetOnAnimated {
    [self.checkBox setOn:YES animated:NO];
    XCTAssert(self.checkBox.on == YES);
    XCTAssert(self.checkBox.layer.sublayers.count == 3);
    
    [self.checkBox setOn:NO animated:NO];
    XCTAssert(self.checkBox.on == NO);
    XCTAssert(self.checkBox.layer.sublayers.count == 1);
    
    [self.checkBox setOn:YES animated:YES];
    XCTAssert(self.checkBox.on == YES);
    XCTAssert(self.checkBox.layer.sublayers.count == 3);
    
    [self.checkBox setOn:NO animated:YES];
    XCTAssert(self.checkBox.on == NO);
}

- (void)testOn {
    self.checkBox.on = YES;
    XCTAssert(self.checkBox.on == YES);
    XCTAssert(self.checkBox.layer.sublayers.count == 3);
    
    self.checkBox.on = NO;
    XCTAssert(self.checkBox.on == NO);
    XCTAssert(self.checkBox.layer.sublayers.count == 1);
}

- (void)testReload {
    self.checkBox.on = NO;
    XCTAssert(self.checkBox.on == NO);
    [self.checkBox reload];
    XCTAssert(self.checkBox.on == NO);
    self.checkBox.on = YES;
    XCTAssert(self.checkBox.on == YES);
    [self.checkBox reload];
    XCTAssert(self.checkBox.on == YES);
}

@end
