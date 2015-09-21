//
//  CellViewModel.m
//  DigUpProject
//
//  Created by hugues on 16/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CellViewModel.h"

@implementation CellViewModel


- (id) init {
    self = [super init];
    if (self) {
        self.style = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

@end
