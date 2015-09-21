//
//  MainViewController.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) MainViewModel * viewModel;
@property (nonatomic, strong) UITextField * activeField;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MainViewModel * mainViewModel = [[MainViewModel alloc] init];
    self.viewModel = mainViewModel;
    
    self.materialsViews = [[NSMutableArray alloc] init];
    
    [self registerForKeyboardNotifications];
    [self applyModelToView];
   
    DragElementRecognizer * recognizer = [[DragElementRecognizer alloc] initWithTarget:self action:@selector(handleDragging:)];
    recognizer.delegate = self;
    [self.scrollView addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Is not used I think
- (id) initWithViewModel: (MainViewModel *) mainViewModel {
    self = [super init];
    if (self) {
        self.viewModel = mainViewModel;
        self.materialsViews = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) applyModelToView {
    [[[RACObserve(self.viewModel, exerciseLoaded) distinctUntilChanged] filter:^BOOL(NSNumber * stateExercise) {
        return [stateExercise boolValue];
    }] subscribeNext:^(id x) {
        for (int i = 0; i < self.viewModel.materialsModels.count; i++) {
            [self createMaterialViewWithModel:self.viewModel.materialsModels[i] atIndex: i];
        }
        //dispatch_async(dispatch_get_main_queue(), ^{
            [self displayExercise];
       // });
    }];
}

- (void) displayExercise {
    MaterialView * materialView;
    
    NSUInteger width;
    NSUInteger height;
    NSUInteger x;
    NSUInteger y;
    
    for (materialView in self.materialsViews) {
        width = materialView.viewModel.material.Width;
        height = materialView.viewModel.material.Height;
        x = materialView.viewModel.material.X;
        y = materialView.viewModel.material.Y;
 
        dispatch_async(dispatch_get_main_queue(), ^{
    
        [materialView addVisualToView:self.scrollView];
        
        if ((width + x) > self.scrollView.contentSize.width/2) {
            self.scrollView.contentSize = CGSizeMake((width + x), self.scrollView.frame.size.height);
        }
        if ((height + y) > self.scrollView.contentSize.height/2) {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, (height + y));
        }
    
    //[self.scrollView setNeedsDisplay];
        });
    }
}

- (void) createMaterialViewWithModel:(MaterialViewModel *) materialViewModel atIndex:(NSUInteger) index{
    NSString * type = materialViewModel.material.Type;
    NSLog(@"Creating new view : %@", type);
    
    if ([type isEqualToString:@"Text"] || [type isEqualToString:@"RichText"]) {
        TextFrameView * textLabel = [[TextFrameView alloc] initWithViewModel: materialViewModel];
        self.materialsViews[index] = textLabel;
    }
    else if([type isEqualToString:@"RichText"]) {
        
    }
    else if ([type isEqualToString:@"RadioButton"]) {
        RadioButtonView * radioButton = [[RadioButtonView alloc] initWithViewModel: materialViewModel];
        self.materialsViews[index] = radioButton;
    }
    else if ([type isEqualToString:@"Rectangle"]) {
        RectangleView * rectangle = [[RectangleView alloc] initWithViewModel:materialViewModel];
        self.materialsViews[index] = rectangle;
    }
    else if ([type isEqualToString:@"Image"]) {
        ImageView * image = [[ImageView alloc] initWithViewModel: materialViewModel];
        self.materialsViews[index] = image;
    }
    else if ([type isEqualToString:@"InputField"]) {
        TextInputView * textInput = [[TextInputView alloc] initWithViewModel:materialViewModel];
        textInput.viewDisplayed.delegate = self;
        self.materialsViews[index] = textInput;        
    }
    else if([type isEqualToString:@"Table"]) {
        TableView * table = [[TableView alloc] initWithViewModel:materialViewModel];
        self.materialsViews[index] = table;
    }
    else if([type isEqualToString:@"Audio"]) {
        AudioView * audio = [[AudioView alloc] initWithViewModel:materialViewModel];
        self.materialsViews[index] = audio;
    }
    else if([type isEqualToString:@"CheckBox"]) {
        CheckBoxView * checkBox = [[CheckBoxView alloc] initWithViewModel:materialViewModel];
        self.materialsViews[index] = checkBox;
    }


}

#pragma mark UIRecognizer methods

- (void) handleDragging:(DragElementRecognizer *) recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        // Store the initial touch so when we change positions we do not snap
        recognizer.draggedMaterial.position = [recognizer locationInView:recognizer.view];
        [recognizer.draggedMaterial.viewDisplayed bringSubviewToFront:recognizer.view];
        
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
        if(![self.viewModel.dropController pointIsInTargetElement:recognizer.draggedMaterial.position]) {
            recognizer.draggedMaterial.viewDisplayed.frame = CGRectMake(recognizer.draggedMaterial.viewModel.material.X,
                                                                        recognizer.draggedMaterial.viewModel.material.Y,
                                                                        recognizer.draggedMaterial.viewDisplayed.frame.size.width,
                                                                        recognizer.draggedMaterial.viewDisplayed.frame.size.height);
        }
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(DragElementRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    gestureRecognizer.draggedMaterial = [self touchIsOnDraggableMaterial:touch];
    if (gestureRecognizer.draggedMaterial) {
        return YES;
    }
    return NO;
}

/*Returns the first material view that can be dragged and is found under the touch*/
- (MaterialView *) touchIsOnDraggableMaterial:(UITouch *) touch {
    CGPoint locationTouch = [touch locationInView:self.scrollView];
    NSLog(@"%f and %f", locationTouch.x, locationTouch.y);
    for (MaterialView * element in self.materialsViews) {
        if ([element.viewModel.material.Behavior isEqualToString:@"DropElement"] &&
            CGRectContainsPoint(element.viewDisplayed.frame, locationTouch)) {
            return element;
        }
    }
    return nil;
}

#pragma mark UITextField delegate methods
- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) keyboardWillBeShown: (NSNotification *) aNotification {
    
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

- (void) keyboardWillBeHidden:(NSNotification *) aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField {
    self.activeField = textField;
}


@end
