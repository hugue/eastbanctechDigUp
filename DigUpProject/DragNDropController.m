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
        //[draggedMaterial.currentDropTarget removeDroppedElement:draggedMaterial];
        [self removeFromTargetElement:draggedMaterial];
    }
    for (MaterialViewModel * target in self.targetElements.allValues) {
        CGRect frameTarget = CGRectMake(target.position.x, target.position.y, target.materialWidth, target.materialHeight);
        
        if (CGRectContainsPoint(frameTarget, point)) {
            draggedMaterial.currentDropTarget = target;
            //[target.droppedElements addObject:draggedMaterial];
            [target positionNewDraggedMaterial:draggedMaterial];
            return YES;
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

- (void)correctionAsked {
    for (MaterialViewModel * droppedElement in self.dropElements) {
        if (droppedElement.currentDropTarget) {
            if ((droppedElement.correctDropTargetID) && [droppedElement.currentDropTarget.materialID isEqualToNumber:droppedElement.correctDropTargetID]){
                droppedElement.answerMode = MaterialAnswerModeIsCorrect;
            }
            else {
                droppedElement.answerMode = MaterialAnswerModeIsNotCorrect;
            }
        }
    }
}

- (void)solutionAsked {
    for(MaterialViewModel * droppedElement in self.dropElements) {
        //The element has been placed
        if (droppedElement.answerMode == MaterialAnswerModeIsNotCorrect) {
            [self removeFromTargetElement:droppedElement];
            if (droppedElement.correctDropTargetID) {
                MaterialViewModel * correctTarget = self.targetElements[droppedElement.correctDropTargetID];
                //[droppedElement.currentDropTarget removeDroppedElement:droppedElement];
               // [correctTarget.droppedElements addObject:droppedElement];
                [correctTarget positionNewDraggedMaterial:droppedElement];
                droppedElement.answerMode = MaterialAnswerModeIsUndefined;
                droppedElement.currentDropTarget = correctTarget;
            }
            else {
                //[droppedElement.currentDropTarget removeDroppedElement:droppedElement];
                [droppedElement resetPosition];
            }
        }
        //Means the element has not been placed on a target
        else if (droppedElement.answerMode == MaterialAnswerModeIsUndefined) {
            if (droppedElement.correctDropTargetID) {
                MaterialViewModel * correctTarget = self.targetElements[droppedElement.correctDropTargetID];
                //[correctTarget.droppedElements addObject:droppedElement];
                [correctTarget positionNewDraggedMaterial:droppedElement];
                droppedElement.currentDropTarget = correctTarget;
            }
        }
    }
}

- (void)restartAsked {
        for (MaterialViewModel * droppedElement in self.dropElements) {
            droppedElement.currentDropTarget = nil;
            [droppedElement resetPosition];
            droppedElement.answerMode = MaterialAnswerModeIsUndefined;
        }
        for (MaterialViewModel * target in self.targetElements.allValues) {
            target.posForDraggedMaterial = CGPointMake(target.position.x, target.position.y);
        //[target.droppedElements removeAllObjects];
    }
}

@end
