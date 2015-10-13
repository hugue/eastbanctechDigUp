//
//  ExamResultViewController.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamResultViewModel.h"

@interface ExamResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backToMenu;
@property (strong, nonatomic) ExamResultViewModel * viewModel;

@end
