//
//  ImageViewModel.m
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ImageViewModel.h"

@implementation ImageViewModel


- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.imageLoaded = @NO;
    self.BlobID = self.material.BlobId;
    self.imageData = nil;
    self.imageURL = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/Stream/Blob/";
    
    [self downLoadImageWithBlobId:self.BlobID];
}

- (void)downLoadImageWithBlobId:(NSNumber *)imageBlobId {
    NSURL * downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.imageURL, imageBlobId]];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithURL:downloadURL];
    
    [downloadTask resume];
    if(!session) {
        NSLog(@"Can't open the connection");
    }
}

#pragma mark - NSURLSession delegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData * data = [NSData dataWithContentsOfURL:location];
    self.imageData = [data copy];
    self.imageLoaded = @YES;
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
