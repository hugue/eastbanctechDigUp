//
//  LoginViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "LoginViewModel.h"
@interface LoginViewModel ()

@property (nonatomic, strong) RACSignal * signInValidArguments;
@property (nonatomic, strong) WebController * webController;
@property (nonatomic, strong) ProfileModel * profile;

@end

@implementation LoginViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.profileLoaded = NO;
    }
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

- (MyCoursesViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    MyCoursesViewModel * coursesViewModel;
    if ([segueIdentifier isEqualToString:@"signInSegue"]) {
        coursesViewModel = [[MyCoursesViewModel alloc] initWithCourses:self.profile.courses WebController:self.webController];
    }
    return coursesViewModel;
}

- (BOOL)signInNow {
    self.webController = [[WebController alloc] init];
    [self.webController addTaskForObject:self toURL:@"https://demo5748745.mockable.io/profile"];
    NSLog(@"Login - %@ and password - %@", self.login, self.password);
    return YES;
}

- (void)viewWillAppear {
    self.profileViewModel = nil;
}

#pragma mark - Data Controller Protocol methods
- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    NSError * parseError;
    self.profile = [[ProfileModel alloc] initWithData:data error: &parseError];
    if (parseError) {
        NSLog(@"Error : %@", parseError);
    }
    self.profileLoaded = YES;
}

@end
