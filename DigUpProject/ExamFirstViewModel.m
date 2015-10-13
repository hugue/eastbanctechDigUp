//
//  ExamFirstViewModel.m
//  DigUpProject
//
//  Created by hugues on 12/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamFirstViewModel.h"
@interface ExamFirstViewModel ()
@property (nonatomic, strong) NSMutableArray<ExerciseViewModel *> * exercises;
@end

@implementation ExamFirstViewModel

- (id)initWithDataModel:(ExamModel *)dataModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.examLoaded = NO;
        self.webController = webController;
        self.dataModel = dataModel;
        self.exercises = [[NSMutableArray alloc] init];
        //[self.webController addTaskForObject:self toURL:self.dataModel.examULR];
        [self temporaryExam];
    }
    return self;
}

- (ExamViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    ExamViewModel * examViewModel;
    if ([segueIdentifier isEqualToString:@"startExamSegue"]) {
        examViewModel = [[ExamViewModel alloc] initWithExercises:self.exercises AllowedTime:10];
    }
    return examViewModel;
}

- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    //Create Exam here according to JSON Model
    NSError * initError;
    
    /*Temporary Code for working without back end*/
    ExerciseModel * exerciseModel = [[ExerciseModel alloc] initWithData:data error: &initError];
    ExerciseViewModel * exerciseViewModel = [[ExerciseViewModel alloc] initWithDataModel:exerciseModel WebController:self.webController mediaURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/Stream/Blob/"];
    [self.exercises addObject:exerciseViewModel];
    self.examLoaded = YES;
}

- (void)temporaryExam {
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
}

@end
