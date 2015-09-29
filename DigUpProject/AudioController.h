//
//  AudioController.h
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "AudioViewModel.h"

@interface AudioController : NSObject

@property (nonatomic, strong) NSNumber * beingPlayedID;
@property (nonatomic, strong) AudioViewModel * currentlyPlaying;

@property (nonatomic) long currentAudioTime;
@property (nonatomic) long audioDuration;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) float currentAudioVolum;
@property (nonatomic) BOOL isNeeded;

- (id)init;
- (void)addNewAudio:(AudioViewModel *)audio;
- (void)pauseCurrentAudio;
- (void)playCurrentAudio;
- (void)stopCurrentAudio;

- (void)setTimeCurrentAudio:(long)currentAudioTime;
- (void)playPauseChangedOnView;

- (void)restartAsked;

@end
