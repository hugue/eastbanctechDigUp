//
//  MyCoursesViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoursesTableViewModel.h"

@interface MyCoursesViewModel : NSObject

//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<NSString *> *> * detailCourses;

@property (nonatomic, strong) NSString * selectedCourse;
@property (nonatomic, strong) CoursesTableViewModel * coursesViewModel;

- (id)init;

@end
