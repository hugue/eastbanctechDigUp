//
//  CheckBoxView.m
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CheckBoxView.h"

@interface CheckBoxView ()

@property (nonatomic) BOOL isSelected;

- (void) handleTap:(id) sender;

@end


@implementation CheckBoxView
@dynamic viewModel;
@dynamic viewDisplayed;

- (id) initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.position.x ,
                                    self.viewModel.position.y,
                                    20,
                                    20);
        //self.viewModel.material.Width,
        //self.viewModel.material.Height);
        self.isSelected = NO;
        self.viewDisplayed = [[UIButton alloc] initWithFrame:frame];
        [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_empty"] forState: UIControlStateNormal];
        
        [self.viewDisplayed addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self applyModelToView];
    }
    return self;
}

- (void) handleTap:(id) sender {
    if (self.isSelected) {
        self.isSelected = NO;
        [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_empty"] forState: UIControlStateNormal];
    }
    else{
        self.isSelected = YES;
        [self.viewDisplayed setImage:[UIImage imageNamed:@"checkbox_full"] forState: UIControlStateNormal];
    }
}


- (void) applyModelToView {
    RACSignal * checkSignal = RACObserve(self, isSelected);
    RAC(self.viewModel, isClicked) = checkSignal;
}


@end
