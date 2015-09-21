//
//  CheckBoxViewModel.m
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CheckBoxViewModel.h"

@implementation CheckBoxViewModel

- (id) initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        self.isTrue = [self.material.Value  isEqualToString:@"true"];
        
        self.groupID = self.material.Text;
        self.isClicked = @NO;
    }
    return self;
}

- (void) viewChanged:(NSNumber *)newState {
    if ([newState isEqualToNumber:@(YES)]) {
    }
}

@end
