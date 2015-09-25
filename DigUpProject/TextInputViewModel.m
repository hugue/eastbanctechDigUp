//
//  TextInputViewModel.m
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TextInputViewModel.h"

@implementation TextInputViewModel

- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        [self initialize];
        
    }
    return self;
}
- (void)initialize {
    self.answer = self.material.Reply;
    self.givenAnswer = @"Write Answer Here";
}

@end
