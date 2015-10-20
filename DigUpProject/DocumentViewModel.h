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
#import "SwaggerClient/SWGDefaultApi.h"

@interface DocumentViewModel : NSObject

//@property (nonatomic, strong) SubcourseModel * dataModel;
@property (nonatomic, strong) ChooseTestTableViewModel * chooseTestViewModel;
@property (nonatomic, strong) WebController * webController;
@property (nonatomic, strong) SWGSubcourse * dataModel;

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;
//- (id)initWithDataModel:(SubcourseModel *)dataModel webController:(WebController *)webController;
- (id)initWithSWGSubcourse:(SWGSubcourse *)dataModel webController:(WebController *)webController;
@end
