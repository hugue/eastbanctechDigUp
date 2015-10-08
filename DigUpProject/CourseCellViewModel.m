//
//  CourseCellViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CourseCellViewModel.h"

@implementation CourseCellViewModel

- (id)initWithIdentifier:(NSString *)identifier andLabel:(NSString *)cellLabel{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.cellLabel = cellLabel;
    }
    return self;
}


- (NSString *)reuseIdentifier {
        return self.identifier;
}

@end
