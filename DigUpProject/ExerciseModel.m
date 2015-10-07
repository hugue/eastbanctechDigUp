//
//  ExerciceModel.m
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExerciseModel.h"

@interface ExerciseModel()

@property (nonatomic, strong) NSArray<MaterialModel> * materials;
@property (nonatomic, strong) NSMutableDictionary<NSString *, MaterialModel *> * referencedModels;

@end

@implementation ExerciseModel

- (id) initWithData:(NSData *)data error:(NSError *)error {
    self = [super init];
    if (self) {
        self.materials = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
        self.materialsObject = [[NSMutableArray alloc] initWithCapacity:[self.materials count]];
        self.referencedModels = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < self.materials.count; i++) {
            NSError * initError;
            MaterialModel * material = [self addNewMaterialWithDictionary:self.materials[i]];
            if (initError) {
                NSLog(@"%@", initError );
            }
            
            [self.materialsObject addObject:material];
        }
    }
    return self;
}

- (MaterialModel *) addNewMaterialWithDictionary:(NSDictionary *) materialInfo {
    //This is a reference, so look at the info in the dicionary for referenced models
    if (materialInfo[@"$ref"]) {
        MaterialModel * referencedModel = self.referencedModels[materialInfo[@"$ref"]];
        [self createReferencedModels:referencedModel];
        return referencedModel;
    }
    
    NSError * initError;
    MaterialModel * material = [[MaterialModel alloc] initWithDictionary:materialInfo error:&initError];
    if (initError) {
        NSLog(@"%@", initError );
    }

    [self createReferencedModels:material];
    return material;
}

- (void) createReferencedModels:(MaterialModel *) material {
    //If this material creates other materials, register it in the dictionary so we know were to look at when we find the references
    if (material.DropElements) {
        for(MaterialModel * referencedMaterial in material.DropElements) {
            //If this is not a reference but a real model, store it
            if(referencedMaterial.$id) {
                [self.referencedModels setObject:referencedMaterial forKey:referencedMaterial.$id];
                [self createReferencedModels:referencedMaterial];
            }
        }
    }
    else if(material.DropTarget) {
        //If this is not a reference but a real model, store it
        if(material.DropTarget.$id) {
            [self.referencedModels setObject:material.DropTarget forKey:material.DropTarget.$id];
            [self createReferencedModels:material.DropTarget];
        }
    }
}
@end
