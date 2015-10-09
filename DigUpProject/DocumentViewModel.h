//
//  documentViewModel.h
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoursesTableViewModel.h"
#import "ChooseTestTableViewModel.h"
#import "SubcourseModel.h"

@interface DocumentViewModel : NSObject

@property (nonatomic, strong) SubcourseModel * currentSubcourse;
@property (nonatomic, strong) ChooseTestTableViewModel * chooseTestViewModel;
@property (nonatomic, strong) WebController * webController;

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;
- (id)initWithSubcourse:(SubcourseModel *)subcourse webController:(WebController *)webController;

@end
