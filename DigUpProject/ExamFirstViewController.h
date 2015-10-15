//
//  ExamFirstViewController.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamFirstViewModel.h"
#import "ExamViewController.h"

@interface ExamFirstViewController : UIViewController
@property (nonatomic, strong) ExamFirstViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfExercercisesLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *lastDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastScoreLabel;
@end
