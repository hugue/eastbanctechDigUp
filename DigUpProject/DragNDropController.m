//
//  DragNDropController.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "DragNDropController.h"

@implementation DragNDropController

- (id)init {
    self = [super init];
    if (self) {
        self.targetElements = [[NSMutableDictionary alloc] init];
        self.dropElements = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 Check if a point is in a target 
 - To be used with the point matching the finger's position
 -The material is used for later correction of the exercise and deciding frame
 */
- (BOOL)pointIsInTargetElement:(CGPoint)point forMaterial:(MaterialViewModel *)draggedMaterial {
    if (draggedMaterial.currentDropTarget) {
        //Notify the target that the element has been moved
        [self removeFromTargetElement:draggedMaterial];
    }
    for (MaterialViewModel * target in self.targetElements.allValues) {
        CGRect frameTarget = CGRectMake(target.position.x, target.position.y, target.materialWidth, target.materialHeight);
        
        if (CGRectContainsPoint(frameTarget, point)) {
            draggedMaterial.currentDropTarget = target;
            [target positionNewDraggedMaterial:draggedMaterial];
            return YES;
        }
    }
    //Check if we are on a placed element, if so, place the dragged material on the same target
    for (MaterialViewModel * placedElement in self.dropElements) {
        CGRect framePlacedElement = CGRectMake(placedElement.position.x, placedElement.position.y, placedElement.materialWidth, placedElement.materialHeight);
        
        if (CGRectContainsPoint(framePlacedElement, point)) {
            if (placedElement.currentDropTarget) {
                draggedMaterial.currentDropTarget = placedElement.currentDropTarget;
                [placedElement.currentDropTarget positionNewDraggedMaterial:draggedMaterial];
                return YES;
            }
        }
    }
    draggedMaterial.currentDropTarget = nil;
    return NO;
}

- (void)removeFromTargetElement:(MaterialViewModel *) droppedElement {
    for (MaterialViewModel * droppedMaterial in self.dropElements) {
        if ([droppedMaterial.currentDropTarget.materialID isEqualToNumber:droppedElement.currentDropTarget.materialID] &&
            droppedMaterial.position.y > droppedElement.position.y) {
            droppedMaterial.position = CGPointMake(droppedMaterial.position.x, droppedMaterial.position.y - droppedElement.materialHeight);
        }
    }
    droppedElement.currentDropTarget.posForDraggedMaterial = CGPointMake(droppedElement.currentDropTarget.posForDraggedMaterial.x,
                                                                          droppedElement.currentDropTarget.posForDraggedMaterial.y - droppedElement.materialHeight);
    droppedElement.currentDropTarget = nil;
}

- (void)ajustElementsZPotision:(NSUInteger)targetMaxZPosition {
    for (MaterialViewModel * droppedElement in self.dropElements) {
        if (droppedElement.zPosition <= targetMaxZPosition) {
            droppedElement.zPosition = targetMaxZPosition + 1;
        }
    }
}

- (BOOL)correctionAskedWithDisplay:(BOOL)displayEnabled {
    BOOL isCorrect = YES;
    for (MaterialViewModel * droppedElement in self.dropElements) {
        if (droppedElement.currentDropTarget) {
            if ((droppedElement.correctDropTargetID) && [droppedElement.currentDropTarget.materialID isEqualToNumber:droppedElement.correctDropTargetID]){
                if (displayEnabled) {
                    droppedElement.displayState = MaterialDisplayStateIsCorrect;
                }
            }
            else {
                isCorrect = NO;
                if (displayEnabled) {
                    droppedElement.displayState = MaterialDisplayStateIsNotCorrect;
                }
            }
        }
        else {
            if (droppedElement.correctDropTargetID) {
                isCorrect = NO;
                if (displayEnabled) {
                    droppedElement.displayState = MaterialDisplayStateIsNotCorrect;
                }
            }
        }
    }
    return isCorrect;
}

- (void)solutionAsked {
    for(MaterialViewModel * droppedElement in self.dropElements) {
        if (droppedElement.currentDropTarget) {
            if (droppedElement.correctDropTargetID) {
                if (![droppedElement.currentDropTarget.materialID isEqualToNumber:droppedElement.correctDropTargetID]) {
                    [self removeFromTargetElement:droppedElement];
                    MaterialViewModel * correctTarget = self.targetElements[droppedElement.correctDropTargetID];
                    [correctTarget positionNewDraggedMaterial:droppedElement];
                    droppedElement.currentDropTarget = correctTarget;
                }
            }
            else {
                [self removeFromTargetElement:droppedElement];
                [droppedElement resetPosition];
            }
        }
        else {
            if (droppedElement.correctDropTargetID) {
                MaterialViewModel * correctTarget = self.targetElements[droppedElement.correctDropTargetID];
                [correctTarget positionNewDraggedMaterial:droppedElement];
                droppedElement.currentDropTarget = correctTarget;
            }
        }
        if (droppedElement.displayState == MaterialDisplayStateIsNotCorrect) {
            droppedElement.displayState = MaterialDisplayStateIsNormal;
        }
    }
}

- (void)restartAsked {
        for (MaterialViewModel * droppedElement in self.dropElements) {
            droppedElement.currentDropTarget = nil;
            [droppedElement resetPosition];
        }
        for (MaterialViewModel * target in self.targetElements.allValues) {
            target.posForDraggedMaterial = CGPointMake(target.position.x, target.position.y);
    }
}

@end
