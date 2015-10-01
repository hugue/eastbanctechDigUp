//
//  WebSearcherController.m
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "WebSearcherController.h"
@interface WebSearcherController()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> * mediaBlobIdAndTaskId;
@property (nonatomic, strong) NSURLSession * controllerSession;
@property (nonatomic) NSUInteger mainTaskIdentifier;
@property (nonatomic, strong) NSMutableDictionary * downloadedMedias;
@property (nonatomic, strong) NSNumber * downloadedMediaID;

@end

@implementation WebSearcherController

- (id)init {
    self = [super init];
    if (self) {
        self.mediaBlobIdAndTaskId = [[NSMutableDictionary alloc] init];
        self.downloadedMedias = [[NSMutableDictionary alloc] init];
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.controllerSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        self.urlToReach = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&";
        self.mediaURL = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/Stream/Blob/";
        self.downloadedMediaID = @0;
    }
    return self;
}

- (void)launchSession {
    self.receivedData = nil;
    NSURL *url = [NSURL URLWithString:self.urlToReach];
    
    NSURLSessionDownloadTask * downloadTask = [self.controllerSession downloadTaskWithURL:url];
    self.mainTaskIdentifier = downloadTask.taskIdentifier;
    [downloadTask resume];

    if(!self.controllerSession) {
        NSLog(@"Can't open the connection");
    }
}

- (void)launchDownloadingMediaSession {
    
    for (NSNumber * key in self.downloadedMedias) {
        NSURL * downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.mediaURL, key]];
        NSURLSessionDownloadTask * downloadTask = [self.controllerSession downloadTaskWithURL:downloadURL];
        [self.mediaBlobIdAndTaskId setObject:key  forKey:@(downloadTask.taskIdentifier)];
        [downloadTask resume];
    }
}

- (void)registerNewViewToDownloadMedia:(MaterialViewModel *) materialViewModel forBlobId:(NSNumber *)blobID{
    if (self.downloadedMedias[blobID] == nil) {
        [self.downloadedMedias setObject:[NSNull null] forKey:blobID];
    }
    
    @weakify(self)
    [[RACObserve(self, downloadedMediaID) skip: 1] subscribeNext:^(id x) {
        @strongify(self)
        if ([x isEqualToNumber:blobID]) {
            [materialViewModel applyDataToMaterial:self.downloadedMedias[blobID]];
        }
    }];
}


#pragma mark - NSURLSession delegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData * data = [NSData dataWithContentsOfURL:location];
    if (downloadTask.taskIdentifier == self.mainTaskIdentifier) {
        self.receivedData = [data copy];
        [self.delegate webSearcherController:self didReceiveData:self.receivedData withError:nil];
    }
    else {
        NSNumber * blobID = self.mediaBlobIdAndTaskId[@(downloadTask.taskIdentifier)];
        self.downloadedMedias[blobID] = [data copy];
        self.downloadedMediaID = blobID;
    }
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
