//
//  CheckBoxView.h
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialView.h"
#import "CheckBoxViewModel.h"

@interface CheckBoxView : MaterialView

@property (nonatomic, strong) CheckBoxViewModel * viewModel;
@property (nonatomic, strong) UIButton * viewDisplayed;

- (void) applyModelToView;

@end
