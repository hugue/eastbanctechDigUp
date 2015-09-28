//
//  TextInputViewModel.h
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"

@interface TextInputViewModel : MaterialViewModel

@property (nonatomic, strong) NSString * answer;
@property (nonatomic, strong) NSString * givenAnswer;

- (void)correctionAsked;

@end
