//
//  MyCoursesViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MyCoursesViewModel.h"
@interface MyCoursesViewModel()

@property (nonatomic, strong) NSMutableArray<NSArray<NSString *> *> * coursesDocumentsTitles;

@end

@implementation MyCoursesViewModel

- (id)initWithCourses:(NSArray<CourseModel *> *)courses {
    self = [super init];
    if (self) {
        NSMutableArray<NSString *> * coursesNames = [[NSMutableArray alloc] init];
        //self.coursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"CourseCellView"];
        //self.detailCoursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"CourseCellView"];

        
        self.coursesDocumentsTitles = [[NSMutableArray alloc] init];
        
        for (CourseModel * course in courses) {
            [coursesNames addObject:course.courseTitle];
            //[self.coursesViewModel addNewCellWithLabel:course.courseTitle];
            //[self.coursesDocumentsTitles addObject:course.documentsTitle];
        }
        
        self.coursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"CoursesCell" andItems:coursesNames];
        self.detailCoursesViewModel = [[CoursesTableViewModel alloc] initWithCellIdentifier:@"detailsCell" andItems:nil];
        
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


- (NSMutableArray<CourseCellViewModel *> *)createCellViewModelsForCourse:(NSNumber *)courseNumber {
    if (courseNumber) {
        NSMutableArray<CourseCellViewModel *> * courseCellViewModels = [[NSMutableArray alloc] init];
        for (NSString * cellLabel in [self.coursesDocumentsTitles objectAtIndex:[courseNumber integerValue]]) {
            CourseCellViewModel * newCellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.detailCoursesViewModel.cellIdentifier andLabel:cellLabel];
            [courseCellViewModels addObject:newCellModel];
        }
    return courseCellViewModels;
    }
    else {
        return nil;
    }
}

@end
