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
    [self.tableView registerClass:[CourseCellView class] forCellReuseIdentifier:self.viewModel.cellIdentifier];
    self.clearsSelectionOnViewWillAppear = NO;
    [self applyModelToView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    self.tableView = [[UITableView alloc] init];
    //self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)applyModelToView {
    [[RACObserve(self.viewModel, listModelCourses) skip: 1] subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CourseCellView * cell = (CourseCellView *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell applyModelToView];
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    self.viewModel.selectedCell = [NSNumber numberWithInt:[indexPath indexAtPosition:1]];
}

- (void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    self.viewModel.selectedCell = nil;
}

@end
