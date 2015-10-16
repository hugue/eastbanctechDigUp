//
//  DragNDropController.h
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialViewModel.h"

@interface DragNDropController : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, MaterialViewModel *> * targetElements;
@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * dropElements;

- (BOOL)pointIsInTargetElement:(CGPoint)point forMaterial:(MaterialViewModel *)draggedMaterial;
- (id)init;
- (void)restartAsked;
- (void)solutionAsked;
- (NSArray<NSNumber *> *)correctionAskedWithDisplay:(BOOL)displayEnabled;
- (void)ajustElementsZPotision:(NSUInteger)targetMaxZPosition;

@end
