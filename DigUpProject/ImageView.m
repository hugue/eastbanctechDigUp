//
//  ImageView.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ImageView.h"

@interface ImageView()

@end

@implementation ImageView
@dynamic viewDisplayed;
@dynamic viewModel;

- (id) initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.material.X ,
                                    self.viewModel.material.Y,
                                    self.viewModel.material.Width,
                                    self.viewModel.material.Height);
        self.viewDisplayed = [[UIImageView alloc] initWithFrame:frame];
        
        //NSString * imageName = materialViewModel.material.Name;
        //UIImage * image = [UIImage imageNamed:imageName];
        //[self.viewDisplayed setImage:image];
        [self applyModelToView];
    }
    return self;
}

- (void) applyModelToView {
    RACSignal * imageLoadedSignal = RACObserve(self.viewModel, imageLoaded);
    [[imageLoadedSignal filter:^BOOL(id value) {
        return [value boolValue];
    }]subscribeNext:^(id x) {
        UIImage * downloadedImage = [UIImage imageWithData:self.viewModel.imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewDisplayed setImage:downloadedImage];});
        }];
}

@end
