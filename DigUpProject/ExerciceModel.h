//
//  ExerciceModel.h
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialModel.h"

@interface ExerciceModel : JSONModel

@property (nonatomic, strong) NSArray<MaterialModel> * materials;
@property (nonatomic, strong) NSMutableArray<MaterialModel *> * materialsObject;
@property (nonatomic, strong) NSString * exerciseType;

- (id) initWithData:(NSData *)data error:(NSError *) error;

@end
