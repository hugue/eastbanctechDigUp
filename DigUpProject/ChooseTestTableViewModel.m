//
//  ChooseTestTableViewModel.m
//  DigUpProject
//
//  Created by hugues on 06/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ChooseTestTableViewModel.h"

@implementation ChooseTestTableViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.selectedCell = nil;
        self.mainViewModel = [[MainViewModel alloc] init];
    }
    return self;
}

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel = nil;
    if ([segueIdentifier isEqualToString:@"displayExerciseSegue"]) {
        viewModel = self.mainViewModel;
        self.testMainViewModel = self.mainViewModel;
        self.testAudioController = self.mainViewModel.audioController;
    }
    return viewModel;
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion {
    self.mainViewModel = nil;
    //[self.mainViewModel reset];
    self.mainViewModel = [[MainViewModel alloc] init];
    self.mainViewModel.webSearcherController.urlToReach = [self.listTests objectAtIndex:[indexPath indexAtPosition:1]].urlExercise;
    self.mainViewModel.webSearcherController.mediaURL = [self.listTests objectAtIndex:[indexPath indexAtPosition:1]].urlMedia;
    self.selectedCell = @([indexPath indexAtPosition:1]);
}

- (void)viewWillAppear {
    self.mainViewModel = nil;
    NSLog(@"testMainViewModel - %@", self.testMainViewModel.audioController.currentlyPlaying);
}

- (void)viewWillDisappear {
    NSLog(@"testMainViewModel will disappear- %@", self.testMainViewModel);
    NSLog(@"testAudioController will disappear - %@", self.testAudioController);
}

@end
