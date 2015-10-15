//
//  TestModel.h
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel/JSONModel/JSONModel.h"

@interface TestModel : JSONModel

@property (nonatomic, strong) NSString * urlExercise;
@property (nonatomic, strong) NSString * urlMedia;
@property (nonatomic, strong) NSString * title;

- (id)initWithTitle:(NSString *)testTitle;

@end
