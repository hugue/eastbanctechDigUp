//
//  CourseCellView.m
//  DigUpProject
//
//  Created by hugues on 05/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CourseCellView.h"

#import <ReactiveCocoa.h>

@interface CourseCellView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CourseCellView

@dynamic viewModel;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyModelToView];
}

- (void)applyModelToView {
    RAC(self.nameLabel, text) = RACObserve(self, viewModel.cellLabel);
}

- (NSString *)reuseIdentifier {
    return @"CourseCellView";
}

@end
