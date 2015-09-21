//
//  WebSearcherController.h
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebSearcherController : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSString * urlToReach;
@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, strong) NSString * imageURL;

- (id) init;
- (void) launchSession;

@end


@protocol WebSearcherControllerDelegate <NSObject>

@required
- (void) WebSearcherController:(WebSearcherController *) webSearcherController didReceiveData:(nullable NSData *) data withError:(nullable NSError *) error;

@end