//
//  AudioController.h
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AudioViewModel.h"

@interface AudioController : NSObject

@property (nonatomic, strong) NSNumber * beingPlayedID;

- (id) init;
- (void) addNewAudio:(AudioViewModel *)audio;

@end
