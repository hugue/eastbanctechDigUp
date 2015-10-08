//
//  MyCoursesViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MyCoursesViewModel.h"
@interface MyCoursesViewModel()

@end

@implementation MyCoursesViewModel

- (id)initWithCourses:(NSArray<CourseModel *> *)courses {
    self = [super init];
    if (self) {
        NSMutableArray<NSString *> * coursesNames = [[NSMutableArray alloc] init];
        self.profileCourses = [courses copy];
        
        for (CourseModel * course in courses) {
            [coursesNames addObject:course.courseTitle];
        }
        
        self.coursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"CourseCellView" andItems:coursesNames];
        self.detailCoursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"CourseCellView" andItems:nil];
        //self.documentViewModel = [[DocumentViewModel alloc] init];
        
        [self observeSubModels];
    }
    return self;
}

- (void)observeSubModels {
    @weakify(self)
    [[RACObserve(self.coursesViewModel, selectedCell) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        self.detailCoursesViewModel.items = [self createCellViewModelsForCourse:x];
    }];
}

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel = nil;
    if ([segueIdentifier isEqualToString:@"coursesSegue"]) {
        viewModel = self.coursesViewModel;
    }
    else if ([segueIdentifier isEqualToString:@"detailCoursesSegue"]) {
        viewModel = self.detailCoursesViewModel;
    }
    else if ([segueIdentifier isEqualToString:@"viewDocument"]) {
        CourseModel * currentCourse = [self.profileCourses objectAtIndex:[self.coursesViewModel.selectedCell integerValue]];
        SubcourseModel * currentSubcourse = [currentCourse.subcourses objectAtIndex:[self.detailCoursesViewModel.selectedCell integerValue]];
        self.documentViewModel = [[DocumentViewModel alloc] initWithSubcourse:currentSubcourse];
        viewModel = self.documentViewModel;
    }
    return viewModel;

}


- (NSMutableArray<CourseCellViewModel *> *)createCellViewModelsForCourse:(NSNumber *)courseNumber {
    if (courseNumber) {
        NSMutableArray<CourseCellViewModel *> * courseCellViewModels = [[NSMutableArray alloc] init];
        for (SubcourseModel * subcourse in [self.profileCourses objectAtIndex:[courseNumber integerValue]].subcourses) {
            CourseCellViewModel * newCellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.detailCoursesViewModel.cellIdentifier andLabel:subcourse.title];
            [courseCellViewModels addObject:newCellModel];
        }
    return courseCellViewModels;
    }
    else {
        return nil;
    }
}

- (void)viewWillAppear {
    self.documentViewModel = nil;
}

@end
