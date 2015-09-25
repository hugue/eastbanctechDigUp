//
//  DragElementRecognizer.m
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "DragElementRecognizer.h"

@implementation DragElementRecognizer

- (id)initWithTarget:(nullable id)target action:(nullable SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.draggedMaterial = nil;
        self.maximumNumberOfTouches = 1;
    }
    return self;
}

@end
