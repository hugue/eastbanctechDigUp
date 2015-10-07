//
//  SubcourseModel.m
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "SubcourseModel.h"

@implementation SubcourseModel

- (id)initWithTitle:(NSString *)titleDocument {
    self = [super init];
    if (self) {
        self.title = titleDocument;
        self.documentName = @"partition";
    }
    return self;
}
@end
