//
//  CoursesTableViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CoursesTableViewModel.h"

@implementation CoursesTableViewModel

- (id)initWithCellIdentifier:(NSString *)identifier andItems:(NSMutableArray *)itemsCellsNames {
    self = [super init];
    if (self) {
        //self.listModelCourses = [[NSMutableArray alloc] init];
        self.listCellsNames = itemsCellsNames;
        self.cellIdentifier = identifier;
        
        NSMutableArray * cellsModels = [NSMutableArray array];
        for (NSString * cellsNames in self.listCellsNames) {
            CourseCellViewModel * cellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.cellIdentifier andLabel:cellsNames];
            [cellsModels addObject: cellModel];
        }
        
        self.items = cellsModels;
    }
    return self;
}

- (void)addNewCellWithLabel:(NSString *)cellLabel {
    CourseCellViewModel * newCell = [[CourseCellViewModel alloc] initWithIdentifier:self.cellIdentifier andLabel:cellLabel];
    newCell.cellLabel = cellLabel;
    [self.listModelCourses addObject:newCell];
}

@end
