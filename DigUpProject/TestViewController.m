//
//  TestViewController.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TestViewController.h"
@interface TestViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * spinner;
@property (nonatomic, strong) UIAlertController * alert;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinner.center = self.view.center;
    self.spinner.hidesWhenStopped = YES;
    [self configureAlert];
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
    
    [RACObserve(self, viewModel.loadingState) subscribeNext:^(id x) {
        @strongify(self)
        if ([x integerValue] == TestLoadingStateGoingOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner startAnimating];
            });
        }
        else if ([x integerValue] == TestLoadingStateStopped) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                if (!self.viewModel.exerciseLoaded) {
                    [self presentViewController:self.alert animated:YES completion:nil];
                }
            });
        }
    }];
    self.title = self.viewModel.dataModel.name;
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

- (void)configureAlert {
    self.alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Couldn't download the exercise. Check your connection and try again" preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.alert addAction:okAction];
}


@end
