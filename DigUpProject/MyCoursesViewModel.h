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
#import "DocumentViewModel.h"
#import "ExamViewModel.h"
#import "CourseModel.h"

@interface MyCoursesViewModel : NSObject

@property (nonatomic, strong) NSString * selectedCourse;
@property (nonatomic, strong) NSArray<CourseModel *> * profileCourses;
@property (nonatomic, strong) CoursesTableViewModel * coursesViewModel;
@property (nonatomic, strong) CoursesTableViewModel * detailCoursesViewModel;
@property (nonatomic, strong) DocumentViewModel * documentViewModel;
@property (nonatomic, strong) ExamViewModel * examViewModel;
@property (nonatomic, strong) WebController * webController;

- (id)initWithCourses:(NSArray<CourseModel *> *)courses WebController:(WebController *)webController;
- (void)observeSubModels;
- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;
- (NSMutableArray<CourseCellViewModel *> *)createCellViewModelsForCourse:(NSNumber *)courseNumber;
- (void)viewWillAppear;

@end
