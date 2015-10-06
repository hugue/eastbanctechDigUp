//
//  CourseCellView.m
//  DigUpProject
//
//  Created by hugues on 05/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CourseCellView.h"

@implementation CourseCellView

@dynamic viewModel;

- (id)init {
    self = [super init];
    if (self) {
        self.dynamicHeightLabels = [[NSArray alloc] initWithObjects:[[UILabel alloc] init], nil];
    }
    return self;
}

- (void)applyModelToView {
    if (!self.dynamicHeightLabels) {
        CGRect labelFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UILabel * cellLabel = [[UILabel alloc] initWithFrame:labelFrame];
        self.dynamicHeightLabels = @[cellLabel];
        [self addSubview:cellLabel];
    }
    
    UILabel * label = self.dynamicHeightLabels[0];
    label.text = self.viewModel.cellLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
