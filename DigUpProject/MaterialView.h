//
//  MaterialView.h
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface MaterialView : NSObject

- (id) initWithViewModel:(MaterialViewModel *) materialViewModel;

@property (nonatomic, strong) MaterialViewModel * viewModel;
@property (nonatomic, strong) UIView * viewDisplayed;
@property (nonatomic, strong) UIView * shadowDisplayed;
@property (nonatomic) CGPoint position;

- (void)addVisualToView:(UIView *)superView;
- (void)configureDropElement;
- (void)applyBorderStyleForAnswerMode:(MaterialAnswerMode) materialAnswerMode;
@end
