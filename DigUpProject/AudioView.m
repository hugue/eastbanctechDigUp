//
//  AudioView.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "AudioView.h"
@interface AudioView ()

@property (nonatomic, strong) NSNumber * isSelected;

@end

@implementation AudioView
@dynamic viewDisplayed;
@dynamic viewModel;


- (id) initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.material.X ,
                                    self.viewModel.material.Y,
                                    self.viewModel.material.Width,
                                    self.viewModel.material.Height);
        
        self.viewDisplayed = [[UIButton alloc] initWithFrame:frame];
        self.isSelected = @NO;
        [self.viewDisplayed setImage:[UIImage imageNamed:@"Audio-Unselected"] forState: UIControlStateNormal];
        
        //Initializing the real button
        [self.viewDisplayed addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self applyModelToView];
    }
    return self;
}

- (void) handleTap:(id) sender {
    [self.viewDisplayed setImage:[UIImage imageNamed:@"Audio-Selected"] forState: UIControlStateNormal];
 //[self.viewModel handleTap];
    self.isSelected = @YES;
    
}

- (void) applyModelToView {
    RACSignal * audioLoadedSignal = RACObserve(self.viewModel, audioLoaded);
    [[audioLoadedSignal filter:^BOOL(id value) {
        return [value boolValue];
    }]subscribeNext:^(id x) {
        NSLog(@"File downloaded");
    }];
    RACChannelTerminal * viewTerminal = RACChannelTo(self, isSelected);
    RACChannelTerminal * modelTerminal = RACChannelTo(self.viewModel, selectedID);
    
    [[modelTerminal map:^id(id value) {
        if ([value isEqualToNumber:self.viewModel.materialID]) {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"Audio-Selected"] forState: UIControlStateNormal];
            return @YES;
        }
        else {
            [self.viewDisplayed setImage:[UIImage imageNamed:@"Audio-Unselected"] forState: UIControlStateNormal];
            return @NO;
        }
    }]subscribe:viewTerminal];
    
    [[[viewTerminal filter:^BOOL(id value) {
        return [value boolValue];
    }]map:^id(id value) {
            return self.viewModel.materialID;
    }]subscribe:modelTerminal];
}


@end
