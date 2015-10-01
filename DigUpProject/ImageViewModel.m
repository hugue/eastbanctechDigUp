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
}

- (void)applyDataToMaterial:(NSData *)data {
    NSLog(@"Apply data to material");
    self.imageData = [data copy];
    self.imageLoaded = @YES;
}

@end
