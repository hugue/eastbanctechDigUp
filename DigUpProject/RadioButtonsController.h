//
//  RadioButtonsController.h
//  DigUpProject
//
//  Created by hugues on 14/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RadioButtonViewModel.h"

@interface RadioButtonsController : NSObject

@property (nonatomic, strong) NSNumber * currentlySelectedButtonID;

- (id) init;
- (void) addNewRadioButton:(RadioButtonViewModel *) radioButton;

@end
