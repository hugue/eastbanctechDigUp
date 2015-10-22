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
#import "SwaggerClient/SWGDefaultApi.h"

typedef NS_ENUM(NSInteger, TestLoadingState) {
    TestLoadingStateGoingOn,
    TestLoadingStateStopped
};

@interface TestViewModel : NSObject

@property (nonatomic, strong) SWGTest * dataModel;
@property (nonatomic, strong) NSData * dataTest;
@property (nonatomic, strong) WebController * webController;
@property (nonatomic, strong) SWGExercise * exerciseModel;
@property (nonatomic) enum TestLoadingState loadingState;
@property (nonatomic) BOOL exerciseLoaded;
@property (nonatomic, strong) ExerciseViewModel * exerciseViewModel;
@property (nonatomic, strong) SWGDefaultApi * defaultApi;

- (id)initWithSWGTest:(SWGTest *)dataModel WebController:(WebController *)webController;
- (id)prepareForSegueWithIdentifier:(NSString *)identifier;
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier;

- (void)correctionAsked;
- (void)solutionAsked;
- (void)restartAsked;

- (void)viewWillAppear;

@end
