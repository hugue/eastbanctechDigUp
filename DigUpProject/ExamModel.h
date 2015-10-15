//
//  ExamModel.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamModel : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * allowedTime;
@property (nonatomic, strong) NSString * examULR;
@property (nonatomic, strong) NSNumber * numberOfQuestions;
@property (nonatomic, strong) NSNumber * requiredScore;
@property (nonatomic, strong) NSNumber * currentScore;

@end
