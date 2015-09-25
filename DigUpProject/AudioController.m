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
//@property (nonatomic, strong) RACChannelTerminal * controllerTerminal;

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
    self.audioPlayers = [[NSMutableDictionary alloc] init];
    self.currentlyPlaying = nil;
    self.currentAudioTime = 0;
    self.audioDuration = 0;
    self.isPlaying = NO;
    self.currentAudioVolum = 0.5;
    
   self.updatingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(updateCurrentTime:) userInfo:nil repeats:YES];
}


- (void)addNewAudio:(AudioViewModel *)audio {
    [self.audioPlayers setObject:audio forKey:audio.materialID];
    //Channel to manage several audio files
    RACChannelTerminal * controllerTerminal = RACChannelTo(self, beingPlayedID);
    RACChannelTerminal * buttonTerminal = RACChannelTo(audio, selectedID);
    
    [[controllerTerminal doNext:^(id x) {
        if ([x isEqualToNumber:audio.materialID]) {
            [audio.audioPlayer play];
        }
        else {
            [audio.audioPlayer stop];
        }
    }] subscribe:buttonTerminal];
    
    @weakify(self)
    [[buttonTerminal doNext:^(id x) {
        @strongify(self)
        if ([x isEqualToNumber:audio.materialID]) {
            self.audioDuration = floor(audio.audioPlayer.duration);
            [audio.audioPlayer play];
            }
    }]subscribe:controllerTerminal];
  
    RAC(audio, audioPlayer.volume) = RACObserve(self, currentAudioVolum);

}

- (void)updateCurrentTime:(id)sender {
    if (self.audioPlayers[self.beingPlayedID].audioPlayer.isPlaying) {
        self.currentAudioTime = lroundf(self.audioPlayers[self.beingPlayedID].audioPlayer.currentTime);
    }
}

- (void)setTimeCurrentAudio:(long)currentAudioTime {
    [self.audioPlayers[self.beingPlayedID].audioPlayer setCurrentTime:currentAudioTime];
}

- (void)pauseCurrentAudio {
    [self.audioPlayers[self.beingPlayedID].audioPlayer pause];
}

- (void)playCurrentAudio {
    [self.audioPlayers[self.beingPlayedID].audioPlayer play];
}

@end
