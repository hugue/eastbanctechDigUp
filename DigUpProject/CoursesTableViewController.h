//
//  CoursesTableViewController.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ETRTableViewController.h"
#import "CoursesTableViewModel.h"

@interface CoursesTableViewController : ETRTableViewController

@property (nonatomic, strong) CoursesTableViewModel * viewModel;

- (void)loadView;

@end
