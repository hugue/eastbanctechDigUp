//
//  MainViewModel.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MainViewModel.h"
@interface MainViewModel ()

@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * selfCorrectingMaterials;
@property (nonatomic, strong) NSString * exerciseURL;
@property (nonatomic, strong) NSString * mediaURL;

@end

@implementation MainViewModel

- (id)initWithTestModel:(TestModel *)testModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        [self initialize];
        self.exerciseURL = testModel.urlExercise;
        self.mediaURL = testModel.urlMedia;
        self.webController = webController;
    }
    return self;
}

- (void)initialize {
    self.exerciseLoaded = @NO;
    
    self.maxZPosition = 0;
    self.maxTargetZPosition = 0;
    self.bottomOfView = 0;
    self.rightBorderOfView = 0;
    
    //self.webSearcherController  = [[WebSearcherController alloc] init];
    //self.webSearcherController.delegate = self;
    self.buttonControllers = [[NSMutableDictionary alloc] init];
    self.materialsModels = [[NSMutableArray alloc] init];
    self.selfCorrectingMaterials = [[NSMutableArray alloc] init];
    self.dropController = [[DragNDropController alloc] init];
    self.audioController = [[AudioController alloc] init];
}

- (void)reset {
    [self initialize];
}

- (void)viewWillDisappear {
    //[self.webSearcherController releaseWebSession];
    [self.audioController releaseAudioTimer];
}

- (void)fetchExerciseAndDisplay {
    //[self.webSearcherController launchSession];
    [self.webController addTaskForObject:self toURL:self.exerciseURL];
}

- (ExerciseModel *)LoadDataFromFile:(NSString *)fileName {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSError * error;
    NSData * data = [[NSData  alloc] initWithContentsOfFile:filePath options:kNilOptions error:&error];
    if(error) {
        NSLog(@"Error : %@", error);
        return nil;
    }
    ExerciseModel * exercise = [[ExerciseModel alloc] initWithData:data error: &error];
    if(error) {
        NSLog(@"Error : %@", error);
        return nil;
    }
    return exercise;
}


