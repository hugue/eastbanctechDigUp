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
#import "TestModel.h"

@interface ChooseTestTableViewModel : ETRSimpleCollectionModel

@property (nonatomic, strong) NSArray<TestModel *> * listTests;
@property (nonatomic, strong) NSString * cellIdentifier;

@property (nonatomic, strong) MainViewModel * mainViewModel;
@property (nonatomic, strong) NSNumber * selectedCell;

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;
- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
