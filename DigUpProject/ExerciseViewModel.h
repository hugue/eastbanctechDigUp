//
//  ExerciseViewModel.h
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MaterialViewModel.h"
#import "TextInputViewModel.h"
#import "CheckBoxViewModel.h"
#import "ImageViewModel.h"

#import "ExerciseModel.h"
#import "WebController.h"
#import "RadioButtonsController.h"
#import "DragNDropController.h"
#import "AudioController.h"
#import "TestModel.h"

typedef NS_ENUM(NSInteger, ExerciseCurrentState) {
    ExerciseCurrentStateIsStopped,
    ExerciseCurrentStateIsGoingOn
};

typedef NS_ENUM(NSInteger, AudioVolumeInterval) {
    AudioVolumeIntervalMute,
    AudioVolumeIntervalLow,
    AudioVolumeIntervalMedium,
    AudioVolumeIntervalHigh
};

@interface ExerciseViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * materialsModels;
@property (nonatomic, strong) ExerciseModel * currentExercise;

@property (nonatomic, strong) WebController * webController;
@property (nonatomic, strong) NSMutableDictionary<NSString *,RadioButtonsController *> * buttonControllers;
@property (nonatomic, strong) AudioController * audioController;
@property (nonatomic, strong) DragNDropController * dropController;

@property (nonatomic) enum ExerciseCurrentState currentExerciseState;
@property (nonatomic, strong) NSString * mediaURL;

@property (nonatomic) float bottomOfView;
@property (nonatomic) float rightBorderOfView;
@property (nonatomic) NSUInteger maxZPosition;
@property (nonatomic) NSUInteger maxTargetZPosition;

- (id)initWithDataModel:(ExerciseModel *)exerciseModel WebController:(WebController *)webController mediaURL:(NSString *)mediaurl;

- (BOOL)audioBarTapped;
- (void)playPauseAudioChangedOnView;
- (void)volumeAudioChangedOnViewByButton;

- (BOOL)correctionAskedDisplayed:(BOOL)displayCorrection;
- (void)restartExerciseAsked;
- (void)solutionAsked;

- (void)viewWillDisappear;

@end
