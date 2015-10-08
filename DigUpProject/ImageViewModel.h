//
//  ImageViewModel.h
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"

@interface ImageViewModel : MaterialViewModel 

@property (nonatomic, strong) NSNumber * BlobID;
@property (nonatomic, strong) NSData * imageData;
@property (nonatomic, strong) NSNumber * imageLoaded;

- (void)applyDataToMaterial:(NSData *)data;

@end
