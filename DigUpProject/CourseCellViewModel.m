//
//  CourseCellViewModel.m
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "CourseCellViewModel.h"

@implementation CourseCellViewModel

- (id)initWithIdentifier:(NSString *)identifier andLabel:(NSString *)cellLabel{
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        self.cellLabel = cellLabel;
    }
    return self;
}

/*
- (NSString *)reuseIdentifier {
        return self.cellIdentifier;
}
*/
@end
