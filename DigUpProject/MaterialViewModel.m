//
//  MaterialViewModel.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"

@implementation MaterialViewModel

- (id) initWithModel:(MaterialModel *) materialModel {
    self = [super init];
    if (self) {
        self.material = materialModel;
        self.materialID = materialModel.Id;
        
        self.position = CGPointMake(materialModel.X, materialModel.Y);
        self.posForDraggedMaterial = self.position;
        self.currentDropTarget = nil;
        self.droppedElements = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) positionNewDraggedMaterial:(MaterialViewModel *)draggedMaterial {
    draggedMaterial.position = self.posForDraggedMaterial;
    //Update the position for next dragged element
    self.posForDraggedMaterial = CGPointMake(self.posForDraggedMaterial.x, self.posForDraggedMaterial.y + draggedMaterial.material.Height);
}

- (void) removeDroppedElement:(MaterialViewModel *)removedElement {
    int index = [self.droppedElements indexOfObjectIdenticalTo:removedElement];
    float removedHeight = removedElement.material.Height;
    for (int i = index +1; i < self.droppedElements.count; i++) {
        self.droppedElements[i].position = CGPointMake(self.droppedElements[i].position.x, self.droppedElements[i].position.y - removedHeight);
    }
    self.posForDraggedMaterial = CGPointMake(self.posForDraggedMaterial.x, self.posForDraggedMaterial.y - removedHeight);
    [self.droppedElements removeObject:removedElement];
}

@end
