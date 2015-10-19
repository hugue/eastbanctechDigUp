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
@end

@implementation ExamFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startButton.enabled = NO;
    self.spinner.center = self.startButton.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
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
                [self.spinner stopAnimating];
                self.startButton.enabled = YES;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.startButton.enabled = NO;
                [self.spinner startAnimating];
            });
        }
    }];
    
    self.numberOfExercercisesLabel.text = [self.viewModel.dataModel.numberOfQuestions stringValue];
    self.durationLabel.text = [self.viewModel.dataModel.allowedTime stringValue];
    
    RAC(self.lastScoreLabel, text) = [RACObserve(self.viewModel.dataModel, currentScore) map:^id(NSNumber * value) {
        if (value) {
            return [NSString stringWithFormat:@"%@%%", [value stringValue]];
        }
        else {
            return @"%";
        }
    }];
    self.title = self.viewModel.dataModel.name;
}

@end
