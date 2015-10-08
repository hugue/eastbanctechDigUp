//
//  AudioViewModel.h
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "MaterialViewModel.h"


@interface AudioViewModel : MaterialViewModel <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSNumber * selectedID;
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;
@property (nonatomic, strong) NSData * audioData;
@property (nonatomic, strong) NSNumber * audioLoaded;
@property (nonatomic, strong) NSNumber * blobID;
@property (nonatomic) BOOL showAudioSymbol;
@property (nonatomic) BOOL autoPlay;

- (void)audioSelectedOnView;
- (void)applyDataToMaterial:(NSData *)data;

@end
