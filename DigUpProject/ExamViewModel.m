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
        self.currentExercise = exercises[0];
        self.currentExerciseIndex = 0;
        self.numberOfExercises = exercises.count;
        self.results = [[NSMutableArray alloc] init];
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
        viewModel = [[ExamResultViewModel alloc] initWithValues:5];
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
    for (ExerciseViewModel * exerciseViewModel in self.exercises) {
        NSNumber * exerciseResult = @([exerciseViewModel correctionAskedDisplayed:NO]);
        [self.results addObject:exerciseResult];
        [exerciseViewModel.audioController releaseAudioTimer];
    }
}

- (NSNumber *)processResults {
    return @0;
}

@end
