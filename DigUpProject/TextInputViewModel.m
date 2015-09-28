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
    self.answer = self.material.Value;
    self.givenAnswer = @"Write Answer Here";
    NSError * error;
    //NSDictionary * answerInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:self.material.Text] options:kNilOptions error:&error];
}

- (void)correctionAsked {
    if ([self.givenAnswer isEqualToString:self.answer]) {
        self.answerMode = MaterialAnswerModeIsCorrect;
    }
    else {
        self.answerMode = MaterialAnswerModeIsNotCorrect;
    }
}

- (void)solutionAsked {
    
}

- (void)restartAsked {
    self.answerMode = MaterialAnswerModeIsUndefined;
    self.givenAnswer = @"";
}

@end
