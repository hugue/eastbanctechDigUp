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
            self.displayState = MaterialDisplayStateIsCorrect;
        }
        else {
            self.displayState = MaterialDisplayStateIsNotCorrect;
        }
    }
    else {
        if (self.isSelected) {
            self.displayState = MaterialDisplayStateIsNotCorrect;
        }
    }
}

- (void)restartAsked {
    self.isSelected = NO;
}

- (void)solutionAsked {
    if (self.displayState == MaterialDisplayStateIsNotCorrect) {
        self.displayState = MaterialDisplayStateIsNormal;
        self.isSelected = !self.isSelected;
    }
}
@end
