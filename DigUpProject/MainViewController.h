//
//  MainViewController.h
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>
#import "HUD/HUD.h"
#import "MainViewModel.h"
#import "MaterialView.h"
#import "DragElementRecognizer.h"
#import <AVKit/AVKit.h>

#import "TextFrameView.h"
#import "ImageView.h"
#import "RadioButtonView.h"
#import "TextInputViewModel.h"
#import "RectangleView.h"
#import "TextInputView.h"
#import "TableView.h"
#import "AudioView.h"
#import "CheckBoxView.h"

@interface MainViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) DragElementRecognizer * dragRecongnizer;
@property (strong, nonatomic) NSMutableArray<MaterialView *>* materialsViews;

- (id) initWithViewModel:(MainViewModel *) mainViewModel;
- (void) displayExercise;

@end
