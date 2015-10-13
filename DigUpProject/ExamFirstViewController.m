//
//  ExamFirstViewController.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamFirstViewController.h"

@implementation ExamFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startButton.enabled = NO;
    [self applyModelToView];
}

- (IBAction)startExam:(id)sender {
    [self performSegueWithIdentifier:@"startExamSegue" sender:nil];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    ExamViewController * viewController = [segue destinationViewController];
    viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
}

- (void)applyModelToView {
    @weakify(self)
    [RACObserve(self.viewModel, examLoaded) subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.startButton.enabled = YES;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.startButton.enabled = NO;
            });
        }
    }];
}

@end
