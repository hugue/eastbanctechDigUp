//
//  CheckBoxView.m
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CheckBoxView.h"

@interface CheckBoxView ()

@property (nonatomic) BOOL isClicked;

- (void) handleTap:(id) sender;

@end


@implementation CheckBoxView
@dynamic viewModel;
@dynamic viewDisplayed;

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.position.x ,
                                    self.viewModel.position.y,
                                    20,
                                    20);

        self.isClicked = NO;
        self.viewDisplayed = [[UIButton alloc] initWithFrame:frame];
        [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_empty"] forState: UIControlStateNormal];
        
        [self.viewDisplayed addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self applyModelToView];
    }
    return self;
}

- (void)handleTap:(id)sender {
    self.isClicked = !self.isClicked;
}


- (void)applyModelToView {
    
    RACChannelTerminal * viewTerminal = RACChannelTo(self, isClicked);
    RACChannelTerminal * modelTerminal = RACChannelTo(self.viewModel, isSelected);
    
    @weakify(self)
    [[modelTerminal doNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_full"] forState: UIControlStateNormal];
        }
        else {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_empty"] forState: UIControlStateNormal];
        }
    }] subscribe:viewTerminal];
    
    [[viewTerminal doNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_full"] forState: UIControlStateNormal];
        }
        else {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_empty"] forState: UIControlStateNormal];
        }
    }]subscribe:modelTerminal];
}


@end
