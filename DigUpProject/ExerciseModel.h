//
//  ExerciceModel.h
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialModel.h"

@interface ExerciseModel : JSONModel

@property (nonatomic, strong) NSMutableArray<MaterialModel *> * materialsObject;
@property (nonatomic, strong) NSString<Optional> * exerciseType;

@end

@protocol ExerciseModel
@end