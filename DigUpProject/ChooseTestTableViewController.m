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
    [self applyModelToView];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    TestViewController * viewController = [segue destinationViewController];
    viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
}

- (void)applyModelToView {
    @weakify(self)
    [RACObserve(self.viewModel, selectedCell) subscribeNext:^(id x) {
        @strongify(self)
        if (x) {
            [self performSegueWithIdentifier:@"displayTestSegue" sender:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel viewWillDisappear];
}

@end
