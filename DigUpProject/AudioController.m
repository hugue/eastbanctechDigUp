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
    //self.audioPlayers = [[NSMutableDictionary alloc] init];
    self.currentlyPlaying = nil;
    self.currentAudioTime = 0;
    self.audioDuration = 0;
    self.isPlaying = NO;
    self.isNeeded = NO;
    self.currentAudioVolum = 1.0;
    //self.controllerTerminal = RACChannelTo(self, beingPlayedID);
    
   self.updatingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(updateCurrentTime:) userInfo:nil repeats:YES];
}


- (void)addNewAudio:(AudioViewModel *)audio {
    self.isNeeded = YES;
    //[self.audioPlayers setObject:audio forKey:audio.materialID];
    //Channel to manage several audio files
    RACChannelTerminal * controllerTerminal = RACChannelTo(self, beingPlayedID);
    RACChannelTerminal * buttonTerminal = RACChannelTo(audio, selectedID);
    
    [controllerTerminal subscribe:buttonTerminal];
    
    @weakify(self);
    [[buttonTerminal doNext:^(id x) {
        @strongify(self);
        if ([x isEqualToNumber:audio.materialID]) {
            self.audioDuration = floor(audio.audioPlayer.duration);
            NSLog(@"Volum - %f", audio.audioPlayer.volume);
            self.currentAudioVolum = audio.audioPlayer.volume;
            [self stopCurrentAudio];
            self.currentlyPlaying = audio;
            [audio.audioPlayer play];
        }
    }]subscribe:controllerTerminal];
  
    RAC(audio, audioPlayer.volume) = [RACObserve(self, currentAudioVolum) filter:^BOOL(id value) {
        //@strongify(self)
        //NSLog(@"Current Volume - %f / Volume - %@ / audio ID - %@ / selected ID - %@ / controller ID - %@", audio.audioPlayer.volume, value, audio.materialID, audio.selectedID, self.beingPlayedID);
        return ([audio.materialID isEqualToNumber:audio.selectedID]);
    }];
    
    if (!audio.showAudioSymbol) {
        [[[RACObserve(audio, audioLoaded) filter:^BOOL(id value) {
            return [value boolValue];
        }] take:1] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"Audio Loaded");
            self.currentlyPlaying = audio;
            self.beingPlayedID = audio.materialID;
            self.audioDuration = audio.audioPlayer.duration;
            
            if (audio.autoPlay) {
                NSLog(@"Auto play audio");
                [audio.audioPlayer play];
            }
        }];
    }
}

- (void)updateCurrentTime:(id)sender {
    /*if (self.audioPlayers[self.beingPlayedID].audioPlayer.isPlaying) {
        self.currentAudioTime = lroundf(self.audioPlayers[self.beingPlayedID].audioPlayer.currentTime);
    }*/
    if (self.currentlyPlaying.audioPlayer.isPlaying) {
        self.currentAudioTime = self.currentlyPlaying.audioPlayer.currentTime;
    }
}

- (void)setTimeCurrentAudio:(long)currentAudioTime {
    //[self.audioPlayers[self.beingPlayedID].audioPlayer setCurrentTime:currentAudioTime];
    [self.currentlyPlaying.audioPlayer setCurrentTime:currentAudioTime];
}

- (void)pauseCurrentAudio {
    //[self.audioPlayers[self.beingPlayedID].audioPlayer pause];
    [self.currentlyPlaying.audioPlayer pause];
}

- (void)stopCurrentAudio {
    //[self.audioPlayers[self.beingPlayedID].audioPlayer stop];
    [self.currentlyPlaying.audioPlayer stop];
}

- (void)playCurrentAudio {
    //[self.audioPlayers[self.beingPlayedID].audioPlayer play];
    [self.currentlyPlaying.audioPlayer play];
}

@end
