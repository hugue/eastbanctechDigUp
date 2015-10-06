//
//  MyCoursesViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "CoursesTableViewModel.h"
#import "CourseModel.h"

@interface MyCoursesViewModel : NSObject

//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<NSString *> *> * detailCourses;

@property (nonatomic, strong) NSString * selectedCourse;
@property (nonatomic, strong) CoursesTableViewModel * coursesViewModel;
@property (nonatomic, strong) CoursesTableViewModel * detailCoursesViewModel;

- (id)initWithCourses:(NSArray<CourseModel *> *)courses;
- (void)observeSubModels;
- (NSMutableArray<CourseCellViewModel *> *)createCellViewModelsForCourse:(NSNumber *)courseNumber;

@end
