//
//  BEMCustomCollectionViewCell.h
//  CheckBox
//
//  Created by Boris Emorine on 9/14/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface BEMCustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;

@end
