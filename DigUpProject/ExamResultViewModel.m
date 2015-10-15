//
//  ExamResultViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamResultViewModel.h"

@implementation ExamResultViewModel

- (id)initWithDataModel:(ExamModel *)dataModel {
    self = [super init];
    if (self) {
        self.dataModel = dataModel;
        BOOL success = ([self.dataModel.currentScore doubleValue] >= [self.dataModel.requiredScore doubleValue]);
        self.text = [self createTextFor:success];
    }
    return self;
}

- (NSString *)createTextFor:(BOOL)success  {
    NSString * text;
    if (success) {
        text = [NSString stringWithFormat:@"Congratulations ! You passed the test with %@%% of good answers. Cick \"OK\" to go back the exam presentation screen.", self.dataModel.currentScore];
    }
    else {
        text = [NSString stringWithFormat:@"Unfortunately you got only %@%% of good answers instead of the %@ required to pass this exam. Read the document again and then come back to pass the exam. Click on \"OK\" to go back to the exam presentation screen", self.dataModel.currentScore, self.dataModel.requiredScore];
    }
    return text;
}

@end
