//
//  CheckBoxUITests.m
//  CheckBoxUITests
//
//  Created by Boris Emorine on 9/2/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BEMCheckBox/BEMCheckBox.h>

@interface CheckBoxUITests : XCTestCase

@end

@implementation CheckBoxUITests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testOn {
    XCUIElement *element = [[[[[[[[XCUIApplication alloc] init].otherElements containingType:XCUIElementTypeNavigationBar identifier:@"BEMCheckBox"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];    
    XCTAssertTrue(element.isHittable);
    
    [element tap];
    XCTAssertTrue(element.isHittable);
    
    [element tap];
    XCTAssertTrue(element.isHittable);
}

@end
