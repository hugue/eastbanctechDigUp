//
//  LoginViewController.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"
#import "MyCoursesViewController.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField * loginTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;
@property (strong, nonatomic) LoginViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UIButton * signInButton;

- (IBAction)signInButton:(id)sender;

@end
