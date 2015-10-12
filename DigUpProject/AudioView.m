//
//  AudioView.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "AudioView.h"
@interface AudioView ()
@property (nonatomic, weak) UIActivityIndicatorView  * downloadingIndicator;
@end

@implementation AudioView

@dynamic viewDisplayed;
@dynamic viewModel;


- (id)initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        if (self.viewModel.showAudioSymbol) {
            CGRect  frame =  CGRectMake(self.viewModel.position.x ,
                                        self.viewModel.position.y,
                                        self.viewModel.materialWidth,
                                        self.viewModel.materialHeight);
        
            self.viewDisplayed = [[UIButton alloc] initWithFrame:frame];
            [self.viewDisplayed setImage:[UIImage imageNamed:@"Audio-Unselected"] forState: UIControlStateNormal];
            self.viewDisplayed.enabled = NO;
            //Initializing the real button
            [self.viewDisplayed addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
            [self applyModelToView];
        }
    }
    return self;
}

- (void)handleTap:(id)sender {
    [self.viewModel audioSelectedOnView];
}

- (void)applyModelToView {
    @weakify(self)
    [[RACObserve(self.viewModel, selectedID) map:^id(id value) {
        @strongify(self)
        return @([value isEqualToNumber:self.viewModel.materialID]);
    }]subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"Audio-Selected"] forState: UIControlStateNormal];
        }
        else {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"Audio-Unselected"] forState: UIControlStateNormal];
        }
    }];

}

@end
