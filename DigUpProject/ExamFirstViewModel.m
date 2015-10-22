//
//  ExamFirstViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamFirstViewModel.h"

@interface ExamFirstViewModel ()
@property (nonatomic, strong) NSMutableArray<ExerciseViewModel *> * exercises;
@property (nonatomic, strong) NSArray<SWGExercise> * exercisesModel;
@property (nonatomic, strong) NSMutableArray<RACSignal *> * exercisesFullyLoaded;
@end

@implementation ExamFirstViewModel

- (id)initWithSWGExam:(SWGExam *)dataModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        [self initialize];
        self.webController = webController;
        self.dataModel = dataModel;
        @weakify(self)
        [self.defaultApi examGetWithCompletionBlock:^(NSArray<SWGExercise> *output, NSError *error) {
            @strongify(self)
            self.exercisesModel = output;
            [self createExamFromModel];
        }];
    }
    return self;
}

- (void)initialize {
    self.examLoaded = NO;
    self.loadingState = ExamLoadingStateGoingOn;
    self.exercisesFullyLoaded = [[NSMutableArray alloc] init];
    self.exercises = [[NSMutableArray alloc] init];
    self.defaultApi = [[SWGDefaultApi alloc] init];
}


- (ExamViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    ExamViewModel * examViewModel;
    if ([segueIdentifier isEqualToString:@"startExamSegue"]) {
        examViewModel = [[ExamViewModel alloc] initWithExercises:self.exercises dataModel:self.dataModel];
    }
    return examViewModel;
}

- (void)createExamFromModel {
    if (!_exercisesModel) {
        self.loadingState = ExamLoadingStateStopped;
        return;
    }
    for (SWGExercise * exerciseModel in self.exercisesModel) {
        ExerciseViewModel * exerciseViewModel = [[ExerciseViewModel alloc] initWithSWGExercise:exerciseModel WebController:self.webController mediaUrl:self.dataModel.mediaUrl];
        [self.exercises addObject:exerciseViewModel];
        RACSignal * mediaLoaded = RACObserve(exerciseViewModel, mediasLoaded);
        [self.exercisesFullyLoaded addObject:mediaLoaded];
    }

    @weakify(self)
    RAC(self, loadingState) = [[RACSignal combineLatest:self.exercisesFullyLoaded] map:^id(RACTuple * value) {
        @strongify(self)
        NSArray * values = value.allObjects;
        BOOL done = YES;
        for (NSNumber * mediasLoaded in values) {
            if (![mediasLoaded boolValue]) {
                done = NO;
                break;
            }
        }
        if (done) {
            self.examLoaded = YES;
            return @(ExamLoadingStateStopped);
        }
        else {
            return @(ExamLoadingStateGoingOn);
        }
    }];
}

@end
