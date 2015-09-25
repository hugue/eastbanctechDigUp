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
        self.targetElements = [[NSMutableArray alloc] init];
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
        [draggedMaterial.currentDropTarget removeDroppedElement:draggedMaterial];
    }
    for (MaterialViewModel * target in self.targetElements) {
        CGRect frameTarget = CGRectMake(target.position.x, target.position.y, target.materialWidth, target.materialHeight);
        
        if (CGRectContainsPoint(frameTarget, point)) {
            draggedMaterial.currentDropTarget = target;
            [target.droppedElements addObject:draggedMaterial];
            [target positionNewDraggedMaterial:draggedMaterial];
            return YES;
        }
    }
    draggedMaterial.currentDropTarget = nil;
    return NO;
}

@end