- (MaterialViewModel *)createMaterialViewModelWithModel:(MaterialModel *)materialModel{
    
    NSString * type = materialModel.Type;
    MaterialViewModel * materialViewModel;
    if ([type isEqualToString:@"Text"]) {
        materialViewModel = [[MaterialViewModel alloc] initWithModel:materialModel];
    }
    else if ([type isEqualToString:@"RadioButton"]) {
        RadioButtonViewModel * materialViewModel = [[RadioButtonViewModel alloc] initWithModel:materialModel];
        RadioButtonsController * newButtonController;
        
        //First button created for that group ID
        if (self.buttonControllers[materialViewModel.groupID] == nil) {
            newButtonController = [[RadioButtonsController alloc] init];
            [self.buttonControllers setObject:newButtonController forKey:materialViewModel.groupID];
        }
        //The group already exists, just add the button
        else {
            newButtonController = self.buttonControllers[materialViewModel.groupID];
        }
        [newButtonController addNewRadioButton:materialViewModel];
        [self processDragNDropElement:materialViewModel];
        [self.selfCorrectingMaterials addObject:materialViewModel];
        
        return materialViewModel;
    }
    else if ([type isEqualToString:@"Rectangle"]) {
        materialViewModel = [[MaterialViewModel alloc] initWithModel:materialModel];
    }
    else if ([type isEqualToString:@"Image"]) {
        materialViewModel = [[ImageViewModel alloc] initWithModel:materialModel];
        //[self.webSearcherController registerNewViewToDownloadMedia:materialViewModel forBlobId:materialViewModel.material.BlobId];
        [self.webController addTaskForObject:materialViewModel toURL:[materialViewModel makeDownloadURLFormURL:self.mediaURL]];
    }
    else if ([type isEqualToString:@"InputField"]) {
        materialViewModel = [[TextInputViewModel alloc] initWithModel:materialModel];
        [self.selfCorrectingMaterials addObject:materialViewModel];
    }
    else if ([type isEqualToString:@"Audio"]) {
        materialViewModel = [[AudioViewModel alloc] initWithModel:materialModel];
        [self.audioController addNewAudio:(AudioViewModel *) materialViewModel];
        [self.selfCorrectingMaterials addObject:materialViewModel];
        //[self.webSearcherController registerNewViewToDownloadMedia:materialViewModel forBlobId:materialViewModel.material.BlobId];
        [self.webController addTaskForObject:materialViewModel toURL:[materialViewModel makeDownloadURLFormURL:self.mediaURL]];
    }
    else if([type isEqualToString:@"CheckBox"]) {
        materialViewModel = [[CheckBoxViewModel alloc] initWithModel:materialModel];
        [self.selfCorrectingMaterials addObject:materialViewModel];
    }

    else {
        NSLog(@"Exercise do not conform to the expected standard");
    }
    
    [self processDragNDropElement:materialViewModel];
    
    //This attribute is needed to place the audio bar and correction buttons at the right place
    if (self.bottomOfView < (materialViewModel.materialHeight + materialViewModel.position.y)) {
        self.bottomOfView = (materialViewModel.materialHeight + materialViewModel.position.y);
    }
    if (self.rightBorderOfView < (materialViewModel.materialWidth + materialViewModel.position.x)) {
        self.rightBorderOfView = (materialViewModel.materialWidth + materialViewModel.position.x);
    }
    return materialViewModel;
    
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
    //[self.webSearcherController launchDownloadingMediaSession];
    self.exerciseLoaded = @YES;
    self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
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
#pragma mark - Functions to process the different phases of the test (testing/Correction/solution)

- (void)restartExerciseAsked {
    self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
    [self.audioController restartAsked];
    [self restartingDragNDrop];
    [self restartingSelfCorrectingMaterials];
}

- (void)correctionAsked {
    self.currentExerciseState = ExerciseCurrentStateCorrectionAsked;
    [self.audioController stopCurrentAudio];
    [self correctingDragNDrop];
    [self correctingSelfCorrectingMaterials];
}

- (void)solutionAsked {
    self.currentExerciseState = ExerciseCurrentStateSolutionAsked;
    [self displayingSolutionForDragNDrop];
    [self displayingSolutionSelfCorrectingMaterials];
}

//Correcting functions for different materials
//DragNDrop
- (void)correctingDragNDrop {
    [self.dropController correctionAsked];
}

- (void)restartingDragNDrop {
    [self.dropController restartAsked];
}

- (void)displayingSolutionForDragNDrop {
    [self.dropController solutionAsked];
}

//Make correction for self correcting materials (Checkbox, textField...)
- (void)correctingSelfCorrectingMaterials {
    for (MaterialViewModel * materialViewModel in self.selfCorrectingMaterials) {
        [materialViewModel correctionAsked];
    }
}

- (void)displayingSolutionSelfCorrectingMaterials {
    for (MaterialViewModel * materialViewModel in self.selfCorrectingMaterials) {
        [materialViewModel solutionAsked];
    }
}

- (void)restartingSelfCorrectingMaterials {
    for (MaterialViewModel * materialViewModel in self.selfCorrectingMaterials) {
        [materialViewModel restartAsked];
    }
}
#pragma mark - WebSearcherControllerDelegate Methods

- (void)webSearcherController:(WebSearcherController *)webSearcherController didReceiveData:(nullable NSData *)data withError: (nullable NSError *) error{
    if (error) {
        NSLog(@"Connection stopped with error : %@", error);
    }
    else {
        NSError * initError;
        self.currentExercise = [[ExerciseModel alloc] initWithData:data error: &initError];
        
        if(error) {
            NSLog(@"Error : %@", error);
        }
        [self parseExercise];
    }
}

#pragma mark - DataControllerProtocol methods

- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    if (error) {
        NSLog(@"Error upon reciving exercise in MainViewModel - %@", error);
    }
    else {
        NSError * initError;
        self.currentExercise = [[ExerciseModel alloc] initWithData:data error: &initError];
        
        if(error) {
            NSLog(@"Error upon parsing exercise - %@", error);
        }
        [self parseExercise];
    }
}

@end
