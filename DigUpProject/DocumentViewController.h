//
//  documentViewController.h
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentViewModel.h"
#import "CoursesTableViewController.h"

@interface DocumentViewController : UIViewController

@property (nonatomic, strong) DocumentViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UIWebView * documentView;

- (IBAction)chooseTest:(UIButton *)sender;

@end
