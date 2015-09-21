//
//  ImageView.h
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialView.h"
#import "ImageViewModel.h"

@interface ImageView : MaterialView 

@property (nonatomic, strong) UIImageView * viewDisplayed;
@property (nonatomic, strong) ImageViewModel * viewModel;

@end
