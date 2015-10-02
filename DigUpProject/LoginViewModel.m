//
//  LoginViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "LoginViewModel.h"
@interface LoginViewModel ()

@property (nonatomic,strong) RACSignal * signInValidArguments;

@end

@implementation LoginViewModel

- (id)init {
    self = [super init];
    
    return self;
}

/*
- (RACCommand *)signInCommand {
    if (!self.signInCommand) {
        NSString * login = self.login;
        NSString * password = self.password;
        self.signInCommand = [[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal *(id input) {
            //return [SubscribeViewModel postEmail:email];
        }];
    }
    return self.signInCommand;
}
*/
/*
- (RACSignal *)signInValidArguments {
    if (self.signInValidArguments) {
        self.signInValidArguments = [RACObserve(self, email) map:^id(NSString *email) {
            return @([email isValidEmail]);
        }];
    }
    return _emailValidSignal;
}
*/

- (BOOL)signInNow {
    NSLog(@"Login - %@ and password - %@", self.login, self.password);
    self.profileViewModel = [[MyCoursesViewModel alloc] init];
    return YES;
}
@end
