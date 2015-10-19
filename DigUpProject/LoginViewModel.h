//
//  LoginViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ProfileModel.h"
#import "MyCoursesViewModel.h"
#import "SWGDefaultApi.h"

typedef NS_ENUM(NSInteger, LogInCurrentState) {
    LogInCurrentStateListening,
    LogInCurrentStateProcessing
};

@interface LoginViewModel : NSObject <DataControllerProtocol>

@property (nonatomic, strong) NSString * login;
@property (nonatomic, strong) NSString * password;
@property (nonatomic) enum LogInCurrentState currentState;
@property (nonatomic) BOOL profileLoaded;
@property (nonatomic, strong) SWGDefaultApi * defaultApi;

- (BOOL)signInNow;
- (void)viewWillAppear;
- (MyCoursesViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;

@end
