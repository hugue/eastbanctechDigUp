//
//  ExamViewModel.m
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamViewModel.h"
@interface ExamViewModel ()

@property (nonatomic, strong) NSTimer * examTimer;

@end

@implementation ExamViewModel

- (id)initWithExercises:(NSArray<ExerciseViewModel *> *)exercises AllowedTime:(NSUInteger)time {
    self = [super init];
    if (self) {
        self.remainingTime = time;
        self.exercises = exercises;
    }
    return self;
}

- (void)viewDidAppear {
    [self startExam];
}

- (void)viewWillDisappear {
    [self stopExam];
}

- (ExerciseViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    ExerciseViewModel * viewModel;
    if ([segueIdentifier isEqualToString:@"displayExerciseSegue"]) {
        viewModel = self.exercises[0];
        NSLog(@"Exercise to display - %@", viewModel.materialsModels);
    }
    return viewModel;
}

- (void)stopExam {
    [self.examTimer invalidate];
    for (ExerciseViewModel * exerciseViewModel in self.exercises) {
        exerciseViewModel.currentExerciseState = ExerciseCurrentStateIsStopped;
    }
}

- (void)startExam {
    [self startTimer];
    for (ExerciseViewModel * exerciseViewModel in self.exercises) {
        exerciseViewModel.currentExerciseState = ExerciseCurrentStateIsGoingOn;
    }
}

- (void)startTimer {
    self.examTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
}

- (void)updateCountDown:(NSTimer *)sender {
    self.remainingTime -=1;
    if (self.remainingTime == 0) {
        [self stopExam];
        NSLog(@"Time is Over");
    }
}

- (void)selectNextExercise {
    
}

- (void)selectPreviousExercise {
    
}

- (void)examDone {
    
}

@end
