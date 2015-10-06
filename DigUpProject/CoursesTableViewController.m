//
//  CoursesTableViewController.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CoursesTableViewController.h"

@interface CoursesTableViewController ()

@end

@implementation CoursesTableViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseCellView" bundle:nil] forCellReuseIdentifier:@"CourseCellView"];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.viewModel didDeselectItemAtIndexPath:indexPath];
}

@end
