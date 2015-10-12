//
//  ExerciseViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExerciseViewModel.h"

@interface ExerciseViewModel()


@end

@implementation ExerciseViewModel

- (id)initWithDataModel:(ExerciseModel *)exerciseModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        [self initialize];
        self.webController = webController;
        self.currentExercise = exerciseModel;
        [self parseExercise];
    }
    return self;
}

- (void)initialize {
    self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
    
    self.maxZPosition = 0;
    self.maxTargetZPosition = 0;
    self.bottomOfView = 0;
    self.rightBorderOfView = 0;
    
    self.buttonControllers = [[NSMutableDictionary alloc] init];
    self.materialsModels = [[NSMutableArray alloc] init];
    self.dropController = [[DragNDropController alloc] init];
    self.audioController = [[AudioController alloc] init];
}

- (void)parseExercise {
    if (self.currentExercise == nil) {
        NSLog(@"Error, no exercise found");
        return;
    }
    NSUInteger numberMaterials = self.currentExercise.materialsObject.count;
    for (int i = 0; i < numberMaterials; i++) {
        MaterialViewModel * materialViewModel = [self createMaterialViewModelWithModel:self.currentExercise.materialsObject[i]];
        [self.materialsModels addObject:materialViewModel];
    }
    @weakify(self)
        [RACObserve(self, currentExerciseState) subscribeNext:^(id x) {
        @strongify(self)
        MaterialViewModel * materialViewModel;
        switch ([x integerValue]) {
            case ExerciseCurrentStateIsStopped:
                for (materialViewModel in self.materialsModels) {
                    materialViewModel.materialState = MaterialCurrentStateStopped;
                }
                break;
            case ExerciseCurrentStateIsGoingOn:
                for (materialViewModel in self.materialsModels) {
                    materialViewModel.materialState = MaterialCurrentStateGoingOn;
                }
                break;
            default:
                break;
        }
        
    }];
}

- (MaterialViewModel *)createMaterialViewModelWithModel:(MaterialModel *)materialModel{
    
    NSString * type = materialModel.Type;
    MaterialViewModel * materialViewModel;
    if ([type isEqualToString:@"Text"]) {
        materialViewModel = [[MaterialViewModel alloc] initWithModel:materialModel];
    }
    else if ([type isEqualToString:@"RadioButton"]) {
        RadioButtonViewModel * buttonViewModel = [[RadioButtonViewModel alloc] initWithModel:materialModel];
        RadioButtonsController * newButtonController;
        
        //First button created for that group ID
        if (self.buttonControllers[buttonViewModel.groupID] == nil) {
            newButtonController = [[RadioButtonsController alloc] init];
            [self.buttonControllers setObject:newButtonController forKey:buttonViewModel.groupID];
        }
        //The group already exists, just add the button
        else {
            newButtonController = self.buttonControllers[buttonViewModel.groupID];
        }
        [newButtonController addNewRadioButton:buttonViewModel];
        [self processDragNDropElement:buttonViewModel];
        
        return buttonViewModel;
    }
    else if ([type isEqualToString:@"Rectangle"]) {
        materialViewModel = [[MaterialViewModel alloc] initWithModel:materialModel];
    }
    else if ([type isEqualToString:@"Image"]) {
        ImageViewModel * imageViewModel = [[ImageViewModel alloc] initWithModel:materialModel];
        [self.webController addTaskForObject:imageViewModel toURL:[imageViewModel makeDownloadURLFormURL:self.mediaURL]];
        //RACSignal * imageLoadedSignal = RACObserve(imageViewModel, imageLoaded);
        [self processDragNDropElement:imageViewModel];
        [self updateViewBordersWithMaterial:imageViewModel];
        return imageViewModel;
    }
    else if ([type isEqualToString:@"InputField"]) {
        materialViewModel = [[TextInputViewModel alloc] initWithModel:materialModel];
    }
    else if ([type isEqualToString:@"Audio"]) {
        AudioViewModel * audioViewModel = [[AudioViewModel alloc] initWithModel:materialModel];
        [self.audioController addNewAudio:audioViewModel];
        [self.webController addTaskForObject:audioViewModel toURL:[audioViewModel makeDownloadURLFormURL:self.mediaURL]];
        //RACSignal * audioLoadedSignal = RACObserve(audioViewModel, audioLoaded);
        [self processDragNDropElement:audioViewModel];
        [self updateViewBordersWithMaterial:audioViewModel];
        return audioViewModel;
    }
    else if([type isEqualToString:@"CheckBox"]) {
        materialViewModel = [[CheckBoxViewModel alloc] initWithModel:materialModel];
    }
    
    else {
        NSLog(@"Exercise do not conform to the expected standard");
    }
    
    [self processDragNDropElement:materialViewModel];
    [self updateViewBordersWithMaterial:materialViewModel];
    
    return materialViewModel;    
}

- (void)updateViewBordersWithMaterial:(MaterialViewModel *)materialViewModel {
    //This attribute is needed to place the audio bar and correction buttons at the right place
    if (self.bottomOfView < (materialViewModel.materialHeight + materialViewModel.position.y)) {
        self.bottomOfView = (materialViewModel.materialHeight + materialViewModel.position.y);
    }
    if (self.rightBorderOfView < (materialViewModel.materialWidth + materialViewModel.position.x)) {
        self.rightBorderOfView = (materialViewModel.materialWidth + materialViewModel.position.x);
    }
}

- (void)volumeAudioChangedOnViewByButton {
    if (self.audioController.currentAudioVolum == 0) {
        self.audioController.currentAudioVolum = 1.0;
    }
    else {
        self.audioController.currentAudioVolum = 0;
    }
}

- (void)playPauseAudioChangedOnView {
    if (self.currentExerciseState == ExerciseCurrentStateIsGoingOn) {
        [self.audioController playPauseChangedOnView];
    }
}

- (void)processDragNDropElement:(MaterialViewModel *) materialViewModel {
    if ([materialViewModel.material.Behavior isEqualToString:@"DropTarget"]){
        [self.dropController.targetElements setObject:materialViewModel forKey:materialViewModel.materialID];
        if (self.maxTargetZPosition < materialViewModel.zPosition) {
            self.maxTargetZPosition = materialViewModel.zPosition;
        }
    }
    else if([materialViewModel.material.Behavior isEqualToString:@"DropElement"]) {
        [self.dropController.dropElements addObject:materialViewModel];
    }
    
    if (self.maxZPosition < materialViewModel.zPosition) {
        self.maxZPosition = materialViewModel.zPosition;
    }
}

- (BOOL)audioBarTapped {
    if (self.audioController.currentlyPlaying.audioPlayer.playing) {
        [self.audioController.currentlyPlaying.audioPlayer pause];
        return NO;
    }
    else {
        [self.audioController.currentlyPlaying.audioPlayer play];
        return YES;
    }
}

#pragma mark - Correction methods
- (BOOL)correctionAskedDisplayed:(BOOL)displayCorrection {
    self.currentExerciseState = ExerciseCurrentStateIsStopped;
    return NO;
}

- (void)solutionAsked {
    
}

- (void)restartExerciseAsked {
    self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
}

@end
