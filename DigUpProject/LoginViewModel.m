//
//  LoginViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "LoginViewModel.h"
@interface LoginViewModel ()

@property (nonatomic, strong) WebController * webController;
@property (nonatomic, strong) ProfileModel * profile;

@end

@implementation LoginViewModel

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.profileLoaded = NO;
    self.currentState = LogInCurrentStateListening;
}

- (MyCoursesViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    MyCoursesViewModel * coursesViewModel;
    if ([segueIdentifier isEqualToString:@"signInSegue"]) {
        coursesViewModel = [[MyCoursesViewModel alloc] initWithCourses:self.profile.courses WebController:self.webController];
    }
    return coursesViewModel;
}

- (BOOL)signInNow {
    self.currentState = LogInCurrentStateProcessing;
    self.webController = [[WebController alloc] init];
    [self.webController addTaskForObject:self toURL:@"https://demo5748745.mockable.io/profile"];
    NSLog(@"Login - %@ and password - %@", self.login, self.password);
    return YES;
}

- (void)viewWillAppear {
    self.profile = nil;
    self.profileLoaded = NO;
}

#pragma mark - Data Controller Protocol methods
- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    NSError * parseError;
    if (!self.profile) {
        self.profile = [[ProfileModel alloc] initWithData:data error: &parseError];
        if (parseError) {
            NSLog(@"Error : %@", parseError);
        }
        self.profileLoaded = YES;
        self.currentState = LogInCurrentStateListening;
    }
}

@end
