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
            self.answerMode = isCorrect;
        }
        else {
            self.answerMode = isNotCorrect;
        }
    }
    else {
        if (self.isSelected) {
            self.answerMode = isNotCorrect;
        }
    }
}

- (void)restartAsked {
    self.isSelected = NO;
    self.answerMode = isUndefined;
}

- (void)solutionAsked {
    if (self.answerMode == isNotCorrect) {
        self.answerMode = isUndefined;
        self.isSelected = !self.isSelected;
    }
}
@end
