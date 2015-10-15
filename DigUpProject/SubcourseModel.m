//
//  SubcourseModel.m
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "SubcourseModel.h"

@implementation SubcourseModel

- (id)initWithTitle:(NSString *)title andDocument:(NSString *)documentTitle {
    self = [super init];
    if (self) {
        self.name = title;
        self.document = documentTitle;
        NSMutableArray * subcoursesTests = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 50; i++) {
            TestModel * test = [[TestModel alloc] initWithTitle:[NSString stringWithFormat:@"Test %d", i]];
            [subcoursesTests addObject:test];
        }
        self.tests = [subcoursesTests copy];
    }
    return self;
}

@end
