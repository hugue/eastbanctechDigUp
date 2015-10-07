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

@property (nonatomic, strong) NSString * nameDocument;
@property (nonatomic, strong) NSArray<NSString *> * testNames;

@property (nonatomic, strong) SubcourseModel * currentSubcourse;
@property (nonatomic, strong) ChooseTestTableViewModel * chooseTestViewModel;

- (id)initWithTests:(NSArray<NSString *> *)listTest;
- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier;

@end
