//
//  CoursesTableViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CoursesTableViewModel.h"

@implementation CoursesTableViewModel

- (id)initWithCellIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.listModelCourses = [[NSMutableArray alloc] init];
        self.cellIdentifier = identifier;
    }
    return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.listModelCourses.count;
    }
    return 0;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
       return [self.listModelCourses objectAtIndex:[indexPath indexAtPosition:1]];
}

- (void)addNewCellWithLabel:(NSString *)cellLabel {
    CourseCellViewModel * newCell = [[CourseCellViewModel alloc] initWithIdentifier:self.cellIdentifier];
    newCell.cellLabel = cellLabel;
    [self.listModelCourses addObject:newCell];
}

@end
