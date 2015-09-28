//
//  RadioButtonsController.m
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RadioButtonsController.h"
@interface RadioButtonsController ()

//Reference needed for later correction
@property (nonatomic, strong) RadioButtonViewModel * currentlyClikedButton;
@property (nonatomic, strong) NSNumber * correctButtonID;

@end

@implementation RadioButtonsController
- (id)init {
    self = [super init];
    if (self) {
        self.currentlySelectedButtonID = @0;
        self.correctButtonID = @0;
        self.currentlyClikedButton = nil;
    }
    return self;
}

- (void)addNewRadioButton:(RadioButtonViewModel *)radioButton {
    
    if (radioButton.isTrue) {
        self.correctButtonID = radioButton.materialID;
    }
    
    RACChannelTerminal * controllerTerminal = RACChannelTo(self, currentlySelectedButtonID);
    RACChannelTerminal * buttonTerminal = RACChannelTo(radioButton, selectedID);
     @weakify(self);
    [[controllerTerminal doNext:^(id x) {
        @strongify(self);
        if ([x isEqualToNumber:radioButton.materialID]) {
            self.currentlyClikedButton = radioButton;
        }
    }]subscribe:buttonTerminal];
    
   
    [[[buttonTerminal  skip :1] doNext:^(id x) {
        @strongify(self);
        self.currentlyClikedButton = radioButton;
    }] subscribe:controllerTerminal];
}

- (void)correctionAsked{
    if(self.currentlyClikedButton) {
        if(self.currentlyClikedButton.isTrue) {
            self.currentlyClikedButton.answerState = MaterialAnswerStateIsCorrect;
        }
        else {
            self.currentlyClikedButton.answerState = MaterialAnswerStateIsNotCorrect;
        }
    }
}

- (void)restartAsked {
    if (self.currentlyClikedButton) {
        self.currentlyClikedButton.answerState = MaterialAnswerStateIsUndefined;
        self.currentlySelectedButtonID = @0;
        self.currentlyClikedButton = nil;
    }
}

- (void)solutionAsked {
    if (self.currentlyClikedButton.answerState == MaterialAnswerStateIsNotCorrect) {
        self.currentlyClikedButton.answerState = MaterialAnswerStateIsUndefined;
        self.currentlySelectedButtonID = self.correctButtonID;
    }
}

 @end
