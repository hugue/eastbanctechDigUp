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

@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.text = @"0:00";
    [self.navigationItem setTitleView:self.timeLabel];
    
    //Swipe gesture recognizers
    self.previousSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPrevious:)];
    self.nextSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNext:)];
    self.nextSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.previousSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.previousSwipeRecognizer.numberOfTouchesRequired = 1;
    self.nextSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.previousSwipeRecognizer];
    [self.view addGestureRecognizer:self.nextSwipeRecognizer];

    [self applyModelToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.identifier isEqualToString:@"displayExerciseSegue"]) {
        ExerciseViewController * viewController = [segue destinationViewController];
        [viewController initialize];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
        self.exerciseViewController = viewController;
    }
    else if ([segue.identifier isEqualToString:@"examResultSegue"]) {
        ExamResultViewController * viewController = [segue destinationViewController];
        viewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
    }
}

- (IBAction)showNext:(id)sender {
    ExerciseViewModel * exerciseViewModel = [self.viewModel selectNextExercise];
    
    CATransition * applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:1];
    [applicationLoadViewIn setType:kCATransitionPush];
    [applicationLoadViewIn setSubtype:kCATransitionFromRight];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.exerciseView.layer addAnimation:applicationLoadViewIn forKey:kCATransitionPush];
    
    [self.exerciseViewController removeViewModel:nil];
    [self.exerciseViewController setViewModel:exerciseViewModel];

}

- (IBAction)showPrevious:(id)sender {
    ExerciseViewModel * exerciseViewModel = [self.viewModel selectPreviousExercise];
    
    CATransition * applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:1];
    [applicationLoadViewIn setType:kCATransitionPush];
    [applicationLoadViewIn setSubtype:kCATransitionFromLeft];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.exerciseView.layer addAnimation:applicationLoadViewIn forKey:kCATransitionPush];

    [self.exerciseViewController removeViewModel:nil];
    [self.exerciseViewController setViewModel:exerciseViewModel];

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
    RAC (self.pageLabel, text) = [RACObserve(self.viewModel, currentExerciseIndex) map:^id(id value) {
        @strongify(self);
        NSUInteger numberPage = [value integerValue] + 1;
        NSString * label = [NSString stringWithFormat:@"< %d/%d >",numberPage, self.viewModel.numberOfExercises];
        return label;
    }];
    
    RAC(self.timeLabel, text) = [RACObserve(self.viewModel, remainingTime) map:^id(id value) {
        long minutes = floor([value integerValue]/60);
        long seconds = [value integerValue] - minutes*60;
        NSString * label = [NSString stringWithFormat:@"%lu:%02lu", minutes, seconds];
        return label;
    }];
}
@end
