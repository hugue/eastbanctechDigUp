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

@end

@implementation RadioButtonsController
- (id)init {
    self = [super init];
    if (self) {
        self.currentlySelectedButtonID = @0;
        self.currentlyClikedButton = nil;
    }
    return self;
}

- (void)addNewRadioButton:(RadioButtonViewModel *)radioButton {
    
    RACChannelTerminal * controllerTerminal = RACChannelTo(self, currentlySelectedButtonID);
    RACChannelTerminal * buttonTerminal = RACChannelTo(radioButton, selectedID);
    
    [controllerTerminal subscribe:buttonTerminal];
    
    @weakify(self);
    [[[buttonTerminal  skip :1] doNext:^(id x) {
        @strongify(self);
        self.currentlyClikedButton = radioButton;
    }] subscribe:controllerTerminal];
}

- (void)correctionAsked{
    if(self.currentlyClikedButton) {
        if(self.currentlyClikedButton.isTrue) {
            self.currentlyClikedButton.answerMode = isCorrect;
        }
        else {
            self.currentlyClikedButton.answerMode = isNotCorrect;
        }
    }
}

 @end
