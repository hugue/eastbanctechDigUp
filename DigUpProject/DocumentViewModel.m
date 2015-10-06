//
//  documentViewModel.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "DocumentViewModel.h"

@implementation DocumentViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.chooseTestViewModel = [[ChooseTestTableViewModel alloc] init];
        self.chooseTestViewModel.cellIdentifier = @"CourseCellView";
    }
    return self;
}

- (id)initWithTests:(NSArray<NSString *> *)listTest {
    self = [super init];
    if (self) {
        self.testNames = [listTest copy];
    }
    return self;
}

- (NSArray<CourseCellViewModel *> *)createCellViewModelsForListTests:(NSArray<NSString *> *)listTests {
    NSMutableArray<CourseCellViewModel *> * courseCellViewModels = [[NSMutableArray alloc] init];
    for (NSString * cellLabel in listTests) {
        CourseCellViewModel * newCellModel = [[CourseCellViewModel alloc] initWithIdentifier:@"CourseCellView" andLabel:cellLabel];
        [courseCellViewModels addObject:newCellModel];
    }
    return courseCellViewModels;
}

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel;
    if ([segueIdentifier isEqualToString:@"chooseTestSegue"]) {
        self.chooseTestViewModel.items = [self createCellViewModelsForListTests:self.testNames];
        viewModel = self.chooseTestViewModel;
    }
    return viewModel;
}

@end