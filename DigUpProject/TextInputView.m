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

- (id) initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.position.x,
                                    self.viewModel.position.y,
                                    self.viewModel.materialWidth,
                                    self.viewModel.materialHeight);
        
        self.viewDisplayed = [[UITextField alloc] initWithFrame:frame];
        self.viewDisplayed.clearButtonMode = UITextFieldViewModeAlways;
        self.viewDisplayed.layer.borderColor = [UIColor grayColor].CGColor;
        self.viewDisplayed.layer.borderWidth = 1.0f;
        [self applyModelToView];
    }
    return self;
}

- (void) applyModelToView {
    RAC(self.viewModel, givenAnswer) = self.viewDisplayed.rac_textSignal;
}

@end
