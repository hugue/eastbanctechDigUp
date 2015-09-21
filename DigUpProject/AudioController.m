//
//  AudioController.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "AudioController.h"

@implementation AudioController

- (id) init {
    self = [super init];
    if (self) {
        self.beingPlayedID = @0;
        self.audioPlayers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addNewAudio:(AudioViewModel *)audio {
    [self.audioPlayers setObject:audio forKey:audio.materialID];
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
    
    [[buttonTerminal doNext:^(id x) {
        if ([x isEqualToNumber:audio.materialID]) {
            [audio.audioPlayer play];
        }
    }]subscribe:controllerTerminal];
}

@end
