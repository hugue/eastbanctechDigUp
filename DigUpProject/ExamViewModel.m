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

- (id)initWithExercises:(NSArray<ExerciseViewModel *> *)exercises dataModel:(ExamModel *)dataModel {
    self = [super init];
    if (self) {
        self.remainingTime = [dataModel.allowedTime integerValue];
        self.dataModel = dataModel;
        self.exercises = exercises;
        self.currentExerciseIndex = 0;
    }
    return self;
}

- (void)viewDidAppear {
    [self startExam];
}

- (void)viewWillDisappear {
    [self stopExam];
}

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel;
    if ([segueIdentifier isEqualToString:@"displayExerciseSegue"]) {
        viewModel = self.exercises[0];
    }
    else if ([segueIdentifier isEqualToString:@"examResultSegue"]) {
        viewModel = [[ExamResultViewModel alloc] initWithDataModel:self.dataModel];
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
    }
}

- (ExerciseViewModel *)selectNextExercise {
    if (self.currentExerciseIndex < (self.exercises.count - 1)) {
        self.currentExerciseIndex += 1;
    }
    else {
        self.currentExerciseIndex = 0;
    }
    return self.exercises[self.currentExerciseIndex];
}

- (ExerciseViewModel *)selectPreviousExercise {
    if (self.currentExerciseIndex > 0) {
        self.currentExerciseIndex -= 1;
    }
    else {
        self.currentExerciseIndex = (self.exercises.count - 1);
    }
    return self.exercises[self.currentExerciseIndex];
}

- (void)examDone {
    [self stopExam];
    int score = 0;
    for (ExerciseViewModel * exerciseViewModel in self.exercises) {
        if ([exerciseViewModel correctionAskedDisplayed:NO]) {
            score = score + 1;
        }
        [exerciseViewModel.audioController releaseAudioTimer];
    }
    float result = 100 * ((float)score/[self.dataModel.numberOfQuestions integerValue]);
    self.dataModel.currentScore = [NSNumber numberWithFloat:result];
}

@end
