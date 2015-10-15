//
//  SubcourseModel.h
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel/JSONModel/JSONModel.h"
#import "TestModel.h"

@interface SubcourseModel : JSONModel

@property (nonatomic, strong) NSString * document;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray<TestModel *> * listTests;

- (id)initWithTitle:(NSString *)title andDocument:(NSString *)documentTitle ;

@end
