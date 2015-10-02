//
//  CoursesTableViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CoursesTableViewModel.h"

@implementation CoursesTableViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.listCourses = [[NSMutableArray alloc] init];
        [self.listCourses addObject:@"Mathematics"];
        [self.listCourses addObject:@"Physics"];
        [self.listCourses addObject:@"Litterature"];
        [self.listCourses addObject:@"Biology"];
    }
    return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.listCourses.count;
    }
    return 0;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"IndexPath - %@ , and first element - %d", indexPath, [indexPath indexAtPosition:0]);
    //NSString * item = [self.listCourses objectAtIndex:[indexPath indexAtPosition:0]];
    return @"Hello";
}

@end
