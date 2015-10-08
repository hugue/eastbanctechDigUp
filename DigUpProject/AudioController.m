//
//  AudioController.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "AudioController.h"

@interface AudioController()

@property (nonatomic, strong) NSTimer * updatingTimer;

@end

@implementation AudioController

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
            }
    return self;
}

- (void)initialize {
    self.beingPlayedID = @0;
    self.currentlyPlaying = nil;
    self.currentAudioTime = 0;
    self.audioDuration = 0;
    self.isPlaying = NO;
    self.isNeeded = NO;
    self.currentAudioVolum = 1.0;
    
    self.updatingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(updateCurrentTime:) userInfo:nil repeats:YES];
}


- (void)addNewAudio:(AudioViewModel *)audio {
    self.isNeeded = YES;
    //Channel to manage several audio files
    RACChannelTerminal * controllerTerminal = RACChannelTo(self, beingPlayedID);
    RACChannelTerminal * buttonTerminal = RACChannelTo(audio, selectedID);
    
    [controllerTerminal subscribe:buttonTerminal];
    
    @weakify(self)
    [[buttonTerminal doNext:^(id x) {
        @strongify(self)
        if ([x isEqualToNumber:audio.materialID]) {
            [self stopCurrentAudio];
            
            self.currentlyPlaying = audio;
            self.currentAudioVolum = audio.audioPlayer.volume;
            self.audioDuration = floor(audio.audioPlayer.duration);
            [self playCurrentAudio];
        }
    }]subscribe:controllerTerminal];
  
    RAC(audio, audioPlayer.volume) = [RACObserve(self, currentAudioVolum) filter:^BOOL(id value) {
        @strongify(self)
        return ([self.currentlyPlaying isEqual:audio]);
    }];
    
    //Special code if there is only one audio and no audio symbol is required
    if (!audio.showAudioSymbol) {
        [[[RACObserve(audio, audioLoaded) filter:^BOOL(id value) {
            return [value boolValue];
        }] take:1] subscribeNext:^(id x) {
            @strongify(self)
            self.currentlyPlaying = audio;
            self.beingPlayedID = audio.materialID;
            self.audioDuration = audio.audioPlayer.duration;
            
            if (audio.autoPlay) {
                [self playCurrentAudio];
            }
        }];
    }
}

- (void)releaseAudioTimer {
    [self.updatingTimer invalidate];
    self.updatingTimer = nil;
}

- (void)updateCurrentTime:(id)sender {
    if (self.currentlyPlaying.audioPlayer.isPlaying) {
        self.currentAudioTime = self.currentlyPlaying.audioPlayer.currentTime;
    }
    else if (!self.currentlyPlaying.audioPlayer.isPlaying) {
        self.isPlaying = NO;
    }
}

- (void)setTimeCurrentAudio:(long)currentAudioTime {
    [self.currentlyPlaying.audioPlayer setCurrentTime:currentAudioTime];
}

- (void)pauseCurrentAudio {
    [self.currentlyPlaying.audioPlayer pause];
    self.isPlaying = NO;
}

- (void)stopCurrentAudio {
    [self.currentlyPlaying.audioPlayer stop];
    self.isPlaying = NO;
}

- (void)playCurrentAudio {
    [self.currentlyPlaying.audioPlayer play];
    self.isPlaying = YES;
}

- (void)playPauseChangedOnView {
    if (self.isPlaying) {
        [self pauseCurrentAudio];
    }
    else {
        [self playCurrentAudio];
    }
}

- (void)restartAsked {
    self.currentlyPlaying = nil;
    self.audioDuration = 0;
    self.currentAudioVolum = 1.0;
    self.currentAudioTime = 0;
    self.isPlaying = NO;
    self.beingPlayedID = @0;
}

@end
