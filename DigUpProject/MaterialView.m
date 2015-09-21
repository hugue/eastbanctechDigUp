//
//  MaterialView.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialView.h"

@implementation MaterialView

- (id) initWithViewModel: (MaterialViewModel *) materialViewModel {
    self = [super init];
    if (self) {
        self.viewModel = materialViewModel;
        if ([self.viewModel.material.Behavior isEqualToString:@"DropElement"]) {
            //self.dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        }
    }
    return self;
}

- (void) addVisualToView:(UIView *)superView {
    [superView addSubview:self.viewDisplayed];
}
/*
- (void) handleDrag:(UIGestureRecognizer *) recognizer {

    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        // Store the initial touch so when we change positions we do not snap
        self.position = [recognizer locationInView:recognizer.view];
        [self.viewDisplayed bringSubviewToFront:recognizer.view];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint newCoord = [recognizer locationInView:recognizer.view];
    
        // Create the frame offsets to use our finger position in the view.
        float dX = newCoord.x-self.position.x;
        float dY = newCoord.y-self.position.y;
    
        recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x+dX,
                                           recognizer.view.frame.origin.y+dY,
                                           recognizer.view.frame.size.width,
                                           recognizer.view.frame.size.height);
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Touched ended");
    }
}
*/

@end
