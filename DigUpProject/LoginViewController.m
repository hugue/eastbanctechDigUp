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
    if ([segue.identifier isEqualToString:@"SignInSegue"]) {
        MyCoursesViewController * myCoursesViewController = [segue destinationViewController];
        [myCoursesViewController setViewModel:self.viewModel.profileViewModel];
    }
}


- (void)applyModelToView {
    RAC(self.viewModel, login) = self.loginTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    //self.signInButton.rac_command = self.viewModel.signInCommand;
}

- (IBAction)signInButton:(id)sender {
    if ([self.viewModel signInNow]) {
         [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    }
}
@end
