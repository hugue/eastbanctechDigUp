//
//  RadioButtonsController.m
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RadioButtonsController.h"

@implementation RadioButtonsController
- (id)init {
    self = [super init];
    if (self) {
        self.currentlySelectedButtonID = @0;
    }
    return self;
}

- (void)addNewRadioButton:(RadioButtonViewModel *)radioButton {
    
    RACChannelTerminal * controllerTerminal = RACChannelTo(self, currentlySelectedButtonID);
    RACChannelTerminal * buttonTerminal = RACChannelTo(radioButton, selectedID);
    
    [controllerTerminal subscribe:buttonTerminal];
    [buttonTerminal subscribe:controllerTerminal];
}

 @end
