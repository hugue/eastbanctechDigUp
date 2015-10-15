//
//  TestViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TestViewModel.h"
@interface TestViewModel()

@end

@implementation TestViewModel

- (id)initWithDataModel:(TestModel *)dataModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        [self initialize];
        self.webController = webController;
        self.dataModel = dataModel;
        [self askDataForExercise:self.dataModel];
    }
    return self;
}

- (void)initialize {
    self.exerciseLoaded = @NO;
}

- (ExerciseViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"displayExerciseSegue"]) {
        self.exerciseViewModel = [[ExerciseViewModel alloc] initWithDataModel:self.exerciseModel WebController:self.webController mediaURL:self.dataModel.mediaUrl];
        @weakify(self)
        [RACObserve(self.exerciseViewModel, mediasLoaded) subscribeNext:^(id x) {
            @strongify(self)
            if ([x boolValue]) {
                self.exerciseViewModel.currentExerciseState = ExerciseCurrentStateIsGoingOn;
            }
        }];
        return self.exerciseViewModel;
    }
    return nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"displayExerciseSegue"]) {
        return [self.exerciseLoaded boolValue];
    }
    return NO;
}

- (void)askDataForExercise:(TestModel *)testModel {
    NSString * exerciseURL = testModel.url;
    [self.webController addTaskForObject:self toURL:exerciseURL];
}

#pragma - mark Correction Methods

- (void)correctionAsked {
    [self.exerciseViewModel correctionAskedDisplayed:YES];
}

- (void)solutionAsked {
    [self.exerciseViewModel solutionAsked];
}

- (void)restartAsked {
    [self.exerciseViewModel restartExerciseAsked];
}

- (void)viewWillAppear {
}

#pragma mark - DataControllerProtocol methods

- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    if (error) {
        NSLog(@"Error upon reciving exercise in TestViewModel - %@", error);
    }
    else {
        NSError * initError;
        self.exerciseModel = [[ExerciseModel alloc] initWithData:data error: &initError];
        self.exerciseLoaded = @YES;
        if(error) {
            NSLog(@"Error upon parsing exercise - %@", error);
        }
    }
}

@end
