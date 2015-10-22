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

- (id)initWithSWGCourses:(NSArray<SWGCourse *> *)courses WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.webController = webController;
        NSMutableArray<NSString *> * coursesNames = [[NSMutableArray alloc] init];
        self.courses = [courses copy];
        
        for (SWGCourse * course in courses) {
            [coursesNames addObject:course.name];
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
        SWGCourse * currentCourse = [self.courses objectAtIndex:[self.coursesViewModel.selectedCell integerValue]];
        SWGSubcourse * currentSubcourse = [currentCourse.subcourses objectAtIndex:[self.detailCoursesViewModel.selectedCell integerValue]];
        self.documentViewModel = [[DocumentViewModel alloc] initWithSWGSubcourse:currentSubcourse webController:self.webController];
        viewModel = self.documentViewModel;
    }
    else if ([segueIdentifier isEqualToString:@"presentExamSegue"]) {
        SWGCourse * currentCourse = [self.courses objectAtIndex:[self.coursesViewModel.selectedCell integerValue]];
        SWGExam * examModel = currentCourse.exam;
        self.examStartViewModel = [[ExamStartViewModel alloc] initWithSWGExam:examModel WebController:self.webController];
        viewModel = self.examStartViewModel;
    }
    return viewModel;

}


- (NSMutableArray<CourseCellViewModel *> *)createCellViewModelsForCourse:(NSNumber *)courseNumber {
    if (courseNumber) {
        NSMutableArray<CourseCellViewModel *> * courseCellViewModels = [[NSMutableArray alloc] init];
        SWGCourse * course = [self.courses objectAtIndex:[courseNumber integerValue]];
        for (SWGSubcourse * subcourse in course.subcourses) {
            CourseCellViewModel * newCellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.detailCoursesViewModel.cellIdentifier andLabel:subcourse.name];
            [courseCellViewModels addObject:newCellModel];
        }
        if (course.exam) {
            CourseCellViewModel * examCellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.detailCoursesViewModel.cellIdentifier andLabel:course.exam.name];
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
    self.examStartViewModel = nil;
}

@end
