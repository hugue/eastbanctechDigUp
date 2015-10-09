//
//  WebController.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataControllerProtocol.h"

@interface WebController : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

- (void)addTaskForObject:(id<DataControllerProtocol>)object toURL:(NSString *)url;

@end
