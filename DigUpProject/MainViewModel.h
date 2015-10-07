//
//  MainViewModel.h
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialViewModel.h"
#import "TextInputViewModel.h"
#import "CheckBoxViewModel.h"
#import "ImageViewModel.h"

#import "ExerciseModel.h"
#import "WebSearcherController.h"
#import "ExerciseCorrector.h"
#import "RadioButtonsController.h"
#import "DragNDropController.h"
#import "AudioController.h"

typedef NS_ENUM(NSInteger, ExerciseCurrentState) {
    ExerciseCurrentStateIsGoingOn,
    ExerciseCurrentStateCorrectionAsked,
    ExerciseCurrentStateSolutionAsked
};

typedef NS_ENUM(NSInteger, AudioVolumeInterval) {
    AudioVolumeIntervalMute,
    AudioVolumeIntervalLow,
    AudioVolumeIntervalMedium,
    AudioVolumeIntervalHigh
};

@interface MainViewModel : NSObject <WebSearcherControllerDelegate>

@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * materialsModels;
@property (nonatomic, strong) WebSearcherController * webSearcherController;
@property (nonatomic, strong) ExerciseModel * currentExercise;
@property (nonatomic, strong) ExerciseCorrector * corrector;
@property (nonatomic, strong) NSMutableDictionary<NSString *,RadioButtonsController *> * buttonControllers;
@property (nonatomic, strong) AudioController * audioController;
@property (nonatomic, strong) DragNDropController * dropController;
@property (nonatomic, strong) NSNumber * exerciseLoaded;
@property (nonatomic) enum ExerciseCurrentState currentExerciseState;

@property (nonatomic) float bottomOfView;
@property (nonatomic) float rightBorderOfView;

@property (nonatomic) NSUInteger maxZPosition;
@property (nonatomic) NSUInteger maxTargetZPosition;

- (void)parseExercise;
- (BOOL)audioBarTapped;
- (void)correctionAsked;
- (void)restartExerciseAsked;
- (void)solutionAsked;
- (void)playPauseAudioChangedOnView;
- (void)volumeAudioChangedOnViewByButton;

@end
