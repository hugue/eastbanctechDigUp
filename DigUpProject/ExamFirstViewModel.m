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
@property (nonatomic, strong) NSMutableArray<ExerciseModel> * exercisesModel;
@property (nonatomic, strong) NSMutableArray<RACSignal *> * exercisesFullyLoaded;
@end

@implementation ExamFirstViewModel

- (id)initWithDataModel:(ExamModel *)dataModel WebController:(WebController *)webController {
    self = [super init];
    if (self) {
        self.webController = webController;
        self.dataModel = dataModel;
        [self initialize];
        [self.webController addTaskForObject:self toURL:@"https://demo5748745.mockable.io/exam/"];
    }
    return self;
}

- (void)initialize {
    self.examLoaded = NO;
    self.exercisesFullyLoaded = [[NSMutableArray alloc] init];
    self.exercises = [[NSMutableArray alloc] init];
}


- (ExamViewModel *)prepareForSegueWithIdentifier:(NSString *)segueIdentifier {
    ExamViewModel * examViewModel;
    if ([segueIdentifier isEqualToString:@"startExamSegue"]) {
        examViewModel = [[ExamViewModel alloc] initWithExercises:self.exercises dataModel:self.dataModel];
    }
    return examViewModel;
}

- (void)didReceiveData:(nullable NSData *)data withError:(nullable NSError *)error {
    
    //Create Exam here according to JSON Model
    NSError * parseError;
    //Second test
    self.exercisesModel = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &parseError];
    self.exercises = [[NSMutableArray alloc] initWithCapacity:[self.exercisesModel count]];
    for (NSDictionary * exerciseModelDict in self.exercisesModel) {
        NSError * initError;
        ExerciseModel * exerciseModel = [[ExerciseModel alloc] initWithDictionary:exerciseModelDict error:&initError];
        ExerciseViewModel * exerciseViewModel = [[ExerciseViewModel alloc] initWithDataModel:exerciseModel WebController:self.webController mediaURL:@"http://dev-digup-01.dev.etr.eastbanctech.ru:81/Stream/Blob/"];
        [self.exercises addObject:exerciseViewModel];
        RACSignal * mediaLoaded = RACObserve(exerciseViewModel, mediasLoaded);
        [self.exercisesFullyLoaded addObject:mediaLoaded];
    }
    
    //Enable the exam only when all the medias in every exercises are downloaded
    RAC(self, examLoaded) = [[RACSignal combineLatest:self.exercisesFullyLoaded] map:^id(RACTuple * value) {
        NSArray * values = value.allObjects;
        NSNumber * done = @YES;
        for (NSNumber * mediasLoaded in values) {
            if (![mediasLoaded boolValue]) {
                
                done = @NO;
                break;
            }
        }
        return done;
    }];
}

@end
