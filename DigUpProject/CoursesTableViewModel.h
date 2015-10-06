//
//  CoursesTableViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ETRCollectionModel.h"
#import "CourseCellViewModel.h"

@interface CoursesTableViewModel : ETRCollectionModel

@property (nonatomic, strong) NSMutableArray<CourseCellViewModel *> * listModelCourses;
@property (nonatomic, strong) NSString * cellIdentifier;
@property (nonatomic, strong) NSNumber * selectedCell;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (id)initWithCellIdentifier:(NSString *)identifier;
- (void)addNewCellWithLabel:(NSString *)cellLabel;

@end
