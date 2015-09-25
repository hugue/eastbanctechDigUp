//
//  AudioViewModel.h
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MaterialViewModel.h"


@interface AudioViewModel : MaterialViewModel <NSURLSessionDelegate, NSURLSessionDownloadDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSNumber * selectedID;
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;
@property (nonatomic, strong) NSData * audioData;
@property (nonatomic, strong) NSNumber * audioLoaded;
@property (nonatomic, strong) NSString * audioURL;
@property (nonatomic, strong) NSNumber * blobID;

- (id)initWithModel:(MaterialModel *)materialModel;
- (void)handleTap;

@end
