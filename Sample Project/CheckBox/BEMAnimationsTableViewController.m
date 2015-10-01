//
//  BEMAnimationsTableViewController.m
//  CheckBox
//
//  Created by Bobo on 9/30/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

#import "BEMAnimationsTableViewController.h"

@interface BEMAnimationsTableViewController ()

@end

@implementation BEMAnimationsTableViewController

#pragma mark View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:self.selectedAnimation inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectAnimationType:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
