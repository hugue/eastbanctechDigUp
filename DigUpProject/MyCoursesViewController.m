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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"coursesSegue"]) {
        CoursesTableViewController * coursesTableViewController = [segue destinationViewController];
        coursesTableViewController.viewModel = self.viewModel.coursesViewModel;
    }
    else if ([segue.identifier isEqualToString:@"detailCoursesSegue"]) {
        CoursesTableViewController * detailCoursesTableViewController = [segue destinationViewController];
        detailCoursesTableViewController.viewModel = self.viewModel.detailCoursesViewModel;
    }
}

- (void)applyModelToView {
    @weakify(self)
    [RACObserve(self.viewModel.detailCoursesViewModel, selectedCell) subscribeNext:^(id x) {
        @strongify(self)
        if (x) {
            [self performSegueWithIdentifier:@"viewDocument" sender:nil];
        }
    }];
}

@end
