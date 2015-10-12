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

typedef NS_ENUM(NSInteger, MainViewModelMode) {
    MainViewModelModeTraining,
    MainViewModelModeExam
};

@interface ExerciseViewModel : NSObject <DataControllerProtocol>

@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * materialsModels;
@property (nonatomic, strong) ExerciseModel * currentExercise;

@property (nonatomic, strong) WebController * webController;
@property (nonatomic, strong) NSMutableDictionary<NSString *,RadioButtonsController *> * buttonControllers;
@property (nonatomic, strong) AudioController * audioController;
@property (nonatomic, strong) DragNDropController * dropController;

@property (nonatomic, strong) NSNumber * exerciseLoaded;
@property (nonatomic) enum ExerciseCurrentState currentExerciseState;
@property (nonatomic) enum MainViewModelMode currentExerciseMode;

@property (nonatomic) float bottomOfView;
@property (nonatomic) float rightBorderOfView;
@property (nonatomic) NSUInteger maxZPosition;
@property (nonatomic) NSUInteger maxTargetZPosition;

- (id)initWithTestModel:(TestModel *)testModel WebController:(WebController *)webController;

- (void)parseExercise;
- (BOOL)audioBarTapped;
- (void)correctionAsked;
- (void)restartExerciseAsked;
- (void)solutionAsked;
- (void)playPauseAudioChangedOnView;
- (void)volumeAudioChangedOnViewByButton;
- (void)fetchExerciseAndDisplay;
- (void)reset;
- (void)viewWillDisappear;

@end
