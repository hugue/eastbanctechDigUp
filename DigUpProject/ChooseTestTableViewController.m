//
//  ChooseTestTableViewController.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ChooseTestTableViewController.h"

@interface ChooseTestTableViewController ()

@end

@implementation ChooseTestTableViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseCellView" bundle:nil] forCellReuseIdentifier:@"CourseCellView"];
    self.clearsSelectionOnViewWillAppear = NO;
}

@end
