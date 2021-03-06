//
//  CoursesTableViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CoursesTableViewModel.h"

@implementation CoursesTableViewModel

- (id)initWithCellIdentifier:(NSString *)identifier andItems:(NSArray *)itemsCellsNames {
    self = [super init];
    if (self) {

        self.listCellsNames = [itemsCellsNames copy];
        self.cellIdentifier = identifier;
        
        NSMutableArray * cellsModels = [NSMutableArray array];
        for (NSString * cellsNames in self.listCellsNames) {
            CourseCellViewModel * cellModel = [[CourseCellViewModel alloc] initWithIdentifier:self.cellIdentifier andLabel:cellsNames];
            [cellsModels addObject: cellModel];
        }
        
        self.items = [cellsModels copy];
    }
    return self;
}

- (void)addNewCellWithLabel:(NSString *)cellLabel {

    CourseCellViewModel * newCell = [[CourseCellViewModel alloc] initWithIdentifier:self.cellIdentifier andLabel:cellLabel];
    self.items = [self.items arrayByAddingObject:newCell];
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion {
    self.selectedCell = [NSNumber numberWithInt:(int)[indexPath indexAtPosition:1]];
}

@end
