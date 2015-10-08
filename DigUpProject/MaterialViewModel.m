//
//  MaterialViewModel.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"
@interface MaterialViewModel ()
@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * droppedElements;

@end

@implementation MaterialViewModel

- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super init];
    if (self) {
        self.material = materialModel;
        self.materialID = materialModel.Id;
        self.answerState = MaterialAnswerStateIsTesting;
        self.correctDropTargetID = self.material.DropTargetId;
        
        self.position = CGPointMake([materialModel.X floatValue], [materialModel.Y floatValue]);
        self.zPosition = [materialModel.Z integerValue];
        
        self.materialHeight = [self.material.Height floatValue];
        self.materialWidth = [self.material.Width floatValue];
        
        self.posForDraggedMaterial = self.position;
        self.currentDropTarget = nil;
        self.droppedElements = [[NSMutableArray alloc] init];
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

- (void)correctionAsked {
}

- (void)solutionAsked {
}

- (void)restartAsked {
}

- (void)applyDataToMaterial:(NSData *)data {
}

@end
