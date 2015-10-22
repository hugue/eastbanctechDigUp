//
//  ExamFirstViewController.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamFirstViewController.h"
@interface ExamFirstViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * spinner;
@property (nonatomic, strong) UIAlertController * alert;
@end

@implementation ExamFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startButton.enabled = NO;
    self.spinner.center = self.startButton.center;
    self.spinner.hidesWhenStopped = YES;
    [self configureAlert];
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
    [RACObserve(self, viewModel.loadingState) subscribeNext:^(id x) {
        @strongify(self)
        if ([x integerValue] == ExamLoadingStateStopped) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                if (self.viewModel.examLoaded) {
                    self.startButton.enabled = YES;
                }
                else {
                    self.startButton.enabled = NO;
                    [self presentViewController:self.alert animated:YES completion:nil];
                }
            });
        }
        else if ([x integerValue] == ExamLoadingStateGoingOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.startButton.enabled = NO;
                [self.spinner startAnimating];
            });
        }
    }];
    
    self.numberOfExercercisesLabel.text = [self.viewModel.dataModel.numberOfQuestions stringValue];
    self.durationLabel.text = [self.viewModel.dataModel.allowedTime stringValue];
/*
    RAC(self.lastScoreLabel, text) = [RACObserve(self.viewModel.dataModel, currentScore) map:^id(NSNumber * value) {
        if (value) {
            return [NSString stringWithFormat:@"%@%%", [value stringValue]];
        }
        else {
            return @"%";
        }
    }];*/
    self.title = self.viewModel.dataModel.name;
}

- (void)configureAlert {
    self.alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Couldn't download the exam. Check your connection and try again" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [self.alert addAction:okAction];
}

@end
