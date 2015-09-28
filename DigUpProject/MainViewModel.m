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

@end

@implementation MainViewModel

- (id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.exerciseLoaded = @NO;
    
    self.maxZPosition = 0;
    self.maxTargetZPosition = 0;
    
    self.webSearcherController  = [[WebSearcherController alloc] init];
    self.webSearcherController.delegate = self;
    self.buttonControllers = [[NSMutableDictionary alloc] init];
    self.materialsModels = [[NSMutableArray alloc] init];
    self.selfCorrectingMaterials = [[NSMutableArray alloc] init];
    self.dropController = [[DragNDropController alloc] init];
    self.audioController = [[AudioController alloc] init];
    
    [self.webSearcherController launchSession];
}

- (ExerciceModel *)LoadDataFromFile:(NSString *)fileName {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSError * error;
    NSData * data = [[NSData  alloc] initWithContentsOfFile:filePath options:kNilOptions error:&error];
    if(error) {
        NSLog(@"Error : %@", error);
        return nil;
    }
    ExerciceModel * exercise = [[ExerciceModel alloc] initWithData:data error: error];
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
        //return materialViewModel;
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
        return materialViewModel;
    }
    else if ([type isEqualToString:@"Rectangle"]) {
        materialViewModel = [[MaterialViewModel alloc] initWithModel:materialModel];
        //return materialViewModel;
    }
    else if ([type isEqualToString:@"Image"]) {
        materialViewModel = [[ImageViewModel alloc] initWithModel:materialModel];
        //return materialViewModel;
    }
    else if ([type isEqualToString:@"InputField"]) {
        materialViewModel = [[TextInputViewModel alloc] initWithModel:materialModel];
        [self.selfCorrectingMaterials addObject:materialViewModel];
        //return materialViewModel;
    }
    else if ([type isEqualToString:@"Audio"]) {
        materialViewModel = [[AudioViewModel alloc] initWithModel:materialModel];
        [self.audioController addNewAudio:(AudioViewModel *) materialViewModel];
    }
    else if([type isEqualToString:@"CheckBox"]) {
        materialViewModel = [[CheckBoxViewModel alloc] initWithModel:materialModel];
        [self.selfCorrectingMaterials addObject:materialViewModel];
        //return materialViewModel;
    }

    else {
        NSLog(@"Exercise do not conform to the expected standard");
    }
    
    [self processDragNDropElement:materialViewModel];
    
    return materialViewModel;
    
}

- (void)parseExercise {
    if (self.currentExercise == nil) {
        NSLog(@"Error, no exercise found");
        return;
    }
    NSUInteger numberMaterials = self.currentExercise.materialsObject.count;
   // [self.materialsModels removeAllObjects];
    for (int i = 0; i < numberMaterials; i++) {
        MaterialViewModel * materialViewModel = [self createMaterialViewModelWithModel:self.currentExercise.materialsObject[i]];
        [self.materialsModels addObject:materialViewModel];
    }
    self.exerciseLoaded = @YES;
    self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
}

- (BOOL)audioBarTapped {
    if (self.audioController.audioPlayers[self.audioController.beingPlayedID].audioPlayer.playing) {
        [self.audioController.audioPlayers[self.audioController.beingPlayedID].audioPlayer pause];
        return NO;
    }
    else {
        [self.audioController.audioPlayers[self.audioController.beingPlayedID].audioPlayer play];
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
    [self restartingButtonsControllers];
    //[self restartingCheckBoxes];
    [self restartingDragNDrop];
    [self restartingSelfCorrectingMaterials];
}

- (void)correctionAsked {
    self.currentExerciseState = ExerciseCurrentStateCorrectionAsked;
    [self correctingButtonsControllers];
    //[self correctingCheckBoxes];
    [self correctingDragNDrop];
    [self correctingSelfCorrectingMaterials];
}

- (void)solutionAsked {
    self.currentExerciseState = ExerciseCurrentStateSolutionAsked;
    [self displayingSolutionForButtonsControllers];
    //[self displayingSolutionForCheckboxes];
    [self displayingSolutionForDragNDrop];
    [self displayingSolutionSelfCorrectingMaterials];
}

//Correcting functions for different materials
//Radio Buttons
- (void)correctingButtonsControllers {
    for (NSString * controllerID in self.buttonControllers.allKeys) {
        [self.buttonControllers[controllerID] correctionAsked];
    }
}

- (void)restartingButtonsControllers {
    for (NSString * controllerID in self.buttonControllers.allKeys) {
        [self.buttonControllers[controllerID] restartAsked];
    }
}

- (void)displayingSolutionForButtonsControllers {
    for (NSString * controllerID in self.buttonControllers.allKeys) {
        [self.buttonControllers[controllerID] solutionAsked];
    }
}

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
        self.currentExercise = [[ExerciceModel alloc] initWithData:data error: initError];
        
        if(error) {
            NSLog(@"Error : %@", error);
        }
        [self parseExercise];
    }
}


@end
