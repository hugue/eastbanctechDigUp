//
//  CheckBoxViewModel.m
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CheckBoxViewModel.h"

@implementation CheckBoxViewModel

- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        self.isTrue = [self.material.Value  isEqualToString:@"true"];
        
        self.groupID = self.material.Text;
        self.isSelected = NO;
    }
    return self;
}

- (void)correctionAsked {
    if (self.isTrue) {
        if (self.isSelected) {
            self.answerState = MaterialAnswerStateIsCorrect;
        }
        else {
            self.answerState = MaterialAnswerStateIsNotCorrect;
        }
    }
    else {
        if (self.isSelected) {
            self.answerState = MaterialAnswerStateIsNotCorrect;
        }
    }
}

- (void)restartAsked {
    self.isSelected = NO;
    self.answerState = MaterialAnswerStateIsUndefined;
}

- (void)solutionAsked {
    if (self.answerState == MaterialAnswerStateIsNotCorrect) {
        self.answerState = MaterialAnswerStateIsUndefined;
        self.isSelected = !self.isSelected;
    }
}
@end
