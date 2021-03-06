//
//  MaterialView.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialView.h"

@implementation MaterialView

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel {
    self = [super init];
    if (self) {
        self.viewModel = materialViewModel;
        [self applyBaseModelToView];
    }
    return self;
}

- (void)addVisualToView:(UIView *)superView {
        [superView addSubview:self.viewDisplayed];
        self.viewDisplayed.layer.zPosition = self.viewModel.zPosition;
    //self.shadowDisplayed.layer.zPosition = self.viewModel.zPosition;
}

- (void)configureDropElement {
    @weakify(self)
    RAC(self, position) = [[RACObserve(self.viewModel, position) skip:1] doNext:^(id x) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.frame = CGRectMake(self.position.x, self.position.y, self.viewDisplayed.frame.size.width, self.viewDisplayed.frame.size.height);
            //self.shadowDisplayed.frame = CGRectMake(self.position.x, self.position.y, self.viewDisplayed.frame.size.width, self.viewDisplayed.frame.size.height);
        });
    }];
}

- (void)applyBorderStyleForAnswerState:(MaterialDisplayState) materialDispalyState {
    if (materialDispalyState == MaterialDisplayStateIsNormal) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.layer.borderWidth = 0.0f;
        });
    }
    else if (materialDispalyState == MaterialDisplayStateIsCorrect) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.layer.borderColor = [UIColor greenColor].CGColor;
            self.viewDisplayed.layer.borderWidth = 1.0f;
        });
    }
    else if (materialDispalyState == MaterialDisplayStateIsAlternative) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.layer.borderColor = [UIColor orangeColor].CGColor;
            self.viewDisplayed.layer.borderWidth = 1.0f;
        });
    }
    else {
       dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.layer.borderColor = [UIColor redColor].CGColor;
            self.viewDisplayed.layer.borderWidth = 1.0f;
        });
    }
}

- (void)applyBaseModelToView {
    if ([self.viewModel.material.behavior isEqualToString:@"DropElement"]) {
        [self configureDropElement];
    }    
    @weakify(self)
    //Look on model to display answer state (correct/notCorrect/undefined/alternative)
    [RACObserve(self.viewModel, displayState) subscribeNext:^(id x) {
        @strongify(self)
        [self applyBorderStyleForAnswerState:[x integerValue]];
    }];
}

@end
