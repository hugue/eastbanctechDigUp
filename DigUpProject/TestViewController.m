//
//  TestViewController.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyModelToView];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    NSLog(@"Should Perform segue - %d",[self.viewModel shouldPerformSegueWithIdentifier:identifier]);
    return [self.viewModel shouldPerformSegueWithIdentifier:identifier];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.identifier isEqualToString:@"displayExerciseSegue"]) {
        ExerciseViewController * viewController = [segue destinationViewController];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
        NSLog(@"Will perform segue");
    }
}

- (void)applyModelToView {
    [RACObserve(self.viewModel, exerciseLoaded) subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"Exercise loaded");
            if ([self shouldPerformSegueWithIdentifier:@"displayExerciseSegue" sender:self]) {
                [self performSegueWithIdentifier:@"displayExerciseSegue" sender:self];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.viewModel viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.viewModel viewWillDisappear];
}

@end
