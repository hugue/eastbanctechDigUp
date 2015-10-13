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

- (void)stopExam {
    for (ExerciseViewModel * exerciseViewModel in self.exercises) {
        exerciseViewModel.currentExerciseState = ExerciseCurrentStateIsStopped;
    }
}

@end
