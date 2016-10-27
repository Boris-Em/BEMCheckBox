//
//  BEMMainViewController.m
//  CheckBox
//
//  Created by Bobo on 9/21/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "BEMMainViewController.h"
#import <BEMCheckBox/BEMCheckBox.h>
#import "BEMCurrentSetupTableViewController.h"

@interface BEMMainViewController ()

@property (strong, nonatomic) IBOutlet BEMCheckBox *checkBox;

@property (strong, nonatomic) IBOutlet UISegmentedControl *drawTypeSegmentedControl;

@property (strong, nonatomic) IBOutlet UIButton *animationButton;

@end

@implementation BEMMainViewController

#pragma mark View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkBox.onAnimationType = BEMAnimationTypeBounce;
    self.checkBox.offAnimationType = BEMAnimationTypeBounce;
    
    self.animationButton.layer.cornerRadius = 5.0;
    self.animationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.animationButton.layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Actions
- (IBAction)didDragLineWidthSlider:(UISlider *)slider {
    self.checkBox.lineWidth = slider.value;
}

- (IBAction)didDragAnimationSpeedSlider:(UISlider *)slider {
    self.checkBox.animationDuration = slider.value;
}

- (IBAction)didTapOnBoxTypeSegmentedControl:(UISegmentedControl *)segmentedControl {
    self.checkBox.boxType = (segmentedControl.selectedSegmentIndex == 0) ?BEMBoxTypeCircle : BEMBoxTypeSquare;
}

- (IBAction)didTapOnDrawTypeSegmentedControl:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            self.checkBox.tintColor = [UIColor lightGrayColor];
            self.checkBox.onTintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
            self.checkBox.onFillColor = [UIColor clearColor];
            self.checkBox.onCheckColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
            break;
            
        default:
            self.checkBox.tintColor = [UIColor lightGrayColor];
            self.checkBox.onTintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
            self.checkBox.onFillColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
            self.checkBox.onCheckColor = [UIColor whiteColor];
            break;
    }
}

#pragma mark BEMAnimationsTableViewDelegate
- (void)didSelectAnimationType:(BEMAnimationType)animationType {
    self.checkBox.onAnimationType = animationType;
    self.checkBox.offAnimationType = animationType;
    
    if (animationType == BEMAnimationTypeStroke || animationType == BEMAnimationTypeOneStroke) {
        self.drawTypeSegmentedControl.selectedSegmentIndex = 0;
        [self.drawTypeSegmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        self.drawTypeSegmentedControl.enabled = NO;
    } else if (animationType == BEMAnimationTypeFill) {
        self.drawTypeSegmentedControl.selectedSegmentIndex = 1;
        [self.drawTypeSegmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        self.drawTypeSegmentedControl.enabled = NO;
    } else {
        self.drawTypeSegmentedControl.enabled = YES;
    }
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAnimationSelection"]) {
        BEMAnimationsTableViewController *destVC = (BEMAnimationsTableViewController *)segue.destinationViewController;
        destVC.delegate = self;
        destVC.selectedAnimation = self.checkBox.onAnimationType;
    } else if ([segue.identifier isEqualToString:@"toCurrentSetup"]) {
        BEMCurrentSetupTableViewController *destVC = (BEMCurrentSetupTableViewController *)segue.destinationViewController;
        destVC.checkBox = self.checkBox;
    }
}

@end
