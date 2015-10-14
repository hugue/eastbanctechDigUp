//
//  ExamResultViewController.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamResultViewController.h"

@implementation ExamResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.text.numberOfLines = 0;
    [self applyModelToView];
}

- (IBAction)backToMenu:(id)sender {
    NSArray * stackViewControllers = self.navigationController.viewControllers;
    NSUInteger indexCurrentViewController = [stackViewControllers indexOfObject:self];
    [self.navigationController popToViewController:stackViewControllers[indexCurrentViewController - 2] animated:YES];
}

- (void)applyModelToView {
    self.text.text = self.viewModel.text;
}

@end
