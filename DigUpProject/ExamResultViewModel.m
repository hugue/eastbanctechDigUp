//
//  ExamResultViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamResultViewModel.h"

@implementation ExamResultViewModel

- (id)initWithValues:(NSUInteger)value {
    self = [super init];
    if (self) {
        self.text = [NSString stringWithFormat:@"You obtained %d", value];
    }
    return self;
}

@end
