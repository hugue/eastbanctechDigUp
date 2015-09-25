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
        //self.isClicked = @NO;
        self.selectedID = @0;
    }
    return self;
}

- (void)viewChanged:(NSNumber *)newState {
    if ([newState isEqualToNumber:@(YES)]) {
        self.selectedID = self.materialID;
    }
}
@end
