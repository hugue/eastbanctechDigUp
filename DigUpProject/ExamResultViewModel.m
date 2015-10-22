//
//  ExamResultViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamResultViewModel.h"

@implementation ExamResultViewModel

- (id)initWithSWGExam:(SWGExam *)dataModel {
    self = [super init];
    if (self) {
        self.dataModel = dataModel;
        BOOL result = ([self.dataModel.lastScore doubleValue] >= [self.dataModel.requiredScore doubleValue]);
        self.text = [self createTextFor:result];
    }
    return self;
}

- (NSString *)createTextFor:(BOOL)result  {
    NSString * text;
    if (result) {
        text = [NSString stringWithFormat:@"Congratulations ! You passed the test with %@%% of good answers. Cick \"OK\" to go back the exam presentation screen.", self.dataModel.lastScore];
    }
    else {
        text = [NSString stringWithFormat:@"Unfortunately you got only %@%% of good answers instead of the %@ required to pass this exam. Read the document again and then come back to pass the exam. Click on \"OK\" to go back to the exam presentation screen", self.dataModel.lastScore, self.dataModel.requiredScore];
    }
    return text;
}

@end
