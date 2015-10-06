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
        self.items = [NSArray array];
        self.cellIdentifier = identifier;
    }
    return self;
}

- (void)addNewCellWithLabel:(NSString *)cellLabel {
    CourseCellViewModel * newCell = [[CourseCellViewModel alloc] initWithIdentifier:self.cellIdentifier];
    newCell.cellLabel = cellLabel;
    self.items = [self.items arrayByAddingObject:newCell];
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion {
    self.selectedCell = [NSNumber numberWithInt:[indexPath indexAtPosition:1]];
}

- (void)didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCell = nil;
}

@end
