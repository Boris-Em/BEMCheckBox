//
//  ViewController.m
//  CheckBox
//
//  Created by Bobo on 8/29/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "ViewController.h"
#import "BEMCheckBox.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BEMCheckBox *checkBox1 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
    checkBox1.onCheckColor = [UIColor whiteColor];
    checkBox1.boxType = BEMBoxTypeSquare;
    checkBox1.onAnimationType = BEMAnimationTypeFill;
    checkBox1.offAnimationType = BEMAnimationTypeFill;
    [self.view addSubview:checkBox1];
    
    BEMCheckBox *checkBox2 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(100, 200, 40, 40)];
    checkBox2.onAnimationType = BEMAnimationTypeStroke;
    checkBox2.offAnimationType = BEMAnimationTypeStroke;
    checkBox2.boxType = BEMBoxTypeSquare;
    [self.view addSubview:checkBox2];
    
    BEMCheckBox *checkBox3 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(100, 300, 40, 40)];
    checkBox3.onAnimationType = BEMAnimationTypeFade;
    checkBox3.offAnimationType = BEMAnimationTypeStroke;
    [self.view addSubview:checkBox3];
    
    BEMCheckBox *checkBox4 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(100, 400, 40, 40)];
    checkBox4.onCheckColor = [UIColor whiteColor];
    checkBox4.boxType = BEMBoxTypeCircle;
    checkBox4.onAnimationType = BEMAnimationTypeFill;
    checkBox4.offAnimationType = BEMAnimationTypeFill;
    [self.view addSubview:checkBox4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
