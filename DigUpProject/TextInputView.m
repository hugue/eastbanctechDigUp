//
//  TextInputView.m
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TextInputView.h"

@implementation TextInputView

@dynamic viewModel;
@dynamic viewDisplayed;

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.position.x,
                                    self.viewModel.position.y,
                                    self.viewModel.materialWidth,
                                    self.viewModel.materialHeight);
        
        self.viewDisplayed = [[UITextField alloc] initWithFrame:frame];
        self.viewDisplayed.layer.borderColor = [UIColor grayColor].CGColor;
        self.viewDisplayed.layer.borderWidth = 1.0f;
        
        [self applyStyle:self.viewModel.material.Style toTextField:self.viewDisplayed];
        [self applyModelToView];
    }
    return self;
}

- (void)applyModelToView {
    RACChannelTerminal * viewTerminal = [self.viewDisplayed rac_newTextChannel];
    RACChannelTerminal * modelTerminal = RACChannelTo(self.viewModel, givenAnswer);
    
    [viewTerminal subscribe:modelTerminal];
    [modelTerminal subscribe:viewTerminal];
}


- (void)applyBorderStyleForAnswerState:(MaterialAnswerState) materialAnswerState {
    [super applyBorderStyleForAnswerState:materialAnswerState];
    if ((materialAnswerState == MaterialAnswerStateIsUndefined) || (materialAnswerState == MaterialAnswerStateIsTesting)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.layer.borderColor = [UIColor grayColor].CGColor;
            self.viewDisplayed.layer.borderWidth = 1.0f;
        });
    }
    
    if (materialAnswerState == MaterialAnswerStateIsTesting) {
        self.viewDisplayed.enabled = YES;
    }
    else {
        self.viewDisplayed.enabled = NO;
    }
}

- (void)applyStyle:(NSString *)style toTextField:(UITextField *) textField{
    if ([style isEqualToString:@"paragraph-small"]) {
        textField.textAlignment = NSTextAlignmentLeft;
        [textField setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:12]];
    }
    else if ([style isEqualToString:@"paragraph-right"]) {
        textField.textAlignment = NSTextAlignmentRight;
        [textField setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:18]];
    }
    else if ([style isEqualToString:@"paragraph-center"]) {
        textField.textAlignment = NSTextAlignmentCenter;
        [textField setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:18]];
    }
    else {
        textField.textAlignment = NSTextAlignmentLeft;
        [textField setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:18]];
    }
}
@end
