//
//  CourseModel.h
//  DigUpProject
//
//  Created by hugues on 05/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubcourseModel.h"
#import "ExamModel.h"

@interface CourseModel : NSObject

@property (nonatomic, strong) NSString * courseTitle;
@property (nonatomic, strong) NSArray <SubcourseModel *> * subcourses;
@property (nonatomic, strong) ExamModel * exam;

- (id)initWithTitle:(NSString *)title AndDocuments:(NSArray<NSString *> *)titleDocs;

@end
