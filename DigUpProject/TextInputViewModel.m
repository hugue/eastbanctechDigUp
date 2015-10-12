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
    if (self.material.Text) {
        NSData * answerData = [self.material.Text dataUsingEncoding:NSUTF8StringEncoding];
        self.answerInfo = [NSJSONSerialization JSONObjectWithData:answerData options:kNilOptions error:&error];
    }
}

- (MaterialAnswerState)correctionAskedWithDisplay:(BOOL)displayEnabled {
    MaterialAnswerState isCorrect = MaterialAnswerStateIsNotCorrect;
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
                isCorrect = MaterialAnswerStateIsCorrect;
                if (displayEnabled) {
                    self.displayState = MaterialDisplayStateIsCorrect;
                }
            }
            else if([possibleAnswer[@"rang"] integerValue] == 2) {
                isCorrect = MaterialAnswerStateIsAlternative;
                if (displayEnabled) {
                    self.displayState = MaterialDisplayStateIsAlternative;
                }
            }
            else {
                isCorrect = MaterialAnswerStateIsNotCorrect;
                if (displayEnabled) {
                    self.displayState = MaterialDisplayStateIsNotCorrect;
                }
            }
            return isCorrect;
        }
    }
    if (displayEnabled) {
        self.displayState = MaterialDisplayStateIsNotCorrect;
    }
    return isCorrect;
}

- (void)solutionAsked {
    self.givenAnswer = self.answer;
    if (!(self.displayState == MaterialDisplayStateIsCorrect)) {
        self.displayState = MaterialDisplayStateIsNormal;
    }
}

- (void)restartAsked {
    [super restartAsked];
    self.givenAnswer = @"";
}

@end
