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

- (BOOL)signInNow {
    self.webController = [[WebController alloc] init];
    [self.webController addTaskForObject:self toURL:@"https://demo5748745.mockable.io/profile"];
    //NSMutableArray<CourseModel *> * courses = [[NSMutableArray alloc] init];
    NSLog(@"Login - %@ and password - %@", self.login, self.password);
   //CourseModel * course1 = [[CourseModel alloc] initWithTitle:@"Mathematics" AndDocuments:@[@"Cosinus", @"Poincarre's formula", @"Complex numbers"]];
    //CourseModel * course2 = [[CourseModel alloc] initWithTitle:@"Litterature" AndDocuments:@[@"Balzac", @"Tolstoi"]];
    //[courses addObject:course1];
    //[courses addObject:course2];
    //for (int i = 0; i < 50; i++) {
    //    CourseModel * newCourse = [[CourseModel alloc] initWithTitle:[NSString stringWithFormat:@"Course %d", i]  AndDocuments:@[@"Hello"]];
    //    [courses addObject:newCourse];
    //}
    //self.profileViewModel = [[MyCoursesViewModel alloc] initWithCourses:courses WebController:self.webController];
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
    NSLog(@"%@", [self.profile class]);
    NSLog(@"%@", self.profile);
}

@end
