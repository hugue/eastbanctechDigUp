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
    self.audioURL = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/Stream/Blob/";
    self.showAudioSymbol = [self.material.Show boolValue];
    self.autoPlay = [self.material.Autoplay boolValue];
    
    [self downLoadAudioWithBlobId:self.blobID];
}

- (void)handleTap {
    self.selectedID = self.materialID;
}

- (void)downLoadAudioWithBlobId:(NSNumber *)audioBlobId {
    NSURL * downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.audioURL, audioBlobId]];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithURL:downloadURL];
    
    [downloadTask resume];
    if(!session) {
        NSLog(@"Can't open the connection");
    }
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

#pragma mark - NSURLSession delegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData * data = [NSData dataWithContentsOfURL:location];
    self.audioData = [data copy];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData error:nil];
    self.audioPlayer.delegate = self;
    self.audioLoaded = @YES;

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

@end
