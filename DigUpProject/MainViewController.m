//
//  MainViewController.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MainViewController.h"

#import <ReactiveCocoa/RACEXTScope.h>

@interface MainViewController ()

@property (nonatomic, strong) MainViewModel * viewModel;
@property (nonatomic, strong) UITextField * activeField;
@property (nonatomic) long currentAudioTime;

@property (nonatomic, strong) UIButton * playPauseButton;

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
- (id)initWithViewModel:(MainViewModel *)mainViewModel {
    self = [super init];
    if (self) {
        self.viewModel = mainViewModel;
        self.materialsViews = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)applyModelToView {
    @weakify(self);
    [[[RACObserve(self.viewModel, exerciseLoaded) distinctUntilChanged] filter:^BOOL(NSNumber * stateExercise) {
        return [stateExercise boolValue];
    }] subscribeNext:^(id x) {
        @strongify(self)
        for (int i = 0; i < self.viewModel.materialsModels.count; i++) {
            [self createMaterialViewWithModel:self.viewModel.materialsModels[i] atIndex: i];
        }
            [self displayExercise];
    }];
}

- (void)displayExercise {
    MaterialView * materialView;
    
    NSUInteger width;
    NSUInteger height;
    NSUInteger x;
    NSUInteger y;
    
    for (materialView in self.materialsViews) {
        width = materialView.viewModel.materialWidth;
        height = materialView.viewModel.materialHeight;
        x = materialView.viewModel.position.x;
        y = materialView.viewModel.position.y;
 
        dispatch_async(dispatch_get_main_queue(), ^{
    
            [materialView addVisualToView:self.scrollView];
        
            if ((width + x) > self.scrollView.contentSize.width) {
                self.scrollView.contentSize = CGSizeMake((width + x), self.scrollView.frame.size.height);
            }
            if ((height + y) > self.scrollView.contentSize.height) {
                self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, (height + y));
            }
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configureAudioPlayerView];
        [self addCorrectionButtons];
    });
}

- (void)createMaterialViewWithModel:(MaterialViewModel *)materialViewModel atIndex:(NSUInteger)index {
    NSString * type = materialViewModel.material.Type;
    NSLog(@"Creating new view : %@", type);
    
    if ([type isEqualToString:@"Text"]) {
        TextFrameView * textLabel = [[TextFrameView alloc] initWithViewModel: materialViewModel];
        self.materialsViews[index] = textLabel;
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
    else if([type isEqualToString:@"Audio"]) {
        AudioView * audio = [[AudioView alloc] initWithViewModel:materialViewModel];
        self.materialsViews[index] = audio;
    }
    else if([type isEqualToString:@"CheckBox"]) {
        CheckBoxView * checkBox = [[CheckBoxView alloc] initWithViewModel:materialViewModel];
        self.materialsViews[index] = checkBox;
    }
}

#pragma AudioBar

- (void)configureAudioPlayerView {
    self.currentAudioTime = 0;
    //Create the audiobar only if there are audio files in the test
    if (self.viewModel.audioController.audioPlayers.count > 0) {
        //Main Bar
        CGRect mainAudioBarFrame = CGRectMake(0.0, self.scrollView.frame.size.height - 80, self.scrollView.frame.size.width, 60);
        UIView * mainAudioBar = [[UIView alloc] initWithFrame:mainAudioBarFrame];
        mainAudioBar.backgroundColor = [UIColor blueColor];
    
        //Control Bar
        CGRect controlAudioBarFrame = CGRectMake(10.0, 5, 500, 50);
        UIView * controlAudioBar = [[UIView alloc] initWithFrame:controlAudioBarFrame];
        controlAudioBar.layer.cornerRadius = 20.0;
        controlAudioBar.layer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8].CGColor;
    
        //Play-Pause button
        CGRect playPauseButtonFrame = CGRectMake(0.0, 0.0, 50,controlAudioBarFrame.size.height);
        self.playPauseButton = [[UIButton alloc] initWithFrame:playPauseButtonFrame];
    
        [self.playPauseButton setImage:[UIImage imageNamed:@"Pause_Button"] forState:UIControlStateNormal];
        [self.playPauseButton addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchDown];
        self.playPauseButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
        [controlAudioBar addSubview:self.playPauseButton];
    
        //Time slider
        CGRect audioTimeSliderFrame = CGRectMake(55, 0, 200, controlAudioBarFrame.size.height);
        UISlider * audioTimeSlider = [[UISlider alloc] initWithFrame:audioTimeSliderFrame];
        audioTimeSlider.backgroundColor = [UIColor clearColor];
        
        RAC(audioTimeSlider, maximumValue) = RACObserve(self.viewModel.audioController, audioDuration);
    
        RACChannelTerminal * sliderTerminal = [audioTimeSlider rac_newValueChannelWithNilValue:@0];
        RACChannelTerminal * modelTerminal = RACChannelTo_(self.viewModel.audioController, currentAudioTime, @0);
   
        @weakify(self);
        [[[sliderTerminal doNext:^(id x) {
            @strongify(self);
            [self.viewModel.audioController setTimeCurrentAudio:audioTimeSlider.value];
        } ]distinctUntilChanged]subscribe:modelTerminal];
        
        [modelTerminal subscribe:sliderTerminal];
    
        [controlAudioBar addSubview:audioTimeSlider];
    
        //Time Label
        CGRect timeLableFrame = CGRectMake(260, 0, 75, controlAudioBarFrame.size.height);
        UILabel * timeLabel = [[UILabel alloc] initWithFrame:timeLableFrame];
        timeLabel.text = @"0:00";
        timeLabel.textColor = [UIColor whiteColor];
    
        [controlAudioBar addSubview:timeLabel];
    
        RAC(self, currentAudioTime) = [RACObserve(self.viewModel.audioController, currentAudioTime) doNext:^(id x) {
            @strongify(self);
            long minutes = floor(self.currentAudioTime/60);
            long seconds = self.currentAudioTime - minutes*60;
        
            dispatch_async(dispatch_get_main_queue(), ^{
                timeLabel.text = [NSString stringWithFormat:@"%lu:%02lu", minutes, seconds];
            });
        }];
    
        //Volum slider
        CGRect volumeSliderFrame = CGRectMake(340, 0, 150, controlAudioBarFrame.size.height);
   
        UISlider * volumeSlider = [[UISlider alloc] initWithFrame:volumeSliderFrame];
        volumeSlider.backgroundColor = [UIColor clearColor];
        volumeSlider.maximumValue = 1.0;
        volumeSlider.value = 1.0;
        volumeSlider.continuous = YES;
        [volumeSlider addTarget:self action:@selector(volumeValueChanged:) forControlEvents:UIControlEventValueChanged];
        RAC(volumeSlider, value) = RACObserve(self.viewModel.audioController, currentAudioVolum);
    
        [controlAudioBar addSubview:volumeSlider];
    
        [mainAudioBar addSubview:controlAudioBar];
        [self.scrollView addSubview:mainAudioBar];

    }
    
}

