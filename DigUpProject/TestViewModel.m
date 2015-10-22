//
//  TestViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TestViewModel.h"
@interface TestViewModel()

@end

@implementation TestViewModel

- (id)initWithSWGTest:(SWGTest *)dataModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        [self initialize];
        self.webController = webController;
        self.dataModel = dataModel;
        @weakify(self)
        [self.defaultApi exerciseExerciseNameGetWithCompletionBlock:self.dataModel.url completionHandler:^(SWGExercise *output, NSError *error) {
            @strongify(self)
            self.exerciseModel = output;
            if (!_exerciseModel) {
                self.loadingState = TestLoadingStateStopped;
            }
            else {
                self.exerciseLoaded = YES;
            }
        }];
    }
    return self;
}

- (void)initialize {
    self.exerciseLoaded = NO;
    self.defaultApi = [[SWGDefaultApi alloc] init];
    self.loadingState = TestLoadingStateGoingOn;
}

- (ExerciseViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"displayExerciseSegue"]) {
        self.exerciseViewModel =[[ExerciseViewModel alloc] initWithSWGExercise:self.exerciseModel WebController:self.webController mediaUrl:self.dataModel.mediaUrl];
        @weakify(self)
        [RACObserve(self.exerciseViewModel, mediasLoaded) subscribeNext:^(id x) {
            @strongify(self)
            if ([x boolValue]) {
                self.loadingState = TestLoadingStateStopped;
                self.exerciseViewModel.currentExerciseState = ExerciseCurrentStateIsGoingOn;
            }
        }];
        return self.exerciseViewModel;
    }
    return nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"displayExerciseSegue"]) {
        return self.exerciseLoaded;
    }
    return NO;
}

#pragma - mark Correction Methods

- (void)correctionAsked {
    if (self.exerciseViewModel.currentExerciseState == ExerciseCurrentStateIsGoingOn) {
    [self.exerciseViewModel correctionAskedDisplayed:YES];
    }
}

- (void)solutionAsked {
    if (self.exerciseViewModel.currentExerciseState == ExerciseCurrentStateIsGoingOn) {
        [self.exerciseViewModel solutionAsked];
    }
}

- (void)restartAsked {
    if (self.exerciseViewModel.currentExerciseState == ExerciseCurrentStateIsGoingOn) {
        [self.exerciseViewModel restartExerciseAsked];
    }
}

- (void)viewWillAppear {
}

@end
