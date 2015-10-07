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
        self.title = testTitle;
        self.urlExercise = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&";
        self.urlMedia = @"http://dev-digup-01.dev.etr.eastbanctech.ru:81/Stream/Blob/";
    }
    return self;
}

@end
