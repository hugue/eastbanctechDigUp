//
//  ChooseTestTableViewModel.h
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ETRSimpleCollectionModel.h"
#import "CourseCellViewModel.h"
#import "MainViewModel.h"

@interface ChooseTestTableViewModel : ETRSimpleCollectionModel

@property (nonatomic, strong) NSMutableArray<CourseCellViewModel *> * listModelCourses;
@property (nonatomic, strong) NSArray<NSString *> * listCellsNames;
@property (nonatomic, strong) NSString * cellIdentifier;

@property (nonatomic, strong) MainViewModel * mainViewModel;

@end
