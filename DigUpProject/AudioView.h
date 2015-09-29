//
//  AudioView.h
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialView.h"
#import "AudioViewModel.h"

@interface AudioView : MaterialView

@property (nonatomic, strong) UIButton * viewDisplayed;
@property (nonatomic, strong) AudioViewModel * viewModel;

- (void)applyBorderStyleForAnswerState:(MaterialAnswerState)materialAnswerState;

@end
