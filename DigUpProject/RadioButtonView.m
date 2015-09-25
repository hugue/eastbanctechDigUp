//
//  RadioButtonView.m
//  DigUpProject
//
//  Created by hugues on 11/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RadioButtonView.h"

@interface RadioButtonView ()

@property (nonatomic) NSNumber * isSelected;

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
                                    //20,
                                    //20);
                                    self.viewModel.materialWidth,
                                    self.viewModel.materialHeight);
        
        self.viewDisplayed = [[UIButton alloc] initWithFrame:frame];
        [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState: UIControlStateNormal];
        
        [self.viewDisplayed addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self applyModelToView];
    }
    return self;
}

- (void)handleTap:(id)sender {
        self.isSelected = @YES;
        [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState: UIControlStateNormal];
}

- (void)applyModelToView {
    RACChannelTerminal * viewTerminal = RACChannelTo(self, isSelected);
    RACChannelTerminal * modelTerminal = RACChannelTo(self.viewModel, selectedID);

    @weakify(self)
    [[modelTerminal map:^id(id value) {
        @strongify(self)
        if ([value isEqualToNumber:self.viewModel.materialID]) {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState: UIControlStateNormal];
            return @YES;
        }
        else {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState: UIControlStateNormal];
            return @NO;
        }
    }] subscribe:viewTerminal];
    
    [[[viewTerminal filter:^BOOL(id value) {
        return [value boolValue];
    }]map:^id(id value) {
        @strongify(self)
        return self.viewModel.materialID;
    }]subscribe:modelTerminal];
    
    //Look on model to display answer state (correct/notCorrect/undefined)
    [RACObserve(self.viewModel, answerMode) subscribeNext:^(id x) {
       @strongify(self)
        if ([x integerValue] == isUndefined) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.viewDisplayed.layer.borderWidth = 0.0f;
            });
        }
        else if ([x integerValue] == isCorrect) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.viewDisplayed.layer.borderColor = [UIColor greenColor].CGColor;
                self.viewDisplayed.layer.borderWidth = 1.0f;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.viewDisplayed.layer.borderColor = [UIColor redColor].CGColor;
                self.viewDisplayed.layer.borderWidth = 1.0f;
            });
        }
    }];
}

@end
