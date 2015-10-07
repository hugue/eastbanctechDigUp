//
//  SubcourseModel.h
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModel.h"

@interface SubcourseModel : NSObject

@property (nonatomic, strong) NSString * documentName;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSArray<TestModel *> * listTests;

- (id)initWithTitle:(NSString *)title andDocument:(NSString *)documentTitle ;

@end
