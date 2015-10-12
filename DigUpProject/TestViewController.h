//
//  TestViewController.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestViewModel.h"
#import "ExerciseViewController.h"

@interface TestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView * ExerciseView;
@property (nonatomic, strong) TestViewModel * viewModel;
- (IBAction)restartAsked:(id)sender;
- (IBAction)solutionAsked:(id)sender;
- (IBAction)correctionAsked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;

@property (weak, nonatomic) IBOutlet UIButton *solutionButton;


@end
