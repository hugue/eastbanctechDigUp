//
//  ViewController.h
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebSearcherController.h"
#import "ExerciceModel.h"
#import "HUD/HUD.h"

@interface ViewController : UIViewController <WebSearcherControllerDelegate>

@property (nonatomic, strong) WebSearcherController * webSearcherController;
@property (nonatomic, strong) ExerciceModel * currentExercise;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void) displayExercise;

@end

