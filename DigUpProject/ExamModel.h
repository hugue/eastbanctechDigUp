//
//  ExamModel.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ExamModel : JSONModel

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * allowedTime;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * mediaUrl;
@property (nonatomic, strong) NSNumber * numberOfQuestions;
@property (nonatomic, strong) NSNumber * requiredScore;

@property (nonatomic, strong) NSNumber<Optional> * currentScore;

@end
