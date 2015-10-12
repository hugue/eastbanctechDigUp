//
//  ExamFirstViewController.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamFirstViewModel.h"

@interface ExamFirstViewController : UIViewController

@property (nonatomic, strong) ExamFirstViewModel * viewModel;

- (IBAction)StartExam:(id)sender;

@end