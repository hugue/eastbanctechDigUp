//
//  ExamFirstViewModel.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamModel.h"
#import "ExamViewModel.h"
#import "WebController.h"
#import "SwaggerClient/SWGDefaultApi.h"

@interface ExamFirstViewModel : NSObject <DataControllerProtocol>
//@property (nonatomic, strong) ExamModel * dataModel;
@property (nonatomic, strong) WebController * webController;
@property (nonatomic) BOOL examLoaded;
@property (nonatomic, strong) SWGExam * dataModel;

- (id)initWithDataModel:(ExamModel *)dataModel WebController:(WebController *)webController;
- (id)initWithSWGExam:(SWGExam *)dataModel WebController:(WebController *)webController;
- (ExamViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;

@end
