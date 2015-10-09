//
//  ChooseTestTableViewModel.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ChooseTestTableViewModel.h"

@implementation ChooseTestTableViewModel

- (id)initWithWebController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.selectedCell = nil;
        //self.mainViewModel = [[MainViewModel alloc] init];
        self.webController = webController;
    }
    return self;
}

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel = nil;
    if ([segueIdentifier isEqualToString:@"displayExerciseSegue"]) {
        viewModel = self.mainViewModel;
    }
    return viewModel;
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion {
    //[self.mainViewModel reset];
    TestModel * testModel = [self.listTests objectAtIndex:[indexPath indexAtPosition:1]];
    self.mainViewModel = [[MainViewModel alloc] initWithTestModel:testModel WebController:self.webController];
    //self.mainViewModel.webSearcherController.urlToReach = [self.listTests objectAtIndex:[indexPath indexAtPosition:1]].urlExercise;
    //self.mainViewModel.webSearcherController.mediaURL = [self.listTests objectAtIndex:[indexPath indexAtPosition:1]].urlMedia;
    self.selectedCell = @([indexPath indexAtPosition:1]);
}

- (void)viewWillAppear {
    self.mainViewModel = nil;
}

- (void)viewWillDisappear {
}

@end
