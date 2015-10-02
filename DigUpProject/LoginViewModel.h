//
//  LoginViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MyCoursesViewModel.h"

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString * login;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) RACCommand * signInCommand;
@property (nonatomic, strong) MyCoursesViewModel * profileViewModel;


- (id)init;
- (BOOL)signInNow;

@end
