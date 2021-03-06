//
//  RadioButtonViewModel.h
//  DigUpProject
//
//  Created by hugues on 11/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"

@interface RadioButtonViewModel : MaterialViewModel

@property (nonatomic) BOOL isTrue;
@property (nonatomic, strong) NSString * groupID;
@property (nonatomic, strong) NSNumber * selectedID;

- (void)buttonSelectedOnView;

@end
