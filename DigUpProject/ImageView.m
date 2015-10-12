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

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        CGRect  frame =  CGRectMake(self.viewModel.position.x ,
                                    self.viewModel.position.y,
                                    self.viewModel.materialWidth,
                                    self.viewModel.materialHeight);
        self.viewDisplayed = [[UIImageView alloc] initWithFrame:frame];
        
        [self applyModelToView];
    }
    return self;
}

- (void)applyModelToView {
    @weakify(self)
    RACSignal * imageLoadedSignal = RACObserve(self.viewModel, imageLoaded);
    [[imageLoadedSignal filter:^BOOL(id value) {
        return [value boolValue];
    }]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"Image Loaded %@", x);
        dispatch_async(dispatch_get_main_queue(), ^{
        UIImage * downloadedImage = [UIImage imageWithData:self.viewModel.imageData];
            [self.viewDisplayed setImage:downloadedImage];});
        }];
}

@end
