//
//  WebSearcherController.h
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "MaterialViewModel.h"

@interface WebSearcherController : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>


@property (nonatomic, strong) NSString * urlToReach;
@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, strong) NSString * mediaURL;
@property (nonatomic, weak) id delegate;

- (id)init;
- (void)launchSession;
- (void)registerNewViewToDownloadMedia:(MaterialViewModel *) materialViewModel forBlobId:(NSNumber *)blobID;
- (void)launchDownloadingMediaSession;

@end


@protocol WebSearcherControllerDelegate <NSObject>

@required
- (void) webSearcherController:(WebSearcherController *) webSearcherController didReceiveData:(nullable NSData *) data withError:(nullable NSError *) error;

@end