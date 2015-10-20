//
//  documentViewModel.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "DocumentViewModel.h"

@implementation DocumentViewModel
/*
- (id)initWithDataModel:(SubcourseModel *)dataModel webController:(WebController *)webController {
    self = [super init];
    if (self) {
        //self.dataModel = dataModel;
        self.webController = webController;
        self.chooseTestViewModel = [[ChooseTestTableViewModel alloc] initWithWebController:self.webController];
        [self configureChooseTestViewModel];
    }
    return self;
}
*/
- (id)initWithSWGSubcourse:(SWGSubcourse *)dataModel webController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.dataModel = dataModel;
        self.webController = webController;
        self.chooseTestViewModel = [[ChooseTestTableViewModel alloc] initWithWebController:self.webController];
        [self configureChooseTestViewModel];
    }
    return self;
}

- (NSArray<CourseCellViewModel *> *)createCellViewModelsForListTests:(NSArray<TestModel *> *)listTests {
    NSMutableArray<CourseCellViewModel *> * courseCellViewModels = [[NSMutableArray alloc] init];
    for (SWGTest * test in listTests) {
        CourseCellViewModel * newCellModel = [[CourseCellViewModel alloc] initWithIdentifier:@"CourseCellView" andLabel:test.name];
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
    self.chooseTestViewModel.listTests = self.dataModel.tests;
    self.chooseTestViewModel.items = [self createCellViewModelsForListTests:self.dataModel.tests];
}
@end
