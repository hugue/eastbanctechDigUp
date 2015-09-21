//
//  WebSearcherController.m
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "WebSearcherController.h"

@implementation WebSearcherController

- (id) init {
    self = [super init];
    if (self) {
        self.urlToReach = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&";
    }
    return self;
}

- (void) launchSession {
    self.receivedData = nil;
    NSURL *url = [NSURL URLWithString:self.urlToReach];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithURL:url];
    [downloadTask resume];
    if(!session) {
        NSLog(@"Can't open the connection");
    }
}

#pragma mark - NSURLSession delegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData * data = [NSData dataWithContentsOfURL:location];
    self.receivedData = [data copy];
    [self.delegate WebSearcherController:self didReceiveData:self.receivedData withError:nil];
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
