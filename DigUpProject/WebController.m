//
//  WebController.m
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "WebController.h"

@interface WebController()

@property (nonatomic, strong) NSURLSession * globalSession;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id> * taskClients;

@end

@implementation WebController

- (id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.globalSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        self.taskClients = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addTaskForObject:(id<DataControllerProtocol>)object toURL:(NSString *)url {
    NSURL * downloadURL = [NSURL URLWithString:url];
    NSURLSessionDownloadTask * downloadTask = [self.globalSession downloadTaskWithURL:downloadURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData * data = [NSData dataWithContentsOfURL:location];
        [object didReceiveData:data withError:nil];
    }];
    [downloadTask resume];

    
}


#pragma mark - NSURLSession delegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {}

@end
