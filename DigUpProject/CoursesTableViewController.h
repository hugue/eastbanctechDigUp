//
//  CoursesTableViewController.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "CoursesTableViewModel.h"
#import "ETRTableViewController.h"
#import "CourseCellView.h"

@interface CoursesTableViewController : ETRTableViewController

@property (nonatomic, strong) CoursesTableViewModel * viewModel;

@end
