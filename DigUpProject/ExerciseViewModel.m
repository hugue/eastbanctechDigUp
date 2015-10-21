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
@property (nonatomic, strong) NSArray<SWGMaterial *> * dereferencedMaterials;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SWGMaterial *> * referencedMaterials;
@end

@implementation ExerciseViewModel

- (id)initWithSWGExercise:(SWGExercise *)exerciseModel WebController:(WebController *)webController mediaUrl:(NSString *)mediaurl {
    self = [super init];
    if (self) {
        [self initialize];
        self.webController = webController;
        self.currentExercise = exerciseModel;
        self.mediaURL = mediaurl;
        self.dereferencedMaterials = [self analyseReferencedMaterials:self.currentExercise.materials];
        [self parseExerciseWithMaterials:self.dereferencedMaterials];
    }
    return self;
}
- (void)initialize {
    self.currentExerciseState = ExerciseCurrentStateIsStopped;
    
    self.maxZPosition = 0;
    self.maxTargetZPosition = 0;
    self.bottomOfView = 0;
    self.rightBorderOfView = 0;
    self.mediasLoaded = @NO;
    self.buttonControllers = [[NSMutableDictionary alloc] init];
    self.materialsModels = [[NSMutableArray alloc] init];
    self.dropController = [[DragNDropController alloc] init];
    self.audioController = [[AudioController alloc] init];
    self.referencedMaterials = [[NSMutableDictionary alloc] init];
    self.downloadedMedias = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear {
    
}

//Call this method before deallocating to avoid memory leak from audioController
- (void)releaseThirdParty {
    [self.audioController releaseAudioTimer];
}

- (void)dealloc {
    [self.audioController releaseAudioTimer];
}

- (void)parseExerciseWithMaterials:(NSArray<SWGMaterial *> *)materials {
    if (self.currentExercise == nil) {
        NSLog(@"Error, no exercise found");
        return;
    }
    NSUInteger numberMaterials = materials.count;
    for (int i = 0; i < numberMaterials; i++) {
        MaterialViewModel * materialViewModel = [self createMaterialViewModelWithModel:materials[i]];
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
                [self.audioController stopCurrentAudio];
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
    [self.dropController ajustElementsZPotision:self.maxTargetZPosition];
}

- (MaterialViewModel *)createMaterialViewModelWithModel:(SWGMaterial *)materialModel{
    
    NSString * type = materialModel.type;
    MaterialViewModel * materialViewModel;
    if ([type isEqualToString:@"Text"]) {
        materialViewModel = [[MaterialViewModel alloc] initWithSWGMaterial:materialModel];
    }
    else if ([type isEqualToString:@"RadioButton"]) {
        RadioButtonViewModel * buttonViewModel = [[RadioButtonViewModel alloc] initWithSWGMaterial:materialModel];
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
        materialViewModel = [[MaterialViewModel alloc] initWithSWGMaterial:materialModel];
    }
    else if ([type isEqualToString:@"Image"]) {
        ImageViewModel * imageViewModel = [[ImageViewModel alloc] initWithSWGMaterial:materialModel];
        [self.webController addTaskForObject:imageViewModel toURL:[imageViewModel makeDownloadURLFormURL:self.mediaURL]];
        RACSignal * imageLoadedSignal = RACObserve(imageViewModel, imageLoaded);
        [self.downloadedMedias addObject:imageLoadedSignal];
        [self processDragNDropElement:imageViewModel];
        [self updateViewBordersWithMaterial:imageViewModel];
        return imageViewModel;
    }
    else if ([type isEqualToString:@"InputField"]) {
        materialViewModel = [[TextInputViewModel alloc] initWithSWGMaterial:materialModel];
    }
    else if ([type isEqualToString:@"Audio"]) {
        AudioViewModel * audioViewModel = [[AudioViewModel alloc] initWithSWGMaterial:materialModel];
        [self.audioController addNewAudio:audioViewModel];
        [self.webController addTaskForObject:audioViewModel toURL:[audioViewModel makeDownloadURLFormURL:self.mediaURL]];
        RACSignal * audioLoadedSignal = RACObserve(audioViewModel, audioLoaded);
        [self.downloadedMedias addObject:audioLoadedSignal];
        [self processDragNDropElement:audioViewModel];
        [self updateViewBordersWithMaterial:audioViewModel];
        return audioViewModel;
    }
    else if([type isEqualToString:@"CheckBox"]) {
        materialViewModel = [[CheckBoxViewModel alloc] initWithSWGMaterial:materialModel];
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
    if ([materialViewModel.material.behavior isEqualToString:@"DropTarget"]){
        [self.dropController.targetElements setObject:materialViewModel forKey:materialViewModel.materialID];
        if (self.maxTargetZPosition < materialViewModel.zPosition) {
            self.maxTargetZPosition = materialViewModel.zPosition;
        }
    }
    else if([materialViewModel.material.behavior isEqualToString:@"DropElement"]) {
        [self.dropController.dropElements addObject:materialViewModel];
    }
    
    if (self.maxZPosition < materialViewModel.zPosition) {
        self.maxZPosition = materialViewModel.zPosition;
    }
}

#pragma mark - Correction methods
- (BOOL)correctionAskedDisplayed:(BOOL)displayCorrection {
    BOOL isCorrect = YES;
    [self.audioController stopCurrentAudio];
    BOOL dragNDropIsCorrect = [self.dropController correctionAskedWithDisplay:displayCorrection];
    for (MaterialViewModel * material in self.materialsModels) {
        MaterialAnswerState materialAnswerState = [material correctionAskedWithDisplay:displayCorrection];
        if (materialAnswerState == MaterialAnswerStateIsNotCorrect) {
            isCorrect = NO;
        }
    }
    return (isCorrect && dragNDropIsCorrect);
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
}

- (NSArray<SWGMaterial *> *)analyseReferencedMaterials:(NSArray<SWGMaterial *> *)materials {
    NSMutableArray * allMaterials = [[NSMutableArray alloc] init];
    for (SWGMaterial * material in materials) {
        //This is a reference
        if (material.ref) {
            SWGMaterial * referencedMaterial = [self.referencedMaterials objectForKey:material.ref];
            [self createReferencedMaterials:referencedMaterial];
            [allMaterials addObject:referencedMaterial];
        }
        else {
            [self createReferencedMaterials:material];
            [allMaterials addObject:material];
        }
    }
    return allMaterials;
}

- (void)createReferencedMaterials:(SWGMaterial *)material {
    //If this material creates other materials, register it in the dictionary so we know were to look at when we find the references
    if (material.dropElements) {
        for(SWGMaterial * referencedMaterial in material.dropElements) {
            //If this is not a reference but a real model, store it
            if(referencedMaterial.id) {
                [self.referencedMaterials setObject:referencedMaterial forKey:referencedMaterial.id];
                [self createReferencedMaterials:referencedMaterial];
            }
        }
    }
    else if(material.dropTarget) {
        //If this is not a reference but a real model, store it
        if(material.dropTarget.id) {
            [self.referencedMaterials setObject:material.dropTarget forKey:material.dropTarget.id];
            [self createReferencedMaterials:material.dropTarget];
        }
    }

}

@end
