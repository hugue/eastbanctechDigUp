//
//  RadioButtonView.h
//  DigUpProject
//
//  Created by hugues on 11/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialView.h"
#import "RadioButtonViewModel.h"

@interface RadioButtonView : MaterialView

@property (nonatomic, strong) RadioButtonViewModel * viewModel;
@property (nonatomic, strong) UIButton * viewDisplayed;

- (void)applyModelToView;
- (void)applyBorderStyleForAnswerState:(MaterialAnswerState)materialAnswerState;

@end
