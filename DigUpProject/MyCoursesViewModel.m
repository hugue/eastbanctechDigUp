//
//  MyCoursesViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MyCoursesViewModel.h"

@implementation MyCoursesViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.coursesViewModel = [[CoursesTableViewModel alloc] init];
 /*
        self.detailCourses = [[NSMutableDictionary alloc] init];
        [self.detailCourses setObject:@[@"Geometry",@"Complex Numbers"] forKey:@"Mathematics"];
        [self.detailCourses setObject:@[@"The 3rd Newton's law",@"2 Principle of thermodynamics"] forKey:@"Physics"];
        [self.detailCourses setObject:@[@"Balzac",@"Blabla"] forKey:@"Litterature"];
        [self.detailCourses setObject:@[@"Geology",@"Turtles", @"Mice"] forKey:@"Biology"];*/
    }
    return self;
}


@end
