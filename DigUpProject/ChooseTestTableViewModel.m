//
//  ChooseTestTableViewModel.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ChooseTestTableViewModel.h"
@interface ChooseTestTableViewModel ()

@property (nonatomic, strong) SWGTest * dataModel;

@end

@implementation ChooseTestTableViewModel

- (id)initWithWebController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.selectedCell = nil;
        self.webController = webController;
    }
    return self;
}

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel = nil;
    if ([segueIdentifier isEqualToString:@"displayTestSegue"]) {
        viewModel = [[TestViewModel alloc] initWithSWGTest:self.dataModel WebController:self.webController];
    }
    return viewModel;
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion {
    self.dataModel = [self.listTests objectAtIndex:[indexPath indexAtPosition:1]];
    self.selectedCell = @([indexPath indexAtPosition:1]);
}

- (void)viewWillAppear {
}

- (void)viewWillDisappear {
}

@end
