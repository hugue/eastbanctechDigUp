//
//  SubcourseModel.h
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExerciseModel.h"

@interface SubcourseModel : NSObject

@property (nonatomic, strong) NSString * documentName;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSArray<ExerciseModel *> * listTests;

- (id)initWithTitle:(NSString *)titleDocument;

@end
