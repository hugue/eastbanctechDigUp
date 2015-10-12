//
//  TestViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TestViewModel.h"

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

- (id)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    id viewModel = nil;
    if ([segueIdentifier isEqualToString:@"displayExerciseSegue"]) {
        viewModel = [[ExerciseViewModel alloc] initWithDataModel:self.exerciseModel WebController:self.webController];
    }
    return viewModel;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"displayExerciseSegue"]) {
        return [self.exerciseLoaded boolValue];
    }
    return NO;
}

- (void)askDataForExercise:(TestModel *)testModel {
    NSString * exerciseURL = testModel.urlExercise;
    [self.webController addTaskForObject:self toURL:exerciseURL];
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
