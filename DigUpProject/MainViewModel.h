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

#import "ExerciceModel.h"
#import "WebSearcherController.h"
#import "ExerciseCorrector.h"
#import "RadioButtonsController.h"
#import "DragNDropController.h"
#import "AudioController.h"

enum TestState : NSUInteger {
    testingGoingOn = 0,
    correctionAsked = 1
};

@interface MainViewModel : NSObject <WebSearcherControllerDelegate>

@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * materialsModels;
@property (nonatomic, strong) WebSearcherController * webSearcherController;
@property (nonatomic, strong) ExerciceModel * currentExercise;
@property (nonatomic, strong) ExerciseCorrector * corrector;
@property (nonatomic, strong) NSMutableDictionary<NSString *,RadioButtonsController *> * buttonControllers;
@property (nonatomic, strong) AudioController * audioController;
@property (nonatomic, strong) DragNDropController * dropController;
@property (nonatomic, strong) NSNumber * exerciseLoaded;
@property (nonatomic) enum TestState currentExerciseState;

@property (nonatomic) NSUInteger maxZPosition;
@property (nonatomic) NSUInteger maxTargetZPosition;

- (void)parseExercise;
- (BOOL)audioBarTapped;
- (void)correctionAsked;

@end
