//
//  MenuViewController.h
//  DigUpProject
//
//  Created by hugues on 15/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "MenuViewModel.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MenuViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UITableView *detailCourseTableView;
@property (weak, nonatomic) IBOutlet UITableView *courseTableView;

@end
