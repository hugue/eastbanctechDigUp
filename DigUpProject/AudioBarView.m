//
//  AudioBarView.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "AudioBarView.h"
@interface AudioBarView()

@property (nonatomic, strong) UIButton * playPauseButton;
@property (nonatomic, strong) UISlider * audioTimeSlider;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * volumeButton;
@property (nonatomic, strong) UISlider * volumeSlider;

@end

@implementation AudioBarView

- (id)initWithModel:(AudioController *)audioController atPosition:(CGPoint)position andWidth:(float)width{
    self = [super init];
    if (self) {
        self.position = position;
        self.viewModel = audioController;
        CGRect frame = CGRectMake(position.x, position.y, width, 60);
        self.viewDisplayed = [[UIView alloc] initWithFrame:frame];
        self.viewDisplayed.backgroundColor = [UIColor blueColor];
        [self createControllerBar];
        [self applyModelToView];
    }
    return self;
}

- (void)createControllerBar {
    float positionX = 10.0;
    //Control bar shape
    CGRect mainFrame = self.viewDisplayed.frame;
    CGRect controlAudioBarFrame = CGRectMake(10.0, 5, mainFrame.size.width/1.5, 50);
    self.controlAudioBar = [[UIView alloc] initWithFrame:controlAudioBarFrame];
    self.controlAudioBar.layer.cornerRadius = 10.0;
    self.controlAudioBar.layer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8].CGColor;
    
    CGRect playPauseButtonFrame = CGRectMake(positionX, 0.0, controlAudioBarFrame.size.width/10, controlAudioBarFrame.size.height);
    self.playPauseButton = [[UIButton alloc] initWithFrame:playPauseButtonFrame];
    
    [self.playPauseButton setImage:[UIImage imageNamed:@"Pause_Button"] forState:UIControlStateNormal];
    [self.playPauseButton addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.controlAudioBar addSubview:self.playPauseButton];
    
    //Time slider
    positionX += playPauseButtonFrame.size.width + 10;
    CGRect audioTimeSliderFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/3, controlAudioBarFrame.size.height);
    self.audioTimeSlider = [[UISlider alloc] initWithFrame:audioTimeSliderFrame];
    self.audioTimeSlider.backgroundColor = [UIColor clearColor];
    self.audioTimeSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.audioTimeSlider.maximumTrackTintColor = [UIColor blackColor];
    [self.controlAudioBar addSubview:self.audioTimeSlider];
    
    //TimeLabel
    positionX += audioTimeSliderFrame.size.width + 10;
    CGRect timeLableFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/12, controlAudioBarFrame.size.height);
    self.timeLabel = [[UILabel alloc] initWithFrame:timeLableFrame];
    self.timeLabel.text = @"0:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    [self.controlAudioBar addSubview:self.timeLabel];
    
    //Audio Button
    //positionX += timeLableFrame.size.width + 10;
    CGRect volumeButtonFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/12, controlAudioBarFrame.size.height);
    self.volumeButton = [[UIButton alloc] initWithFrame:volumeButtonFrame];
    [self.volumeButton setImage:[UIImage imageNamed:@"HighVolume"] forState:UIControlStateNormal];
    [self.volumeButton addTarget:self action:@selector(volumeValueChangedByButton:) forControlEvents:UIControlEventTouchDown];
    [self.controlAudioBar addSubview:self.volumeButton];
    
    
    //Audio slider
    positionX += volumeButtonFrame.size.width + 10;
    CGRect volumeSliderFrame = CGRectMake(positionX, 0, controlAudioBarFrame.size.width/5, controlAudioBarFrame.size.height);
    
    self.volumeSlider = [[UISlider alloc] initWithFrame:volumeSliderFrame];
    self.volumeSlider.backgroundColor = [UIColor clearColor];
    self.volumeSlider.maximumValue = 1.0;
    self.volumeSlider.value = 1.0;
    self.volumeSlider.continuous = YES;
    self.volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.volumeSlider.maximumTrackTintColor = [UIColor blackColor];
    [self.volumeSlider addTarget:self action:@selector(volumeValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.controlAudioBar addSubview:self.volumeSlider];


}

- (void)applyModelToView {
    //PlayPause Button
    [RACObserve(self.viewModel, isPlaying) subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self.playPauseButton setImage:[UIImage imageNamed:@"Pause_Button"] forState:UIControlStateNormal];
        }
        else {
            [self.playPauseButton setImage:[UIImage imageNamed:@"Play_Button"] forState:UIControlStateNormal];
        }
    }];
    
    //AudioTime Slider
    RAC(self.audioTimeSlider, maximumValue) = RACObserve(self.viewModel, audioDuration);
    
    RACChannelTerminal * sliderTerminal = [self.audioTimeSlider rac_newValueChannelWithNilValue:@0];
    RACChannelTerminal * modelTerminal = RACChannelTo_(self.viewModel, currentAudioTime, @0);
    
    @weakify(self)
    [[[sliderTerminal doNext:^(id x) {
        @strongify(self)
        [self.viewModel setTimeCurrentAudio:self.audioTimeSlider.value];
    } ]distinctUntilChanged]subscribe:modelTerminal];
    [modelTerminal subscribe:sliderTerminal];
    
    //TimeLabel
    [RACObserve(self.viewModel, currentAudioTime) subscribeNext:^(id x) {
        long minutes = floor([x integerValue]/60);
        long seconds = [x integerValue] - minutes*60;
        self.timeLabel.text = [NSString stringWithFormat:@"%lu:%02lu", minutes, seconds];
    }];
    
    //Audio Button
    [[[RACObserve(self.viewModel, currentAudioVolum) map:^id(id value) {
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
                [self.volumeButton setImage:[UIImage imageNamed:@"HighVolume"] forState:UIControlStateNormal];
                break;
            case AudioVolumeIntervalMedium:
                [self.volumeButton setImage:[UIImage imageNamed:@"MediumVolume"] forState:UIControlStateNormal];
                break;
            case AudioVolumeIntervalLow:
                [self.volumeButton setImage:[UIImage imageNamed:@"LowVolume"] forState:UIControlStateNormal];
                break;
            case AudioVolumeIntervalMute:
                [self.volumeButton setImage:[UIImage imageNamed:@"MuteVolume"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }];
    
    //Volume Slider
    RAC(self.volumeSlider, value) = RACObserve(self.viewModel, currentAudioVolum);
    
    
    //Add the control audio bar only if an audio file is selected
    [RACObserve(self.viewModel, currentlyPlaying) subscribeNext:^(id x) {
        if (x) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.viewDisplayed addSubview:self.controlAudioBar];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.controlAudioBar removeFromSuperview];
            });
        }
    }];

}

- (void)volumeValueChanged:(UISlider *)sender {
    self.viewModel.currentAudioVolum = sender.value;
}

- (void)volumeValueChangedByButton:(UIButton *) sender {
    [self.viewModel volumeAudioChangedOnViewByButton];
}

- (void)playPauseButtonClicked:(UIButton *)sender {
    [self.viewModel playPauseChangedOnView];
}

@end
