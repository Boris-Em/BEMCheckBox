//
//  AnimationManangerTests.m
//  CheckBox
//
//  Created by Bobo on 9/28/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BEMAnimationManager.h"

@interface AnimationManangerTests : XCTestCase

@property (strong, nonatomic) BEMAnimationManager *manager;

@end

@implementation AnimationManangerTests

- (void)setUp {
    [super setUp];
    
    self.manager = [[BEMAnimationManager alloc] initWithAnimationDuration:10.0];
}

- (void)testInit {
    
    XCTAssertNotNil(self.manager);
    XCTAssert(self.manager.animationDuration == 10.0);
}

- (void)tearDown {
    [super tearDown];
}

@end
