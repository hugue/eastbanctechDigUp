//
//  RectangleView.m
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RectangleView.h"
@interface RectangleView ()
@property (nonatomic, strong) CAShapeLayer * specialBorder;
@property (nonatomic, strong) NSString * style;
@end

@implementation RectangleView
@dynamic viewDisplayed;

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        self.style = self.viewModel.material.style;
        CGRect  frame =  CGRectMake(self.viewModel.position.x,
                                    self.viewModel.position.y,
                                    self.viewModel.materialWidth,
                                    self.viewModel.materialHeight);
        self.viewDisplayed = [[UIView alloc] initWithFrame:frame];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self applyStyle:self.style ToView:self.viewDisplayed];
        });
        

        //Add the dashed border if is a target
        if ([self.viewModel.material.behavior isEqualToString:@"DropTarget"]) {
            self.specialBorder = [CAShapeLayer layer];
            self.specialBorder.strokeColor = [UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1].CGColor;
            self.specialBorder.fillColor = nil;
            self.specialBorder.lineDashPattern = @[@4, @2];
            self.specialBorder.path = [UIBezierPath bezierPathWithRect:self.viewDisplayed.bounds].CGPath;
            self.specialBorder.frame = self.viewDisplayed.bounds;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewDisplayed.layer addSublayer:self.specialBorder];
            });
        }
    }
    return self;
}

- (void)applyStyle:(NSString *)style ToView:(UIView *)view {
    if([style isEqualToString:@"box-default"]) {
        view.backgroundColor = [UIColor whiteColor];
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

- (void)applyBorderStyleForAnswerState:(MaterialDisplayState)materialDisplayState {
    [super applyBorderStyleForAnswerState:materialDisplayState];
    if ((materialDisplayState == MaterialDisplayStateIsNormal) && [self.style isEqualToString:@"box-default"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed.layer.borderColor = [UIColor blackColor].CGColor;
            self.viewDisplayed.layer.borderWidth = 1.0f;
        });
    }
}


@end
