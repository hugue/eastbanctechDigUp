//
//  DragNDropController.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "DragNDropController.h"

@implementation DragNDropController

- (id) init {
    self = [super init];
    if (self) {
        self.targetElements = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 Check if a point is in a target, returns the target's model view if yes
 else returns nil.
 - To be used with the point matching the finger's position
 */
- (BOOL) pointIsInTargetElement:(CGPoint)point {
    for (MaterialViewModel * target in self.targetElements) {
        CGRect frameTarget = CGRectMake(target.material.X, target.material.Y, target.material.Width, target.material.Height);
        if (CGRectContainsPoint(frameTarget, point)) {
            return YES;
        }
    }
    return NO;
}

@end
