//
//  BEMMainViewController.m
//  CheckBox
//
//  Created by Bobo on 9/21/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "BEMMainViewController.h"
#import "BEMCheckBox.h"

@interface BEMMainViewController ()

@property (strong, nonatomic) IBOutlet BEMCheckBox *checkBox;

@end

@implementation BEMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Actions
- (IBAction)didDragLineWidthSlider:(UISlider *)slider {
    self.checkBox.lineWidth = slider.value;
    [self.checkBox reload];
}

- (IBAction)didDragAnimationSpeedSlider:(UISlider *)slider {
    self.checkBox.animationDuration = slider.value;
}

- (IBAction)didTapOnBoxTypeSegmentedControl:(UISegmentedControl *)segmentedControl {
    
    self.checkBox.boxType = (segmentedControl.selectedSegmentIndex == 0) ?BEMBoxTypeCircle : BEMBoxTypeSquare;
    
    [self.checkBox reload];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
