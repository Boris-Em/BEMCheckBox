//
//  BEMCurrentSetupTableViewController.m
//  CheckBox
//
//  Created by Bobo on 10/4/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

#import "BEMCurrentSetupTableViewController.h"

@interface BEMCurrentSetupTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *onPropertyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineWidthPropertyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *animationDurationPropertyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *hideBoxPropertyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *onTintColorPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *onFillColorPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *onCheckColorPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tintColorPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxTypePropertyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *onAnimationTypePropertyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *offAnimationTypePropertyValueLabel;

@end

@implementation BEMCurrentSetupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.onPropertyValueLabel.text = self.checkBox.on ? @"YES" : @"NO";
    self.lineWidthPropertyValueLabel.text = [NSString stringWithFormat:@"%.1f", self.checkBox.lineWidth];
    self.animationDurationPropertyValueLabel.text = [NSString stringWithFormat:@"%.2f", self.checkBox.animationDuration];
    self.hideBoxPropertyValueLabel.text = self.checkBox.hideBox ? @"YES" : @"NO";
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [self.checkBox.onTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.onTintColorPropertyLabel.text = [NSString stringWithFormat:@"R:%.0f - G:%.0f - B:%.0f", red * 255.0, green * 255.0, blue * 255.0];
    
    [self.checkBox.onFillColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.onFillColorPropertyLabel.text = [NSString stringWithFormat:@"R:%.0f - G:%.0f - B:%.0f", red * 255.0, green * 255.0, blue * 255.0];
    
    [self.checkBox.onCheckColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.onCheckColorPropertyLabel.text = [NSString stringWithFormat:@"R:%.0f - G:%.0f - B:%.0f", red * 255.0, green * 255.0, blue * 255.0];
    
    [self.checkBox.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.tintColorPropertyLabel.text = [NSString stringWithFormat:@"R:%.0f - G:%.0f - B:%.0f", red * 255.0, green * 255.0, blue * 255.0];
    
    self.boxTypePropertyValueLabel.text = self.checkBox.boxType ? @"BEMBoxTypeSquare" : @"BEMBoxTypeCircle";
    self.onAnimationTypePropertyValueLabel.text = [self stringForAnimationType:self.checkBox.onAnimationType];
    self.offAnimationTypePropertyValueLabel.text = [self stringForAnimationType:self.checkBox.offAnimationType];
}

#pragma mark Helper Methods
- (NSString *)stringForAnimationType:(BEMAnimationType)animationType {
    switch (animationType) {
        case BEMAnimationTypeBounce:
            return @"BEMAnimationTypeBounce";
            break;
        case BEMAnimationTypeFill:
            return @"BEMAnimationTypeFill";
            break;
        case BEMAnimationTypeFlat:
            return @"BEMAnimationTypeFlat";
            break;
        case BEMAnimationTypeOneStroke:
            return @"BEMAnimationTypeOneStroke";
            break;
        case BEMAnimationTypeStroke:
            return @"BEMAnimationTypeStroke";
            break;
            
        default:
            return @"BEMAnimationTypeFade";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
