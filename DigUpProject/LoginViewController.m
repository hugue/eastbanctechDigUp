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
@property (nonatomic, weak) UITextField * activeField;
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self.viewModel viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterForKeyBoardNotification];
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

#pragma mark UITextField delegate methods

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterForKeyBoardNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification *)aNotification {
    
    NSDictionary * info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGPoint point = CGPointMake(self.activeField.frame.origin.x+self.activeField.frame.size.width, self.activeField.frame.origin.y+self.activeField.frame.size.height);
    if(!CGRectContainsPoint(aRect, point)) {
        [self.scrollView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y - aRect.size.height + self.activeField.frame.size.height) animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}


@end
