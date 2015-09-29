//
//  RadioButtonViewModel.m
//  DigUpProject
//
//  Created by hugues on 11/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RadioButtonViewModel.h"

@interface RadioButtonViewModel ()

@end

@implementation RadioButtonViewModel

- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        self.isTrue = [self.material.Value  isEqualToString:@"true"];
        
        self.groupID = self.material.Text;
        self.selectedID = @0;
    }
    return self;
}

- (void)buttonSelectedOnView {
    if (![self.selectedID isEqualToNumber:self.materialID]) {
        self.selectedID = self.materialID;
    }
}

- (void)correctionAsked {
    if ([self.selectedID isEqualToNumber:self.materialID] && self.isTrue) {
        self.answerState = MaterialAnswerStateIsCorrect;
    }
    else if ([self.selectedID isEqualToNumber:self.materialID] && (!self.isTrue)) {
        self.answerState = MaterialAnswerStateIsNotCorrect;
    }
    else  {
        self.answerState = MaterialAnswerStateIsUndefined;
    }
}

- (void)solutionAsked {
    if (self.answerState == MaterialAnswerStateIsNotCorrect) {
        self.answerState = MaterialAnswerStateIsUndefined;
    }
    else if (self.isTrue && (self.answerState == MaterialAnswerStateIsUndefined)) {
        self.selectedID = self.materialID;
    }
}

- (void)restartAsked {
    self.selectedID = @0;
    self.answerState = MaterialAnswerStateIsTesting;
}

@end
