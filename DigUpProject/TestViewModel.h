//
//  TestViewModel.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebController.h"
#import "ExerciseViewModel.h"
#import "TestModel.h"


@interface TestViewModel : NSObject <DataControllerProtocol>

@property (nonatomic, strong) TestModel * dataModel;
@property (nonatomic, strong) NSData * dataTest;
@property (nonatomic, strong) WebController * webController;
@property (nonatomic, strong) ExerciseModel * exerciseModel;
@property (nonatomic, strong) NSNumber * exerciseLoaded;
@property (nonatomic, strong) ExerciseViewModel * exerciseViewModel;

- (id)initWithDataModel:(TestModel *)dataModel WebController:(WebController *)webController;
- (void)setDataModel:(TestModel *)dataModel;
- (id)prepareForSegueWithIdentifier:(NSString *)identifier;
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier;

- (void)correctionAsked;
- (void)solutionAsked;
- (void)restartAsked;

@end
