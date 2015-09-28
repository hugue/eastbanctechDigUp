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
            self.answerMode = MaterialAnswerModeIsCorrect;
        }
        else {
            self.answerMode = MaterialAnswerModeIsNotCorrect;
        }
    }
    else {
        if (self.isSelected) {
            self.answerMode = MaterialAnswerModeIsNotCorrect;
        }
    }
}

- (void)restartAsked {
    self.isSelected = NO;
    self.answerMode = MaterialAnswerModeIsUndefined;
}

- (void)solutionAsked {
    if (self.answerMode == MaterialAnswerModeIsNotCorrect) {
        self.answerMode = MaterialAnswerModeIsUndefined;
        self.isSelected = !self.isSelected;
    }
}
@end
