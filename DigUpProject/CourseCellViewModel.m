//
//  CourseCellViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CourseCellViewModel.h"

@implementation CourseCellViewModel

- (id)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.cellIdentifier = identifier;
    }
    return self;
}

- (NSString *)reuseIdentifier {
        return self.cellIdentifier;
}

@end
