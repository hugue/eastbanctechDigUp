//
//  TextInputViewModel.m
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TextInputViewModel.h"
@interface TextInputViewModel()

@property (nonatomic, strong) NSDictionary * answerInfo;

@end

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
    NSError * error;
    NSData * answerData = [self.material.Text dataUsingEncoding:NSUTF8StringEncoding];
    self.answerInfo = [NSJSONSerialization JSONObjectWithData:answerData options:kNilOptions error:&error];
}

- (void)correctionAsked {
    if ([self.givenAnswer isEqualToString:@""]) {
        return;
    }
    for (NSDictionary * possibleAnswer in self.answerInfo[@"answers"]) {
        BOOL isMatching = NO;
        if (![possibleAnswer[@"caseSensitive"] boolValue]) {
            isMatching = ([self.givenAnswer caseInsensitiveCompare:possibleAnswer[@"value"]] == NSOrderedSame);
        }
        else {
            isMatching = [self.givenAnswer isEqualToString:possibleAnswer[@"value"]];
        }
        if (isMatching) {
            if ([possibleAnswer[@"rang"] integerValue] == 1) {
                self.answerMode = MaterialAnswerModeIsCorrect;
            }
            else if([possibleAnswer[@"rang"] integerValue] == 2) {
                self.answerMode = MaterialAnswerModeIsAlternative;
            }
            else {
                self.answerMode = MaterialAnswerModeIsNotCorrect;
            }
            return;
        }
    }
    self.answerMode = MaterialAnswerModeIsNotCorrect;
}

- (void)solutionAsked {
    self.givenAnswer = self.answer;
    if (!(self.answerMode == MaterialAnswerModeIsCorrect)) {
        self.answerMode = MaterialAnswerModeIsUndefined;
    }
}

- (void)restartAsked {
    self.answerMode = MaterialAnswerModeIsUndefined;
    self.givenAnswer = @"";
}

@end
