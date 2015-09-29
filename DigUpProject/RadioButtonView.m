//
//  RadioButtonView.m
//  DigUpProject
//
//  Created by hugues on 11/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RadioButtonView.h"

@interface RadioButtonView ()

- (void)handleTap:(id)sender;

@end

@implementation RadioButtonView

@dynamic viewModel;
@dynamic viewDisplayed;

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.position.x,
                                    self.viewModel.position.y,
                                    20,
                                    20);
        
        self.viewDisplayed = [[UIButton alloc] initWithFrame:frame];
        [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState: UIControlStateNormal];
        
        [self.viewDisplayed addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self applyModelToView];
    }
    return self;
}

- (void)handleTap:(id)sender {
    [self.viewModel buttonSelectedOnView];
}

- (void)applyModelToView {
    @weakify(self)
    [[RACObserve(self.viewModel, selectedID) map:^id(id value) {
        @strongify(self)
        return @([value isEqualToNumber:self.viewModel.materialID]);
    }]subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState: UIControlStateNormal];
        }
        else {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState: UIControlStateNormal];
        }
    }];
}

- (void)applyBorderStyleForAnswerState:(MaterialAnswerState) materialAnswerState {
    [super applyBorderStyleForAnswerState:materialAnswerState];
    if (materialAnswerState == MaterialAnswerStateIsTesting) {
        self.viewDisplayed.enabled = YES;
    }
    else {
        self.viewDisplayed.enabled = NO;
    }
}

@end
