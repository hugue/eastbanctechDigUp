//
//  CourseCellViewModel.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETRStaticCellModel.h"

@interface CourseCellViewModel : ETRStaticCellModel

@property (nonatomic, strong) NSString * cellLabel;

//- (NSString *)reuseIdentifier;
- (id)initWithIdentifier:(NSString *)identifier andLabel:(NSString *)cellLabel;

@end
