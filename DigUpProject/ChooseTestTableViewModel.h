//
//  ChooseTestTableViewModel.h
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ETRSimpleCollectionModel.h"
#import "CourseCellViewModel.h"
#import "WebController.h"
#import "TestModel.h"
#import "TestViewModel.h"

@interface ChooseTestTableViewModel : ETRSimpleCollectionModel

@property (nonatomic, strong) NSArray<SWGTest *> * listTests;
@property (nonatomic, strong) NSString * cellIdentifier;

@property (nonatomic, strong) NSNumber * selectedCell;
@property (nonatomic, strong) WebController * webController;

- (id)initWithWebController:(WebController *)webController;
- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;
- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
