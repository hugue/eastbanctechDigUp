//
//  ExerciseViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExerciseViewModel.h"

@interface ExerciseViewModel()
@property (nonatomic, strong) NSMutableArray<RACSignal *> * downloadedMedias;
@end

@implementation ExerciseViewModel

- (id)initWithDataModel:(ExerciseModel *)exerciseModel WebController:(WebController *)webController mediaURL:(NSString *)mediaurl {
    self = [super init];
    if (self) {
        [self initialize];
        self.webController = webController;
        self.currentExercise = exerciseModel;
        self.mediaURL = mediaurl;
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
    self.mediasLoaded = @NO;
    self.buttonControllers = [[NSMutableDictionary alloc] init];
    self.materialsModels = [[NSMutableArray alloc] init];
    self.dropController = [[DragNDropController alloc] init];
    self.audioController = [[AudioController alloc] init];
    
    self.downloadedMedias = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear {
    [self.audioController releaseAudioTimer];
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
                self.audioController.controllerState = AudioControllerCurrentStateStopped;
                break;
            case ExerciseCurrentStateIsGoingOn:
                for (materialViewModel in self.materialsModels) {
                    materialViewModel.materialState = MaterialCurrentStateGoingOn;
                }
                self.audioController.controllerState = AudioControllerCurrentStateGoingOn;
                break;
            default:
                break;
        }
        
    }];
    if (self.downloadedMedias.count == 0) {
        self.mediasLoaded = @YES;
    }
    else  {
        RAC(self, mediasLoaded) = [[RACSignal combineLatest:self.downloadedMedias] map:^id(RACTuple * value) {
            NSArray * result = value.allObjects;
            NSNumber * allDownloaded = @YES;
            for (NSNumber * downloaded in result) {
                if (![downloaded boolValue]) {
                    allDownloaded = @NO;
                    break;
                }
            }
            return allDownloaded;
        }];
    }
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
        NSLog(@"Error : Exercise do not conform to the expected standard");
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

#pragma mark - Correction methods
- (BOOL)correctionAskedDisplayed:(BOOL)displayCorrection {
    self.currentExerciseState = ExerciseCurrentStateIsStopped;
    [self.audioController stopCurrentAudio];
    [self.dropController correctionAskedWithDisplay:YES];
    for (MaterialViewModel * material in self.materialsModels) {
        [material correctionAskedWithDisplay:YES];
    }
    return NO;
}

- (void)solutionAsked {
    for (MaterialViewModel * materialViewModel in self.materialsModels) {
        [materialViewModel solutionAsked];
    }
    for (RadioButtonsController * radioButtonController in self.buttonControllers.allValues) {
        [radioButtonController solutionAsked];
    }
    [self.dropController solutionAsked];
}

- (void)restartExerciseAsked {
    [self.audioController restartAsked];
    [self.dropController restartAsked];
    for (MaterialViewModel * materialViewModel in self.materialsModels) {
        [materialViewModel restartAsked];
    }
    self.currentExerciseState = ExerciseCurrentStateIsGoingOn;
}

@end
