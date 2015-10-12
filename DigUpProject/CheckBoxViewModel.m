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
    MaterialAnswerState isCorrect = MaterialAnswerStateIsNotCorrect;

    if (self.isSelected && self.isTrue) {
        isCorrect = MaterialAnswerStateIsCorrect;
        if (displayEnabled) {
            self.displayState = MaterialDisplayStateIsCorrect;
        }
    }
    else if ((self.isSelected && !self.isTrue) || (!(self.isSelected) && self.isTrue)) {
        isCorrect = MaterialAnswerStateIsNotCorrect;
        if (displayEnabled) {
            self.displayState = MaterialDisplayStateIsNotCorrect;
        }
    }
    return isCorrect;
}



- (void)restartAsked {
    [super restartAsked];
    self.isSelected = NO;
}

- (void)solutionAsked {
    if (self.displayState == MaterialDisplayStateIsNotCorrect) {
        self.displayState = MaterialDisplayStateIsNormal;
        self.isSelected = !self.isSelected;
    }
}
@end
