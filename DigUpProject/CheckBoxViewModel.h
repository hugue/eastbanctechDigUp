//
//  CheckBoxViewModel.h
//  DigUpProject
//
//  Created by hugues on 21/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialViewModel.h"

@interface CheckBoxViewModel : MaterialViewModel

@property (nonatomic) BOOL isTrue;
@property (nonatomic, strong) NSString * groupID;
@property (nonatomic) BOOL isClicked;

- (id) initWithModel:(MaterialModel *)materialModel;
- (void) viewChanged:(NSNumber *) newState;

@end
