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
        if ([self.viewModel.material.Behavior isEqualToString:@"DropElement"]) {
            [self configureDropElement];
        }
    }
    return self;
}

- (void)addVisualToView:(UIView *)superView {
    [superView addSubview:self.viewDisplayed];
    self.viewDisplayed.layer.zPosition = self.viewModel.zPosition;
}

- (void)configureDropElement {
    RAC(self, position) = [[RACObserve(self.viewModel, position) skip:1] doNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.frame = CGRectMake(self.position.x, self.position.y, self.viewDisplayed.frame.size.width, self.viewDisplayed.frame.size.height);
        });
    }];
}

@end
