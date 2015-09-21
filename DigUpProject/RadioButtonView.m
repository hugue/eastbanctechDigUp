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

- (void) handleTap:(id) sender;

@end

@implementation RadioButtonView

@dynamic viewModel;
@dynamic viewDisplayed;

- (id) initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.material.X ,
                                    self.viewModel.material.Y,
                                    20,
                                    20);
                                    //self.viewModel.material.Width,
                                    //self.viewModel.material.Height);
        
        self.viewDisplayed = [[UIButton alloc] initWithFrame:frame];
        [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState: UIControlStateNormal];
        
        [self.viewDisplayed addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self applyModelToView];
    }
    return self;
}

- (void) handleTap:(id) sender {
        self.isSelected = @YES;
        [self.viewDisplayed setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState: UIControlStateNormal];
}

- (void) applyModelToView {
    RACChannelTerminal * viewTerminal = RACChannelTo(self, isSelected);
    RACChannelTerminal * modelTerminal = RACChannelTo(self.viewModel, selectedID);

    [[modelTerminal map:^id(id value) {
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
        return self.viewModel.materialID;
    }]subscribe:modelTerminal];
}

@end
