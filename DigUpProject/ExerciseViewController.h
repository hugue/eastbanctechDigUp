//
//  ExerciseViewController.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <QuartzCore/QuartzCore.h>
#import <AVKit/AVKit.h>

#import "ExerciseViewModel.h"
#import "MaterialView.h"
#import "DragElementRecognizer.h"
#import "TextFrameView.h"
#import "ImageView.h"
#import "RadioButtonView.h"
#import "TextInputViewModel.h"
#import "RectangleView.h"
#import "TextInputView.h"
#import "TableView.h"
#import "AudioView.h"
#import "CheckBoxView.h"
#import "AudioBarView.h"

@interface ExerciseViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) ExerciseViewModel * viewModel;
@property (strong, nonatomic) NSMutableArray<MaterialView *> * materialsViews;
@property (nonatomic, strong) AudioBarView * audioBar;
@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;

- (void)displayExercise;
- (void)initialize;
- (void)removeViewModel:(NSSet *)objects;

@end



