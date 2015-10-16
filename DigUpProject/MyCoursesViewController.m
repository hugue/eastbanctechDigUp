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
    self.navigationItem.hidesBackButton = YES;
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
            CourseModel * currentCourse = [self.viewModel.profileCourses objectAtIndex:[self.viewModel.coursesViewModel.selectedCell integerValue]];
            if ([x integerValue] < currentCourse.subcourses.count) {
                [self performSegueWithIdentifier:@"viewDocumentSegue" sender:nil];
            }
            else {
                [self performSegueWithIdentifier:@"presentExamSegue" sender:nil];
            }
        }
    }];
    self.title = @"My Courses";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewDocumentSegue"]) {
        DocumentViewController * viewController = [segue destinationViewController];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];        
    }
    else if ([segue.identifier isEqualToString:@"presentExamSegue"]) {
        ExamViewController * viewController = [segue destinationViewController];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
    }
    else {
        CoursesTableViewController * viewController = [segue destinationViewController];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel viewWillAppear];
}


- (IBAction)logOut:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
