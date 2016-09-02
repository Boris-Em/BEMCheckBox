//
//  CheckBoxUITests.m
//  CheckBoxUITests
//
//  Created by Boris Emorine on 9/2/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import <XCTest/XCTest.h>

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

@end
