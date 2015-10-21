//
//  ExamResultViewModel.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamModel.h"
#import "SwaggerClient/SWGDefaultApi.h"

@interface ExamResultViewModel : NSObject

@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) SWGExam * dataModel;

- (id)initWithSWGExam:(SWGExam *)dataModel;

@end