- (void)volumeValueChanged:(UISlider *)sender {
    self.viewModel.audioController.currentAudioVolum = sender.value;
}

- (void)playPauseButtonClicked:(UIButton *)sender {
    BOOL isPlaying = [self.viewModel audioBarTapped];
    if(isPlaying) {
        [self.playPauseButton setImage:[UIImage imageNamed:@"Pause_Button"] forState:UIControlStateNormal];
    }
    else {
        [self.playPauseButton setImage:[UIImage imageNamed:@"Play_Button"] forState:UIControlStateNormal];
    }
}

- (void)addCorrectionButtons {
    //Button Right?
    CGRect correctionButtonFrame = CGRectMake((self.scrollView.frame.size.width - 80.0), (self.scrollView.frame.size.height - 130.0) , 70.0, 40.0);
    UIButton * correctionButton = [[UIButton alloc] initWithFrame:correctionButtonFrame];
    
    [correctionButton.titleLabel setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:18]];
    [correctionButton setTitle:@"Right?" forState:UIControlStateNormal];
    [correctionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    correctionButton.layer.borderColor = [UIColor blueColor].CGColor;
    correctionButton.layer.borderWidth = 1.0f;
    
    [correctionButton addTarget:self action:@selector(correctionAsked:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:correctionButton];
    
    //Button Once again
    CGRect restartButtonFrame = CGRectMake((self.scrollView.frame.size.width - 290.0), (self.scrollView.frame.size.height - 130.0) , 80.0, 40.0);
    UIButton * restartButton = [[UIButton alloc] initWithFrame:restartButtonFrame];
    
    [restartButton.titleLabel setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:18]];
    [restartButton setTitle:@"Once again" forState:UIControlStateNormal];
    [restartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    restartButton.layer.borderColor = [UIColor blueColor].CGColor;
    restartButton.layer.borderWidth = 1.0f;
    
    //Button Solution
    CGRect solutionButtonFrame = CGRectMake((self.scrollView.frame.size.width - 190.0), (self.scrollView.frame.size.height - 130.0) , 100.0, 40.0);
    UIButton * solutionButton = [[UIButton alloc] initWithFrame:solutionButtonFrame];
    
    [solutionButton.titleLabel setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:18]];
    [solutionButton setTitle:@"Solution" forState:UIControlStateNormal];
    [solutionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    solutionButton.layer.borderColor = [UIColor blueColor].CGColor;
    solutionButton.layer.borderWidth = 1.0f;
    
    //Signal to display the buttons at the right time (not when testing)
    [RACObserve(self.viewModel, currentExerciseState) subscribeNext:^(id x) {
        if ([x integerValue] == testingGoingOn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [solutionButton removeFromSuperview];
                [restartButton removeFromSuperview];
            });
        }
        else if ([x integerValue] == correctionAsked) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scrollView addSubview:solutionButton];
                [self.scrollView addSubview:restartButton];
            });
        }
    }];
}

- (void)correctionAsked:(UIButton *)sender {
    [self.viewModel correctionAsked];
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
            recognizer.draggedMaterial.viewDisplayed.frame = CGRectMake([recognizer.draggedMaterial.viewModel.material.X floatValue],
                                                                        [recognizer.draggedMaterial.viewModel.material.Y floatValue],
                                                                        recognizer.draggedMaterial.viewDisplayed.frame.size.width,
                                                                        recognizer.draggedMaterial.viewDisplayed.frame.size.height);
            
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
    if (gestureRecognizer.draggedMaterial) {
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
