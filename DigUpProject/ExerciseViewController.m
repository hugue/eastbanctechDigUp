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
//@property (nonatomic) long currentAudioTime;

@end

@implementation ExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Dispose of any resources that can be recreated.
}

- (void)displayExercise {
   dispatch_async(dispatch_get_main_queue(), ^{
       if (self.scrollView.contentSize.width < self.viewModel.rightBorderOfView) {
           self.scrollView.contentSize = CGSizeMake(self.viewModel.rightBorderOfView, self.scrollView.frame.size.height);
       }
       if (self.scrollView.contentSize.height < self.viewModel.bottomOfView + 100) {
           self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.viewModel.bottomOfView + 100);
       }

   });
    
    for (MaterialView * materialView in self.materialsViews) {
         NSLog(@"View Placed");
        dispatch_async(dispatch_get_main_queue(), ^{
            [materialView addVisualToView:self.scrollView];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configureAudioPlayerView];
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


#pragma AudioBar

- (void)configureAudioPlayerView {
    //self.currentAudioTime = 0;
    //Create the audiobar only if there are audio files in the test
    if (self.viewModel.audioController.isNeeded) {
        float positionX = 10.0;
        float extremRight = MAX(self.scrollView.frame.size.width, self.scrollView.contentSize.width);
        //Main Bar
        CGRect mainAudioBarFrame = CGRectMake(0.0, self.viewModel.bottomOfView + 60, extremRight, 60);
        UIView * mainAudioBar = [[UIView alloc] initWithFrame:mainAudioBarFrame];
        mainAudioBar.backgroundColor = [UIColor blueColor];
        
        //Control Bar
        CGRect controlAudioBarFrame = CGRectMake(10.0, 5, mainAudioBarFrame.size.width/1.5, 50);
        UIView * controlAudioBar = [[UIView alloc] initWithFrame:controlAudioBarFrame];
        controlAudioBar.layer.cornerRadius = 10.0;
        controlAudioBar.layer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8].CGColor;
        
        //Play-Pause button
        CGRect playPauseButtonFrame = CGRectMake(positionX, 0.0, controlAudioBarFrame.size.width/10, controlAudioBarFrame.size.height);
        UIButton * playPauseButton = [[UIButton alloc] initWithFrame:playPauseButtonFrame];
        
        [playPauseButton setImage:[UIImage imageNamed:@"Pause_Button"] forState:UIControlStateNormal];
        [playPauseButton addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [RACObserve(self.viewModel, audioController.isPlaying) subscribeNext:^(id x) {
            if ([x boolValue]) {
                [playPauseButton setImage:[UIImage imageNamed:@"Pause_Button"] forState:UIControlStateNormal];
            }
            else {
                [playPauseButton setImage:[UIImage imageNamed:@"Play_Button"] forState:UIControlStateNormal];
            }
        }];
        
        [controlAudioBar addSubview:playPauseButton];
        
        //Time slider
        positionX += playPauseButtonFrame.size.width + 10;
        CGRect audioTimeSliderFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/3, controlAudioBarFrame.size.height);
        UISlider * audioTimeSlider = [[UISlider alloc] initWithFrame:audioTimeSliderFrame];
        audioTimeSlider.backgroundColor = [UIColor clearColor];
        audioTimeSlider.minimumTrackTintColor = [UIColor whiteColor];
        audioTimeSlider.maximumTrackTintColor = [UIColor blackColor];
        
        RAC(audioTimeSlider, maximumValue) = RACObserve(self.viewModel, audioController.audioDuration);
        
        RACChannelTerminal * sliderTerminal = [audioTimeSlider rac_newValueChannelWithNilValue:@0];
        RACChannelTerminal * modelTerminal = RACChannelTo_(self.viewModel.audioController, currentAudioTime, @0);
        
        @weakify(self)
        [[[sliderTerminal doNext:^(id x) {
            @strongify(self)
            [self.viewModel.audioController setTimeCurrentAudio:audioTimeSlider.value];
        } ]distinctUntilChanged]subscribe:modelTerminal];
        
        [modelTerminal subscribe:sliderTerminal];
        
        [controlAudioBar addSubview:audioTimeSlider];
        
        //Time Label
        positionX += audioTimeSliderFrame.size.width + 10;
        CGRect timeLableFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/12, controlAudioBarFrame.size.height);
        UILabel * timeLabel = [[UILabel alloc] initWithFrame:timeLableFrame];
        timeLabel.text = @"0:00";
        timeLabel.textColor = [UIColor whiteColor];
        
        [controlAudioBar addSubview:timeLabel];
        
       [RACObserve(self.viewModel.audioController, currentAudioTime) subscribeNext:^(id x) {
            long minutes = floor([x integerValue]/60);
            long seconds = [x integerValue] - minutes*60;
            dispatch_async(dispatch_get_main_queue(), ^{
                timeLabel.text = [NSString stringWithFormat:@"%lu:%02lu", minutes, seconds];
            });
        }];
        //Volume button
        positionX += timeLableFrame.size.width + 10;
        CGRect volumeButtonFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/12, controlAudioBarFrame.size.height);
        UIButton * volumeButton = [[UIButton alloc] initWithFrame:volumeButtonFrame];
        [volumeButton setImage:[UIImage imageNamed:@"HighVolume"] forState:UIControlStateNormal];
        
        [[[RACObserve(self.viewModel, audioController.currentAudioVolum) map:^id(id value) {
            if ([value floatValue] == 0) {
                return @(AudioVolumeIntervalMute);
            }
            else if (([value floatValue] <= 0.75) && ([value floatValue] > 0.35)) {
                return @(AudioVolumeIntervalMedium);
            }
            else if (([value floatValue] <= 0.35) && ([value floatValue] > 0)) {
                return @(AudioVolumeIntervalLow);
            }
            else {
                return @(AudioVolumeIntervalHigh);
            }
        }
           ] distinctUntilChanged] subscribeNext:^(id x) {
            switch ([x integerValue]) {
                case AudioVolumeIntervalHigh:
                    [volumeButton setImage:[UIImage imageNamed:@"HighVolume"] forState:UIControlStateNormal];
                    break;
                case AudioVolumeIntervalMedium:
                    [volumeButton setImage:[UIImage imageNamed:@"MediumVolume"] forState:UIControlStateNormal];
                    break;
                case AudioVolumeIntervalLow:
                    [volumeButton setImage:[UIImage imageNamed:@"LowVolume"] forState:UIControlStateNormal];
                    break;
                case AudioVolumeIntervalMute:
                    [volumeButton setImage:[UIImage imageNamed:@"MuteVolume"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }];
        [volumeButton addTarget:self action:@selector(volumeValueChangedByButton:) forControlEvents:UIControlEventTouchDown];
        [controlAudioBar addSubview:volumeButton];
        
        //Volume slider
        positionX += volumeButtonFrame.size.width + 10;
        CGRect volumeSliderFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/5, controlAudioBarFrame.size.height);
        
        UISlider * volumeSlider = [[UISlider alloc] initWithFrame:volumeSliderFrame];
        volumeSlider.backgroundColor = [UIColor clearColor];
        volumeSlider.maximumValue = 1.0;
        volumeSlider.value = 1.0;
        volumeSlider.continuous = YES;
        volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
        volumeSlider.maximumTrackTintColor = [UIColor blackColor];
        [volumeSlider addTarget:self action:@selector(volumeValueChanged:) forControlEvents:UIControlEventValueChanged];
        RAC(volumeSlider, value) = RACObserve(self.viewModel, audioController.currentAudioVolum);
        
        [controlAudioBar addSubview:volumeSlider];
        
        [self.scrollView addSubview:mainAudioBar];
        
        //Add the control audio bar only if an audio file is selected
        [RACObserve(self.viewModel, audioController.currentlyPlaying) subscribeNext:^(id x) {
            if (x) {
                [mainAudioBar addSubview:controlAudioBar];
            }
            else {
                [controlAudioBar removeFromSuperview];
            }
        }];
    }
}

- (void)volumeValueChanged:(UISlider *)sender {
    self.viewModel.audioController.currentAudioVolum = sender.value;
}

- (void)volumeValueChangedByButton:(UIButton *) sender {
    [self.viewModel volumeAudioChangedOnViewByButton];
}

- (void)playPauseButtonClicked:(UIButton *)sender {
    [self.viewModel playPauseAudioChangedOnView];
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
