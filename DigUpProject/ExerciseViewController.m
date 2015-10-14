//
//  ExerciseViewController.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExerciseViewController.h"

@interface ExerciseViewController ()

@property (nonatomic, strong) UITextField * activeField;

@end

@implementation ExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:@"ExerciseViewController" owner:self options:kNilOptions];
    self.materialsViews = [[NSMutableArray alloc] init];
    
    [self registerForKeyboardNotifications];
    
    DragElementRecognizer * recognizer = [[DragElementRecognizer alloc] initWithTarget:self action:@selector(handleDragging:)];
    recognizer.delegate = self;
    [self.scrollView addGestureRecognizer:recognizer];
    
    for (MaterialViewModel  * viewModel in self.viewModel.materialsModels) {
        [self createMaterialViewWithModel:viewModel];
    }
    [self displayExercise];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)displayExercise {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.scrollView.contentSize.width < self.viewModel.rightBorderOfView) {
            self.scrollView.contentSize = CGSizeMake(self.viewModel.rightBorderOfView, self.scrollView.contentSize.height);
        }
        if (self.scrollView.contentSize.height < self.viewModel.bottomOfView + 100) {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.viewModel.bottomOfView + 100);
        }
        
    });
    for (MaterialView * materialView in self.materialsViews) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Material displayed");
            [materialView addVisualToView:self.scrollView];
        });
    }
    if (self.viewModel.audioController.isNeeded) {
        CGPoint audioBarPosition = CGPointMake(0.0, self.viewModel.bottomOfView + 60);
        self.audioBar = [[AudioBarView alloc] initWithModel:self.viewModel.audioController atPosition:audioBarPosition andWidth:self.viewModel.rightBorderOfView];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView addSubview:self.audioBar.viewDisplayed];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel viewWillDisappear];
}

- (void)createMaterialViewWithModel:(MaterialViewModel *)materialViewModel {
    NSString * type = materialViewModel.material.Type;
    
    if ([type isEqualToString:@"Text"]) {
        TextFrameView * textLabel = [[TextFrameView alloc] initWithViewModel: materialViewModel];
        [self.materialsViews addObject:textLabel];
    }
    else if ([type isEqualToString:@"RadioButton"]) {
        RadioButtonView * radioButton = [[RadioButtonView alloc] initWithViewModel: materialViewModel];
        [self.materialsViews addObject:radioButton];
    }
    else if ([type isEqualToString:@"Rectangle"]) {
        RectangleView * rectangle = [[RectangleView alloc] initWithViewModel:materialViewModel];
        [self.materialsViews addObject:rectangle];
    }
    else if ([type isEqualToString:@"Image"]) {
        ImageView * image = [[ImageView alloc] initWithViewModel: materialViewModel];
        [self.materialsViews addObject:image];
    }
    else if ([type isEqualToString:@"InputField"]) {
        TextInputView * textInput = [[TextInputView alloc] initWithViewModel:materialViewModel];
        textInput.viewDisplayed.delegate = self;
        [self.materialsViews addObject:textInput];
    }
    else if([type isEqualToString:@"Audio"]) {
        AudioView * audio = [[AudioView alloc] initWithViewModel:materialViewModel];
        [self.materialsViews addObject:audio];
    }
    else if([type isEqualToString:@"CheckBox"]) {
        CheckBoxView * checkBox = [[CheckBoxView alloc] initWithViewModel:materialViewModel];
        [self.materialsViews addObject:checkBox];
    }
}

#pragma mark UIRecognizer methods

- (void)handleDragging:(DragElementRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        // Store the initial touch so when we change positions we do not snap
        recognizer.draggedMaterial.position = [recognizer locationInView:recognizer.view];
        //[recognizer.draggedMaterial.viewDisplayed bringSubviewToFront:self.scrollView];
        recognizer.draggedMaterial.viewDisplayed.layer.zPosition = self.viewModel.maxZPosition + self.viewModel.maxTargetZPosition + 1;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint newCoord = [recognizer locationInView:recognizer.view];
        
        // Create the frame offsets to use our finger position in the view.
        float dX = newCoord.x-recognizer.draggedMaterial.position.x;
        float dY = newCoord.y-recognizer.draggedMaterial.position.y;
        
        recognizer.draggedMaterial.viewDisplayed.frame = CGRectMake(recognizer.draggedMaterial.viewDisplayed.frame.origin.x+dX,
                                                                    recognizer.draggedMaterial.viewDisplayed.frame.origin.y+dY,
                                                                    recognizer.draggedMaterial.viewDisplayed.frame.size.width,
                                                                    recognizer.draggedMaterial.viewDisplayed.frame.size.height);
        recognizer.draggedMaterial.position = newCoord;
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded) {
        if(![self.viewModel.dropController pointIsInTargetElement:recognizer.draggedMaterial.position forMaterial:recognizer.draggedMaterial.viewModel]) {
            //Put the element to its original position
            [recognizer.draggedMaterial.viewModel resetPosition];
            recognizer.draggedMaterial.viewDisplayed.layer.zPosition = recognizer.draggedMaterial.viewModel.zPosition + self.viewModel.maxTargetZPosition;
            
        }
        //Put back the recognizer in listening mode
        recognizer.draggedMaterial = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(DragElementRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    gestureRecognizer.draggedMaterial = [self touchIsOnDraggableMaterial:touch];
    if (gestureRecognizer.draggedMaterial && (self.viewModel.currentExerciseState == ExerciseCurrentStateIsGoingOn)) {
        return YES;
    }
    /*
     if (gestureRecognizer.draggedMaterial) {
     return NO;
     }
     else {
     gestureRecognizer.draggedMaterial = [self touchIsOnDraggableMaterial:touch];
     if(gestureRecognizer.draggedMaterial) {
     return YES;
     }
     }*/
    return NO;
}

/*Returns the first material view that can be dragged and is found under the touch*/
- (MaterialView *)touchIsOnDraggableMaterial:(UITouch *)touch {
    CGPoint locationTouch = [touch locationInView:self.scrollView];
    for (MaterialView * element in self.materialsViews) {
        if ([element.viewModel.material.Behavior isEqualToString:@"DropElement"] &&
            CGRectContainsPoint(element.viewDisplayed.frame, locationTouch)) {
            return element;
        }
    }
    return nil;
}

#pragma mark UITextField delegate methods
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillBeShown:(NSNotification *)aNotification {
    
    NSDictionary * info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGPoint point = CGPointMake(self.activeField.frame.origin.x+self.activeField.frame.size.width, self.activeField.frame.origin.y+self.activeField.frame.size.height);
    if(!CGRectContainsPoint(aRect, point)) {
        [self.scrollView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y - aRect.size.height + self.activeField.frame.size.height) animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

@end
