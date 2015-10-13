//
//  ExamViewModel.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamModel.h"
#import "ExerciseViewModel.h"


@interface ExamViewModel : NSObject

@property (nonatomic, strong) NSArray<ExerciseViewModel *> * exercises;
@property (nonatomic, strong) NSTimer * countDownTimer;
@property (nonatomic) NSUInteger remainingTime;

- (id)initWithExercises:(NSArray<ExerciseViewModel *> *)exercises AllowedTime:(NSUInteger)time;
- (ExerciseViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;

- (void)stopExam;
- (void)startExam;
- (void)selectNextExercise;
- (void)selectPreviousExercise;
- (void)examDone;
- (void)viewDidAppear;
- (void)viewWillDisappear;

@end
