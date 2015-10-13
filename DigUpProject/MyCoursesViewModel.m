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

- (id)initWithCourses:(NSArray<CourseModel *> *)courses WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.webController = webController;
        NSMutableArray<NSString *> * coursesNames = [[NSMutableArray alloc] init];
        self.profileCourses = [courses copy];
        
        for (CourseModel * course in courses) {
            [coursesNames addObject:course.courseTitle];
        }
        self.coursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"CourseCellView" andItems:coursesNames];
        self.detailCoursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"CourseCellView" andItems:nil];
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
    else if ([segueIdentifier isEqualToString:@"viewDocumentSegue"]) {
        CourseModel * currentCourse = [self.profileCourses objectAtIndex:[self.coursesViewModel.selectedCell integerValue]];
        SubcourseModel * currentSubcourse = [currentCourse.subcourses objectAtIndex:[self.detailCoursesViewModel.selectedCell integerValue]];
        self.documentViewModel = [[DocumentViewModel alloc] initWithSubcourse:currentSubcourse webController:self.webController];
        viewModel = self.documentViewModel;
    }
    else if ([segueIdentifier isEqualToString:@"presentExamSegue"]) {
        CourseModel * currentCourse = [self.profileCourses objectAtIndex:[self.coursesViewModel.selectedCell integerValue]];
        ExamModel * examModel = currentCourse.exam;
        self.examFirstViewModel = [[ExamFirstViewModel alloc] initWithDataModel:examModel WebController:self.webController];
        viewModel = self.examFirstViewModel;
    }
    return viewModel;

}


- (NSMutableArray<CourseCellViewModel *> *)createCellViewModelsForCourse:(NSNumber *)courseNumber {
    if (courseNumber) {
        NSMutableArray<CourseCellViewModel *> * courseCellViewModels = [[NSMutableArray alloc] init];
        CourseModel * course = [self.profileCourses objectAtIndex:[courseNumber integerValue]];
        for (SubcourseModel * subcourse in course.subcourses) {
            CourseCellViewModel * newCellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.detailCoursesViewModel.cellIdentifier andLabel:subcourse.title];
            [courseCellViewModels addObject:newCellModel];
        }
        if (course.exam) {
            CourseCellViewModel * examCellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.detailCoursesViewModel.cellIdentifier andLabel:course.exam.title];
            [courseCellViewModels addObject:examCellModel];
        }
        return courseCellViewModels;
    }
    else {
        return nil;
    }
}

- (void)viewWillAppear {
    self.documentViewModel = nil;
    self.examFirstViewModel = nil;
}

@end
