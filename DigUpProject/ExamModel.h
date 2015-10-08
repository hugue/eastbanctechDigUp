//
//  ExamModel.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamModel : NSObject

@property (nonatomic) NSUInteger numberOfQuestions;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * allowedTime;

@property (nonatomic, strong) NSNumber * lastPercentageCorrect;
@property (nonatomic, strong) NSNumber * lastDuration;

@end
