//
//  CourseModel.m
//  DigUpProject
//
//  Created by hugues on 05/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

- (id)initWithTitle:(NSString *)title AndDocuments:(NSArray<NSString *> *)titlesDocs {
    self = [super init];
    if (self) {
        self.name = title;
        
        NSMutableArray<SubcourseModel *> * subcoursesInterm = [[NSMutableArray alloc] init];
        
        for (NSString * title in titlesDocs) {
            SubcourseModel * subcourseModel = [[SubcourseModel alloc] initWithTitle:title andDocument:@"partition"];
            [subcoursesInterm addObject:subcourseModel];
        }
        self.subcourses = [subcoursesInterm copy];
        self.exam = [[ExamModel alloc] init];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
