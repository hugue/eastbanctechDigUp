//
//  ExamViewController.m
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamViewController.h"

@interface ExamViewController ()

@property (nonatomic, weak) ExerciseViewController * exerciseViewController;
@property (nonatomic, strong) UIAlertController * backAlert;

@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.text = @"0:00";
    [self.navigationItem setTitleView:self.timeLabel];
    
    //Swipe gesture recognizers
    UISwipeGestureRecognizer * previousSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPrevious:)];
    UISwipeGestureRecognizer * nextSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNext:)];
    nextSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    previousSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    previousSwipeRecognizer.numberOfTouchesRequired = 1;
    nextSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:previousSwipeRecognizer];
    [self.view addGestureRecognizer:nextSwipeRecognizer];
    
    [self configureBackAlertController];
    [self applyModelToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleChange:(RACTuple *)changeParams {
    ExerciseViewModel * viewModel = changeParams.first;
    ExerciseChangeDirection direction = [changeParams.second integerValue];
    switch (direction) {
        case ExerciseChangeDirectionRight: {
                CATransition * applicationLoadViewIn = [CATransition animation];
                [applicationLoadViewIn setDuration:0.3];
                [applicationLoadViewIn setType:kCATransitionPush];
                [applicationLoadViewIn setSubtype:kCATransitionFromLeft];
                [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                [self.exerciseView.layer addAnimation:applicationLoadViewIn forKey:kCATransitionPush];
                [self.exerciseViewController removeViewModel:nil];
                [self.exerciseViewController setViewModel:viewModel];
            }
            break;
        case ExerciseChangeDirectionLeft: {
                CATransition * applicationLoadViewIn = [CATransition animation];
                [applicationLoadViewIn setDuration:0.3];
                [applicationLoadViewIn setType:kCATransitionPush];
                [applicationLoadViewIn setSubtype:kCATransitionFromRight];
                [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                [self.exerciseView.layer addAnimation:applicationLoadViewIn forKey:kCATransitionPush];
                [self.exerciseViewController removeViewModel:nil];
                [self.exerciseViewController setViewModel:viewModel];
            }
            break;
        case ExerciseChangeDirectionNull:
            {
                [self.exerciseViewController removeViewModel:nil];
                [self.exerciseViewController setViewModel:viewModel];
            }
            break;
        default:
            break;
    }
}

- (void)configureBackAlertController {
    self.backAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Going back will erase all the answers given" preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        [self.viewModel goBack];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.backAlert addAction:okAction];
    [self.backAlert addAction:cancelAction];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.identifier isEqualToString:@"displayExerciseSegue"]) {
        ExerciseViewController * viewController = [segue destinationViewController];
        self.exerciseViewController = viewController;
    }
    else if ([segue.identifier isEqualToString:@"examResultSegue"]) {
        ExamResultViewController * viewController = [segue destinationViewController];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
    }
}

- (IBAction)goBack:(id)sender {
    [self presentViewController:self.backAlert animated:YES completion:nil];
}

- (IBAction)showNext:(id)sender {
    [self.viewModel selectNextExercise];
}

- (IBAction)showPrevious:(id)sender {
    [self.viewModel selectPreviousExercise];
}

- (IBAction)endExam:(id)sender {
    [self.viewModel examDone];
    [self performSegueWithIdentifier:@"examResultSegue" sender:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel viewWillDisappear];
}

- (void)applyModelToView {
    @weakify(self)
    RAC (self.pageLabel, text) = [RACObserve(self, viewModel.currentExerciseIndex) map:^id(id value) {
        @strongify(self);
        NSUInteger numberPage = [value integerValue] + 1;
        NSString * label = [NSString stringWithFormat:@"< %d/%d >", numberPage, [self.viewModel.dataModel.numberOfQuestions integerValue]];
        return label;
    }];
    
    RAC(self.timeLabel, text) = [RACObserve(self, viewModel.remainingTime) map:^id(id value) {
        long minutes = floor([value integerValue]/60);
        long seconds = [value integerValue] - minutes*60;
        NSString * label = [NSString stringWithFormat:@"%lu:%02lu", minutes, seconds];
        return label;
    }];
    
    RACTuple * tuple = [RACTuple tupleWithObjects:self.viewModel.currentExercise, @(ExerciseChangeDirectionNull), nil];
    [self handleChange:tuple];
    [self rac_liftSelector:@selector(handleChange:) withSignals:self.viewModel.changeCurrentExercise, nil];
}

@end
