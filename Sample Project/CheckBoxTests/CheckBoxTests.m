//
//  CheckBoxTests.m
//  CheckBoxTests
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <BEMCheckBox/BEMCheckBox-Swift.h>

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
    XCTAssertFalse(self.checkBox.on, @"The default value for 'on' should be 'NO'");
    XCTAssertFalse(self.checkBox.hideBox, @"The box shouldn't be hidden by default");
    XCTAssertEqualObjects(self.checkBox.onTintColor, [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1], @"Default on tint color");
    XCTAssertEqualObjects(self.checkBox.onFillColor, [UIColor clearColor], @"Default on fill color");
    XCTAssertEqualObjects(self.checkBox.onCheckColor, [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1], @"Default on check color");
    XCTAssertEqual(self.checkBox.tintColor, [UIColor lightGrayColor], @"Default tint color");
    XCTAssertEqual(self.checkBox.lineWidth, 2.0, @"Default line width should be 2.0");
    XCTAssertEqual(self.checkBox.animationDuration, 0.5, @"Default animation duration should be 0.5");
    XCTAssertEqual(self.checkBox.onAnimationType, BEMAnimationTypeStroke, @"Default on animation should be of type stroke");
    XCTAssertEqual(self.checkBox.offAnimationType, BEMAnimationTypeStroke, @"Default off animation should be of type stroke");
    XCTAssertEqual(self.checkBox.backgroundColor, [UIColor clearColor], @"Background color should be transparent");
    XCTAssertEqualObjects(self.checkBox.accessibilityValue, @"off", @"The default value for `accessibilityValue` should be `off`");
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitNone, @"The default value for `accessibilityTraits` should be `none`");
}

- (void)testSetOnAnimated {
    [self.checkBox setOn:YES animated:NO];
    XCTAssertTrue(self.checkBox.on);
    [self.checkBox layoutIfNeeded];
    XCTAssertEqual(self.checkBox.layer.sublayers.count, 3);
    
    [self.checkBox setOn:NO animated:NO];
    XCTAssertFalse(self.checkBox.on);
    [self.checkBox layoutIfNeeded];
    XCTAssertEqual(self.checkBox.layer.sublayers.count, 1);
    
    [self.checkBox setOn:YES animated:YES];
    XCTAssertTrue(self.checkBox.on);
    XCTAssertEqual(self.checkBox.layer.sublayers.count, 3);
    
    [self.checkBox setOn:NO animated:YES];
    XCTAssertFalse(self.checkBox.on);
}

- (void)testOn {
    self.checkBox.on = YES;
    XCTAssertTrue(self.checkBox.on);
    XCTAssertEqualObjects(self.checkBox.accessibilityValue, @"on");
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitSelected);

    [self.checkBox layoutIfNeeded];
    XCTAssertEqual(self.checkBox.layer.sublayers.count, 3);
    
    self.checkBox.on = NO;
    XCTAssertFalse(self.checkBox.on);
    XCTAssertEqualObjects(self.checkBox.accessibilityValue, @"off");
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitNone);

    [self.checkBox layoutIfNeeded];
    XCTAssertEqual(self.checkBox.layer.sublayers.count, 1);
}

- (void)testNotEnabled {
    [self.checkBox setEnabled:NO];
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitNotEnabled);

    self.checkBox.on = YES;
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitNotEnabled);
}

- (void)testUserInteractionNotEnabled {
    [self.checkBox setUserInteractionEnabled:NO];
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitNotEnabled);

    self.checkBox.on = YES;
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitNotEnabled);
}

- (void)testAccessibilitySetters {
    self.checkBox.accessibilityValue = @"foo";
    self.checkBox.accessibilityTraits = UIAccessibilityTraitPlaysSound;

    XCTAssertEqualObjects(self.checkBox.accessibilityValue, @"foo");
    XCTAssertEqual(self.checkBox.accessibilityTraits, UIAccessibilityTraitPlaysSound);
}

- (void)testReload {
    self.checkBox.on = NO;
    XCTAssertFalse(self.checkBox.on);
    
    [self.checkBox setNeedsDisplay];
    XCTAssertFalse(self.checkBox.on);
    
    self.checkBox.on = YES;
    XCTAssertTrue(self.checkBox.on);
    
    [self.checkBox setNeedsDisplay];
    XCTAssertTrue(self.checkBox.on);
}

@end
