//
//  TextInputView.h
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialView.h"
#import "TextInputViewModel.h"

@interface TextInputView : MaterialView

@property (nonatomic, strong) TextInputViewModel * viewModel;
@property (nonatomic, strong) UITextField * viewDisplayed;

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel;

@end
