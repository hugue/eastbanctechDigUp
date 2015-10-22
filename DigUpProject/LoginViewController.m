//
//  LoginViewController.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * spinner;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[LoginViewModel alloc] init];
    self.spinner.center = self.view.center;
    self.spinner.hidesWhenStopped = YES;
    [self applyModelToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signInSegue"]) {
        MyCoursesViewController * myCoursesViewController = [segue destinationViewController];
        myCoursesViewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
    }
}


- (void)applyModelToView {
    RAC(self.viewModel, login) = self.loginTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    
    @weakify(self)
    [[RACObserve(self.viewModel, profileLoaded) distinctUntilChanged]subscribeNext:^(id x) {
        if ([x boolValue]) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"signInSegue" sender:nil];
            });
        }
    }];
    
    [RACObserve(self.viewModel, currentState) subscribeNext:^(id x) {
        @strongify(self)
        if ([x integerValue] == LogInCurrentStateProcessing) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner startAnimating];
                self.loginTextField.enabled = NO;
                self.passwordTextField.enabled = NO;
                self.signInButton.enabled = NO;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
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
