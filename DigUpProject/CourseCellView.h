//
//  CourseCellView.h
//  DigUpProject
//
//  Created by hugues on 05/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ETRTableViewCell.h"
#import "CourseCellViewModel.h"

@interface CourseCellView : ETRTableViewCell

@property (nonatomic, strong) CourseCellViewModel * viewModel;

- (void)applyModelToView;

@end
