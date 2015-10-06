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
        self.courseTitle = title;
        self.documentsTitle = titlesDocs;
    }
    return self;
}

@end
