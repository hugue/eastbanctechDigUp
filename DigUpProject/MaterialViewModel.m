//
//  MaterialViewModel.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"
@interface MaterialViewModel ()
@end

@implementation MaterialViewModel

- (id)initWithSWGMaterial:(SWGMaterial *)materialModel {
    self = [super init];
    if (self) {
        self.material = materialModel;
        self.materialID = materialModel.handlingId;
        self.displayState = MaterialDisplayStateIsNormal;
        self.correctDropTargetID = self.material.dropTargetId;
        
        self.position = CGPointMake([materialModel.X floatValue], [materialModel.Y floatValue]);
        self.zPosition = [materialModel.Z integerValue];
        
        self.materialHeight = [self.material.height floatValue];
        self.materialWidth = [self.material.width floatValue];
        
        self.posForDraggedMaterial = self.position;
        self.currentDropTarget = nil;
        
        self.materialState = MaterialCurrentStateGoingOn;
    }
    return self;
}

- (void)positionNewDraggedMaterial:(MaterialViewModel *)draggedMaterial {
    draggedMaterial.position = self.posForDraggedMaterial;
    //Update the position for next dragged element
    self.posForDraggedMaterial = CGPointMake(self.posForDraggedMaterial.x, self.posForDraggedMaterial.y + draggedMaterial.materialHeight);
}

- (void)resetPosition {
    self.position = CGPointMake([self.material.X floatValue], [self.material.Y floatValue]);
}

- (MaterialAnswerState)correctionAskedWithDisplay:(BOOL)displayEnabled {
    return MaterialAnswerStateIsCorrect;
}

- (void)solutionAsked {
}

- (void)restartAsked {
    self.displayState = MaterialDisplayStateIsNormal;
}

- (void)applyDataToMaterial:(NSData *)data {
}

- (NSString *)makeDownloadURLFormURL:(NSString *)url {
    NSString * downloadURL = [NSString stringWithFormat:@"%@%@", url, self.material.blobId];
    return downloadURL;
}

#pragma mark - DataControllerProtocol

- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    if (error) {
        NSLog(@"Error upon receiving data in AudioViewModel- %@", error);
    }
    else {
        [self applyDataToMaterial:data];
    }
}

@end
