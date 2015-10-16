//
//  ExamViewController.h
//  DigUpProject
//
//  Created by hugues on 08/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ExamViewModel.h"
#import "ExerciseViewController.h"
#import "ExamResultViewController.h"

@interface ExamViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) ExamViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UIView * exerciseView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (strong, nonatomic) UISwipeGestureRecognizer * previousSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer * nextSwipeRecognizer;

- (IBAction)goBack:(id)sender;
- (IBAction)showNext:(id)sender;
- (IBAction)showPrevious:(id)sender;
- (IBAction)endExam:(id)sender;

@end
