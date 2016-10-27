//
//  BEMAnimationsTableViewController.h
//  CheckBox
//
//  Created by Bobo on 9/30/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMCheckBox/BEMCheckBox.h>

@protocol BEMAnimationsTableViewDelegate <NSObject>

@required
- (void)didSelectAnimationType:(BEMAnimationType)animationType;

@end

@interface BEMAnimationsTableViewController : UITableViewController

@property (weak, nonatomic) id delegate;

@property (nonatomic) BEMAnimationType selectedAnimation;

@end
