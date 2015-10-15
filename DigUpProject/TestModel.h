//
//  TestModel.h
//  DigUpProject
//
//  Created by hugues on 07/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface TestModel : JSONModel

@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * mediaUrl;
@property (nonatomic, strong) NSString * name;

- (id)initWithTitle:(NSString *)testTitle;

@end


@protocol TestModel <NSObject>
@end