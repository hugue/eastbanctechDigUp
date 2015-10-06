//
//  MyCoursesViewController.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MyCoursesViewController.h"

@interface MyCoursesViewController ()

@end

@implementation MyCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self applyModelToView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyModelToView {
    @weakify(self)
    [RACObserve(self.viewModel, detailCoursesViewModel.selectedCell) subscribeNext:^(id x) {
        @strongify(self)
        if (x) {
            self.viewModel.documentViewModel.nameDocument = @"partition";
            [self performSegueWithIdentifier:@"viewDocument" sender:self];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CoursesTableViewController * tableViewController = [segue destinationViewController];
    tableViewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
}


@end
