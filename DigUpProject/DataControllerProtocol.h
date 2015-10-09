//
//  DataControllerProtocol.h
//  DigUpProject
//
//  Created by hugues on 09/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataControllerProtocol <NSObject>

@required
- (void)didReceiveData:(nullable NSData *) data withError:(nullable NSError *) error;

@end

