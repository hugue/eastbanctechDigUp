//
//  ExamStartViewModel.h
//  DigUpProject
//
//  Created by hugues on 22/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamModel.h"
#import "ExamViewModel.h"
#import "WebController.h"
#import "SwaggerClient/SWGDefaultApi.h"

typedef NS_ENUM(NSInteger, ExamLoadingState) {
    ExamLoadingStateGoingOn,
    ExamLoadingStateStopped
};

@interface ExamStartViewModel : NSObject
@property (nonatomic, strong) WebController * webController;
@property (nonatomic) BOOL examLoaded;
@property (nonatomic) enum ExamLoadingState loadingState;
@property (nonatomic, strong) SWGExam * dataModel;
@property (nonatomic, strong) SWGDefaultApi * defaultApi;

- (id)initWithSWGExam:(SWGExam *)dataModel WebController:(WebController *)webController;
- (ExamViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;

@end

