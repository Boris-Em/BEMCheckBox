//
//  AnimationManangerTests.m
//  CheckBox
//
//  Created by Bobo on 9/28/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BEMCheckBox/BEMAnimationManager.h>

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

- (void)testStrokeAnimation {
    CABasicAnimation * animation = [self.manager strokeAnimationReverse:NO];
    XCTAssertNotNil(animation);
    XCTAssert(animation.duration == 10.0);
    XCTAssert([animation.fromValue isEqualToNumber:@0.0]);
    XCTAssert([animation.toValue isEqualToNumber:@1.0]);
    XCTAssert(animation.removedOnCompletion == NO);
    XCTAssert(animation.fillMode == kCAFillModeForwards);
    XCTAssert([animation.keyPath isEqualToString:@"strokeEnd"]);
    
    animation = [self.manager strokeAnimationReverse:YES];
    XCTAssert([animation.fromValue isEqualToNumber:@1.0]);
    XCTAssert([animation.toValue isEqualToNumber:@0.0]);
}

- (void)tearDown {
    self.manager = nil;
    [super tearDown];
}

@end
