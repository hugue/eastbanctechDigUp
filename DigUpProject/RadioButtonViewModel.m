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
        self.displayState = MaterialDisplayStateIsCorrect;
    }
    else if (([self.selectedID isEqualToNumber:self.materialID] && (!self.isTrue)) ||
             ((![self.selectedID isEqualToNumber:self.materialID]) && self.isTrue)) {
        self.displayState = MaterialDisplayStateIsNotCorrect;
    }
    else  {
        self.displayState = MaterialDisplayStateIsNormal;
    }
}

- (void)solutionAsked {
    if (self.displayState == MaterialDisplayStateIsNotCorrect) {
        self.displayState = MaterialDisplayStateIsNormal;
    }
    else if (self.isTrue && (self.displayState == MaterialDisplayStateIsNormal)) {
        self.selectedID = self.materialID;
    }
}

- (void)restartAsked {
    self.selectedID = @0;
}

@end
