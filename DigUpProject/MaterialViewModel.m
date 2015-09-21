//
//  MaterialViewModel.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"

@implementation MaterialViewModel

- (id) initWithModel:(MaterialModel *) materialModel {
    self = [super init];
    if (self) {
        self.material = materialModel;
        self.materialID = materialModel.Id;
    }
    return self;
}

@end
