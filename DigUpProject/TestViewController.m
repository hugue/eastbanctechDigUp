//
//  TestViewController.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TestViewController.h"
@interface TestViewController ()
@property (nonatomic, strong) UIActivityIndicatorView * spinner;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self applyModelToView];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    return [self.viewModel shouldPerformSegueWithIdentifier:identifier];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.identifier isEqualToString:@"displayExerciseSegue"]) {
        ExerciseViewController * viewController = [segue destinationViewController];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
    }
}

- (void)applyModelToView {
    @weakify(self)
    [RACObserve(self.viewModel, exerciseLoaded) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            if ([self shouldPerformSegueWithIdentifier:@"displayExerciseSegue" sender:nil]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"displayExerciseSegue" sender:nil];
                });
            }
        }
    }];
    
    [RACObserve(self.viewModel, exerciseViewModel.mediasLoaded) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner startAnimating];
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (IBAction)restartAsked:(id)sender {
    [self.viewModel restartAsked];
}

- (IBAction)solutionAsked:(id)sender {
    [self.viewModel solutionAsked];
}

- (IBAction)correctionAsked:(id)sender {
    [self.viewModel correctionAsked];
}

@end
