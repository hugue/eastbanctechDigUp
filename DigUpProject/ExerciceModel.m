//
//  ExerciceModel.m
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExerciceModel.h"

@implementation ExerciceModel

- (id) initWithData:(NSData *)data error:(NSError *)error {
    self = [super init];
    if (self) {
        self.materials = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
        self.materialsObject = [[NSMutableArray alloc] initWithCapacity:[self.materials count]];
        
        for (int i = 0; i < self.materials.count; i++) {
            NSError * initError;
            MaterialModel * material = [[MaterialModel  alloc] initWithDictionary:self.materials[i] error: &initError];
            if (initError) {
                NSLog(@"%@", initError );
            }
            NSLog(@"Identifier is %d", material.$id );
            NSLog(@"%@",material.DropTarget);
            
            [self.materialsObject addObject:material];
        }
    }
    return self;
}

@end
