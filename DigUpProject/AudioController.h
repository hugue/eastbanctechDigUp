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
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AudioViewModel *> * audioPlayers;
#warning change the way it works from dictionary to element
@property (nonatomic, strong) AudioViewModel * currentlyPlaying;

@property (nonatomic) long currentAudioTime;
@property (nonatomic) BOOL isPlaying;

- (id) init;
- (void) addNewAudio:(AudioViewModel *)audio;

//- (NSString *) currentFormattedTime:(float) value;

@end
