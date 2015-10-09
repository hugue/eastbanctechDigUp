//
//  documentViewModel.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "DocumentViewModel.h"

@implementation DocumentViewModel

- (id)initWithSubcourse:(SubcourseModel *)subcourse webController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.currentSubcourse = subcourse;
        self.webController = webController;
        self.chooseTestViewModel = [[ChooseTestTableViewModel alloc] initWithWebController:self.webController];
        [self configureChooseTestViewModel];
    }
    return self;
}

- (NSArray<CourseCellViewModel *> *)createCellViewModelsForListTests:(NSArray<TestModel *> *)listTests {
    NSMutableArray<CourseCellViewModel *> * courseCellViewModels = [[NSMutableArray alloc] init];
    for (TestModel * test in listTests) {
        CourseCellViewModel * newCellModel = [[CourseCellViewModel alloc] initWithIdentifier:@"CourseCellView" andLabel:test.title];
        [courseCellViewModels addObject:newCellModel];
    }
    return courseCellViewModels;
}

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel;
    if ([segueIdentifier isEqualToString:@"chooseTestSegue"]) {
        self.chooseTestViewModel.selectedCell = nil;
        viewModel = self.chooseTestViewModel;
    }
    return viewModel;
}

- (void)configureChooseTestViewModel {
    self.chooseTestViewModel.cellIdentifier = @"CourseCellView";
    self.chooseTestViewModel.listTests = self.currentSubcourse.listTests;
    self.chooseTestViewModel.items = [self createCellViewModelsForListTests:self.currentSubcourse.listTests];
}
@end
