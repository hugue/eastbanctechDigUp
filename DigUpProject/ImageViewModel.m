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
}

- (void)applyDataToMaterial:(NSData *)data {
    self.imageData = [data copy];
    self.imageLoaded = @YES;
}
/*
#pragma mark - DataControllerProtocol

- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    if (error) {
        NSLog(@"Error upon receiving data in ImageViewModel- %@", error);
    }
    else {
        [self applyDataToMaterial:data];
    }
}
*/
@end
