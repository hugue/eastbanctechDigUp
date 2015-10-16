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
        self.currentExercise = self.exercises[0];
        self.changeCurrentExercise = [[RACSubject alloc] init];
        [self.changeCurrentExercise sendNext:[RACTuple tupleWithObjects:self.currentExercise,@(ExerciseChangeDirectionNull), nil]];
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
        viewModel = self.currentExercise;
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

- (void)selectNextExercise {
    
    if (self.currentExerciseIndex < (self.exercises.count - 1)) {
        self.currentExerciseIndex += 1;
    }
    else {
        self.currentExerciseIndex = 0;
    }
    self.currentExercise = self.exercises[self.currentExerciseIndex];
    RACTuple * change = [RACTuple tupleWithObjects:self.currentExercise, @(ExerciseChangeDirectionLeft), nil];
    [self.changeCurrentExercise sendNext:change];
}

- (void)selectPreviousExercise {
    if (self.currentExerciseIndex > 0) {
        self.currentExerciseIndex -= 1;
    }
    else {
        self.currentExerciseIndex = (self.exercises.count - 1);
    }
    self.currentExercise = self.exercises[self.currentExerciseIndex];
    RACTuple * change = [RACTuple tupleWithObjects:self.currentExercise, @(ExerciseChangeDirectionRight), nil];
    [self.changeCurrentExercise sendNext:change];
}

- (void)examDone {
    [self stopExam];
    int score = 0;
    for (ExerciseViewModel * exerciseViewModel in self.exercises) {
        if ([exerciseViewModel correctionAskedDisplayed:NO]) {
            score = score + 1;
        }
        [exerciseViewModel.audioController releaseAudioTimer];
        [exerciseViewModel restartExerciseAsked];
    }
    float result = 100 * ((float)score/[self.dataModel.numberOfQuestions integerValue]);
    self.dataModel.currentScore = [NSNumber numberWithFloat:result];
}

@end
