//
//  MainViewModel.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MainViewModel.h"
@interface MainViewModel ()

@property (nonatomic, strong) NSString * exerciseURL;
@property (nonatomic, strong) NSString * mediaURL;
@property (nonatomic, strong) NSMutableArray<RACSignal *> * downloadedMedias;

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
    self.currentExerciseState = ExerciseCurrentStateIsStopped;
    
    self.maxZPosition = 0;
    self.maxTargetZPosition = 0;
    self.bottomOfView = 0;
    self.rightBorderOfView = 0;
    
    self.buttonControllers = [[NSMutableDictionary alloc] init];
    self.materialsModels = [[NSMutableArray alloc] init];
    self.downloadedMedias = [[NSMutableArray alloc] init];
    self.dropController = [[DragNDropController alloc] init];
    self.audioController = [[AudioController alloc] init];
}

- (void)reset {
    [self initialize];
}

- (void)viewWillDisappear {
    [self.audioController releaseAudioTimer];
}

- (void)fetchExerciseAndDisplay {
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
        RACSignal * imageLoadedSignal = RACObserve(imageViewModel, imageLoaded);
        [self.downloadedMedias addObject:imageLoadedSignal];
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
        RACSignal * audioLoadedSignal = RACObserve(audioViewModel, audioLoaded);
        [self.downloadedMedias addObject:audioLoadedSignal];
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
    [[[RACSignal combineLatest:self.downloadedMedias] map:^id(RACTuple * value) {
        NSArray * downloadValues = value.allObjects;
        BOOL allDownoloaded = YES;
        for (id isDownloaded in downloadValues) {
            if (![isDownloaded boolValue]) {
                allDownoloaded = NO;
            }
        }
        return @(allDownoloaded);
    }] subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
        }
    }];
    
    [RACObserve(self, currentExerciseState) subscribeNext:^(id x) {
        @strongify(self)
        MaterialViewModel * materialViewModel;
        switch ([x integerValue]) {
            case ExerciseCurrentStateIsStopped:
                for (materialViewModel in self.materialsModels) {
                    materialViewModel.answerState = MaterialAnswerStateIsUndefined;
                }
                break;
            case ExerciseCurrentStateIsGoingOn:
                for (materialViewModel in self.materialsModels) {
                    materialViewModel.answerState = MaterialAnswerStateIsTesting;
                }
                break;
            case ExerciseCurrentStateCorrectionAsked:
                for (materialViewModel in self.materialsModels) {
                    [materialViewModel correctionAsked];
                }
                break;
            case ExerciseCurrentStateSolutionAsked:
                for (materialViewModel in self.materialsModels) {
                    [materialViewModel solutionAsked];
                }
                break;
            default:
                break;
        }
       
    }];
    self.exerciseLoaded = @YES;
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
    [self.audioController restartAsked];
    [self restartingDragNDrop];
    for (MaterialViewModel * materialViewModel in self.materialsModels) {
        [materialViewModel restartAsked];
    }
    self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
}

- (void)correctionAsked {
    if (self.currentExerciseState == ExerciseCurrentStateIsGoingOn) {
        self.currentExerciseState = ExerciseCurrentStateCorrectionAsked;
        [self.audioController stopCurrentAudio];
        [self correctingDragNDrop];
    }
}

- (void)solutionAsked {
    if (self.currentExerciseState == ExerciseCurrentStateCorrectionAsked) {
        self.currentExerciseState = ExerciseCurrentStateSolutionAsked;
        [self displayingSolutionForDragNDrop];
        for (RadioButtonsController * radioButtonController in self.buttonControllers.allValues) {
            [radioButtonController solutionAsked];
        }
    }
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
