//
//  AudioViewModel.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "AudioViewModel.h"

@implementation AudioViewModel

- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.selectedID = @0;
    self.audioLoaded = @NO;
    self.blobID = self.material.BlobId;
    self.audioData = nil;
    self.showAudioSymbol = [self.material.Show boolValue];
    self.autoPlay = [self.material.Autoplay boolValue];
}

- (void)audioSelectedOnView {
    if (![self.selectedID isEqualToNumber:self.materialID]) {
        self.selectedID = self.materialID;
    }    
}

- (void)applyDataToMaterial:(NSData *)data {
    self.audioData = [data copy];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData error:nil];
    self.audioPlayer.delegate = self;
    self.audioLoaded = @YES;
}

- (void)solutionAsked {
    
}

- (void)correctionAsked {
    self.answerState = MaterialAnswerStateIsUndefined;
}

- (void)restartAsked {
    self.audioPlayer.currentTime = 0;
    self.audioPlayer.volume = 1.0;
    self.selectedID = @0;
    self.answerState = MaterialAnswerStateIsTesting;
}

@end
