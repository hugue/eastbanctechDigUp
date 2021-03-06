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
@property (nonatomic, strong) SWGUser * user;
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
    self.defaultApi = [[SWGDefaultApi alloc] init];
}

- (MyCoursesViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    MyCoursesViewModel * coursesViewModel;
    if ([segueIdentifier isEqualToString:@"signInSegue"]) {
        coursesViewModel = [[MyCoursesViewModel alloc] initWithSWGCourses:self.user.courses WebController:self.webController];
    }
    return coursesViewModel;
}

- (BOOL)signInNow {
    self.currentState = LogInCurrentStateProcessing;
    self.webController = [[WebController alloc] init];
    @weakify(self)
    [self.defaultApi profileGetWithCompletionBlock:^(SWGUser *output, NSError *error) {
        @strongify(self)
        self.user = output;
        self.profileLoaded = YES;
        self.currentState = LogInCurrentStateListening;
    }];
    return YES;
}

- (void)viewWillAppear {
    self.user = nil;
    self.profileLoaded = NO;
}

@end
