//
//  CoursesTableViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ETRSimpleCollectionModel.h"
#import "CourseCellViewModel.h"

@interface CoursesTableViewModel : ETRSimpleCollectionModel


@property (nonatomic, strong) NSMutableArray<CourseCellViewModel *> * listModelCourses;
@property (nonatomic, strong) NSMutableArray<NSString *> * listCellsNames;
@property (nonatomic, strong) NSString * cellIdentifier;
@property (nonatomic, strong) NSNumber * selectedCell;

- (id)initWithCellIdentifier:(NSString *)identifier andItems:(NSArray *)itemsCellsNames;
//- (void)addNewCellWithLabel:(NSString *)cellLabel;

- (void)addNewCellWithLabel:(NSString *)cellLabel;
- (void)didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
