//
//  LoginViewController.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[LoginViewModel alloc] init];    
    [self applyModelToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"signInSegue"]) {
        MyCoursesViewController * myCoursesViewController = [segue destinationViewController];
        myCoursesViewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
    }
}


- (void)applyModelToView {
    RAC(self.viewModel, login) = self.loginTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    
    [[RACObserve(self.viewModel, profileLoaded) distinctUntilChanged]subscribeNext:^(id x) {
        if ([x boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"signInSegue" sender:nil];
            });
        }
    }];
    
    @weakify(self)
    [RACObserve(self.viewModel, currentState) subscribeNext:^(id x) {
        @strongify(self)
        if ([x integerValue] == LogInCurrentStateProcessing) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loginTextField.enabled = NO;
                self.passwordTextField.enabled = NO;
                self.signInButton.enabled = NO;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loginTextField.enabled = YES;
                self.passwordTextField.enabled = YES;
                self.signInButton.enabled = YES;
            });
        }
    }];
    
}

- (IBAction)signInButton:(id)sender {
    [self.viewModel signInNow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel viewWillAppear];
}

@end
