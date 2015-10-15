//
//  TestModel.m
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

- (id)initWithTitle:(NSString *)testTitle {
    self = [super init];
    if (self) {
        self.name = testTitle;
        self.url = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&";
        self.mediaUrl = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/Stream/Blob/";
    }
    return self;
}

@end
