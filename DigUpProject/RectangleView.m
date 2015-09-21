//
//  RectangleView.m
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RectangleView.h"

@implementation RectangleView
@dynamic viewDisplayed;

- (id) initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.material.X,
                                    self.viewModel.material.Y,
                                    self.viewModel.material.Width,
                                    self.viewModel.material.Height);
        self.viewDisplayed = [[UIView alloc] initWithFrame:frame];
        [self applyStyle:self.viewModel.material.Style ToView:self.viewDisplayed];

        if ([self.viewModel.material.Behavior isEqualToString:@"DropElement"]) {
            //[self.viewDisplayed addGestureRecognizer:self.dragRecognizer];
        }
    }
    return self;
}

- (void) applyStyle:(NSString *) style ToView:(UIView *) view {
    if([style isEqualToString:@"box-default"]) {
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.borderWidth = 1.0f;
    }
    else if ([style isEqualToString:@"box-sand_hell"]) {
        view.backgroundColor = [UIColor colorWithRed:1 green:235.0/255.0 blue:205.0/255.0 alpha:1];
    }
    else if ([style isEqualToString:@"box-sand_dunkler"]) {
        view.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:180.0/255.0 blue:140.0/255.0 alpha:1];
    }
}

@end
