//
//  ExamViewController.m
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamViewController.h"

@interface ExamViewController ()

@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.hidesBackButton = YES;
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.text = @"0:00";
    
    //UIBarButtonItem * myBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.timeLabel];
    //[self.navigationController.navigationItem setRightBarButtonItem:myBarButtonItem animated:NO];
    //[self.navigationController.navigationItem setTitleView:self.timeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    ExerciseViewController * viewController = [segue destinationViewController];
    viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
}

- (IBAction)showNext:(id)sender {
}

- (IBAction)showPrevious:(id)sender {
}

- (IBAction)endExam:(id)sender {
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel viewWillDisappear];
}

@end
