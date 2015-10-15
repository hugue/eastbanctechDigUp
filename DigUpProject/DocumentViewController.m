//
//  documentViewController.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyModelToView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyModelToView {
    NSString * documentName = self.viewModel.currentSubcourse.document;
    self.documentView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.documentView loadRequest:request];
}

- (IBAction)chooseTest:(UIButton *)sender {
        [self performSegueWithIdentifier:@"chooseTestSegue" sender:nil];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    CoursesTableViewController * tableViewController = [segue destinationViewController];
    tableViewController.viewModel = [self.viewModel prepareForSegueWithIdentifier:segue.identifier];
}

@end
