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

- (MaterialAnswerState)correctionAskedWithDisplay:(BOOL)displayEnabled {
    MaterialAnswerState materialAnswerState;

    if (self.isSelected && self.isTrue) {
        materialAnswerState = MaterialAnswerStateIsCorrect;
        if (displayEnabled) {
            self.displayState = MaterialDisplayStateIsCorrect;
        }
    }
    else if ((self.isSelected && !self.isTrue) || (!(self.isSelected) && self.isTrue)) {
        materialAnswerState = MaterialAnswerStateIsNotCorrect;
        if (displayEnabled) {
            self.displayState = MaterialDisplayStateIsNotCorrect;
        }
    }
    else if (!self.isSelected && !self.isTrue) {
        materialAnswerState = MaterialAnswerStateIsCorrect;
        if (displayEnabled) {
            self.displayState = MaterialDisplayStateIsNormal;
        }
    }
    return materialAnswerState;
}



- (void)restartAsked {
    [super restartAsked];
    self.isSelected = NO;
}

- (void)solutionAsked {
    self.materialState = MaterialAnswerStateIsCorrect;
    if (self.isTrue) {
        self.isSelected = YES;
    }
    else {
        self.isSelected = NO;
    }
    if (self.displayState == MaterialDisplayStateIsNotCorrect) {
        self.displayState = MaterialDisplayStateIsNormal;
    }
}
@end
