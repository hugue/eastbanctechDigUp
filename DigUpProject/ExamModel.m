//
//  ExamModel.m
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamModel.h"

@implementation ExamModel

- (id)init {
    self = [super init];
    if (self) {
        self.allowedTime = @120;
        self.title = @"Exam";
        self.numberOfQuestions = @25;
    }
    return self;
}

@end
