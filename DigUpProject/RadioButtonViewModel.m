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
/*
- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        self.isTrue = [self.material.Value  isEqualToString:@"true"];
        
        self.groupID = self.material.Text;
        self.selectedID = @0;
    }
    return self;
}
*/
- (id)initWithSWGMaterial:(SWGMaterial *)materialModel {
    self = [super initWithSWGMaterial:materialModel];
    
    if (self) {
        self.isTrue = [self.material.value  isEqualToString:@"true"];
        
        self.groupID = self.material.text;
        self.selectedID = @0;
    }
    return self;
}

- (void)buttonSelectedOnView {
    if (![self.selectedID isEqualToNumber:self.materialID]) {
        self.selectedID = self.materialID;
    }
}

- (MaterialAnswerState)correctionAskedWithDisplay:(BOOL)displayEnabled {
    MaterialAnswerState materialAnswerState;
    BOOL isSelected = [self.selectedID isEqualToNumber:self.materialID];
    
    if (isSelected && self.isTrue) {
        materialAnswerState = MaterialAnswerStateIsCorrect;
        if (displayEnabled) {
                self.displayState = MaterialDisplayStateIsCorrect;
        }
    }
    else if ((isSelected && !self.isTrue) || (!isSelected && self.isTrue)) {
        materialAnswerState = MaterialAnswerStateIsNotCorrect;
        if (displayEnabled) {
            self.displayState = MaterialDisplayStateIsNotCorrect;
        }
    }
    else if (!isSelected && !self.isTrue) {
        materialAnswerState = MaterialAnswerStateIsCorrect;
        if (displayEnabled) {
            self.displayState = MaterialDisplayStateIsNormal;
        }
    }
    return materialAnswerState;
}

- (void)solutionAsked {
    if (self.isTrue) {
        self.selectedID = self.materialID;
    }
    if (self.displayState == MaterialDisplayStateIsNotCorrect) {
        self.displayState = MaterialDisplayStateIsNormal;
    }
}

- (void)restartAsked {
    [super restartAsked];
    self.selectedID = @0;
}

@end
