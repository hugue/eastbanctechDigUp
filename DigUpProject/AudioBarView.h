//
//  AudioBarView.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AudioController.h"

@interface AudioBarView : NSObject

@property (nonatomic, strong) AudioController * viewModel;
@property (nonatomic, strong) UIView * controlAudioBar;
@property (nonatomic, strong) UIView * viewDisplayed;
@property (nonatomic) CGPoint position;

- (id)initWithModel:(AudioController *)audioController atPosition:(CGPoint)position andWidth:(float)width;

@end
