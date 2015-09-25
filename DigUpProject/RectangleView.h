//
//  RectangleView.h
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MaterialView.h"

@interface RectangleView : MaterialView

@property (nonatomic, strong) UIView * viewDisplayed;

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel;

@end
