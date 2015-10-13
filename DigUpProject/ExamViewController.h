//
//  ExamViewController.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamViewModel.h"

@interface ExamViewController : UIViewController

@property (nonatomic, strong) ExamViewModel * viewModel;

- (IBAction)showNext:(id)sender;
- (IBAction)showPrevious:(id)sender;
- (IBAction)endExam:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@end
