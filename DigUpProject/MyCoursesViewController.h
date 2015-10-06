//
//  MyCoursesViewController.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCoursesViewModel.h"
#import "CoursesTableViewController.h"

@interface MyCoursesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *coursesTableView;
@property (weak, nonatomic) IBOutlet UIView *detailCoursesTableView;

@property (nonatomic, strong) MyCoursesViewModel * viewModel;

@end