//
//  MenuViewController.m
//  DigUpProject
//
//  Created by hugues on 15/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.courseTableView.tag = 1;
    self.detailCourseTableView.tag = 2;
    
    self.courseTableView.delegate = self;
    self.detailCourseTableView.delegate = self;
    
    self.courseTableView.dataSource = self;
    self.detailCourseTableView.dataSource = self;
    
    self.viewModel = [[MenuViewModel alloc] init];
    [self applyModelToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)applyModelToView {
    @weakify(self)
    [[RACObserve(self.viewModel, selectedCourse) skip: 1] subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"Selected data - %@", x);
        [self.detailCourseTableView reloadData];
    }];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.textLabel.text = self.viewModel.listCourses[indexPath.row];

}


- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    if (tableView.tag == 1) {
        return 100;
    }
    else {
        return 150;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
            return self.viewModel.listCourses.count;
    }
    else {
        return self.viewModel.detailCourses[self.viewModel.selectedCourse].count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCourseCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
         }
        cell.textLabel.text = [[self.viewModel.detailCourses objectForKey:self.viewModel.selectedCourse] objectAtIndex:indexPath.row];
        NSLog(@"%@",[[self.viewModel.detailCourses objectForKey:self.viewModel.selectedCourse] objectAtIndex:indexPath.row]);

        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        self.viewModel.selectedCourse = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    }
    else {
        
    }
}

/*
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.courseTableView reloadData];
}
*/
@end
