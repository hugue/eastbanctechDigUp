//
//  CourseCellViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseCellViewModel : NSObject

@property (nonatomic, strong) NSString * cellIdentifier;
@property (nonatomic, strong) NSString * cellLabel;

- (NSString *)reuseIdentifier;
- (id)initWithIdentifier:(NSString *)identifier;

@end
