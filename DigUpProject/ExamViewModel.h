//
//  ExamViewModel.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamModel.h"
#import "ExamResultViewModel.h"
#import "ExerciseViewModel.h"


@interface ExamViewModel : NSObject

@property (nonatomic, strong) NSArray<ExerciseViewModel *> * exercises;
@property (nonatomic, strong) ExerciseViewModel * currentExercise;
@property (nonatomic) NSUInteger currentExerciseIndex;
@property (nonatomic, strong) NSTimer * countDownTimer;
@property (nonatomic) NSUInteger remainingTime;
@property (nonatomic) NSUInteger numberOfExercises;
@property (nonatomic, strong) NSMutableArray * results;

- (id)initWithExercises:(NSArray<ExerciseViewModel *> *)exercises AllowedTime:(NSUInteger)time;
- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;

- (void)stopExam;
- (void)startExam;
- (ExerciseViewModel *)selectNextExercise;
- (ExerciseViewModel *)selectPreviousExercise;
- (void)examDone;
- (void)viewDidAppear;
- (void)viewWillDisappear;

@end
