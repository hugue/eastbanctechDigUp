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
@property (nonatomic, strong) NSMutableArray<RACSignal *> * exerciseMediasLoaded;
@end

@implementation ExamFirstViewModel

- (id)initWithDataModel:(ExamModel *)dataModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.webController = webController;
        self.dataModel = dataModel;
        [self initialize];
        //[self.webController addTaskForObject:self toURL:self.dataModel.examULR];
        [self temporaryExam];
    }
    return self;
}

- (void)initialize {
    self.examLoaded = NO;
    self.exerciseMediasLoaded = [[NSMutableArray alloc] init];
    self.exercises = [[NSMutableArray alloc] init];
}

- (ExamViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    ExamViewModel * examViewModel;
    if ([segueIdentifier isEqualToString:@"startExamSegue"]) {
        examViewModel = [[ExamViewModel alloc] initWithExercises:self.exercises AllowedTime:60];
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
    RACSignal * mediaLoaded = RACObserve(exerciseViewModel, mediasLoaded);
    [self.exerciseMediasLoaded addObject:mediaLoaded];
    self.examLoaded = YES;
}

- (void)temporaryExam {
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
    [self.webController addTaskForObject:self toURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/breeze/context/Shapes?$filter=ExerciseId%20eq%2036L&$expand=Shapes&"];
}

@end
