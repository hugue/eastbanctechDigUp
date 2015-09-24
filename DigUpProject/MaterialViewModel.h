//
//  MaterialViewModel.h
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MaterialModel.h"

@interface MaterialViewModel : NSObject

@property (nonatomic, strong) MaterialModel * material;
@property (nonatomic) NSNumber * materialID;

@property (nonatomic) CGPoint position;
@property (nonatomic) CGPoint posForDraggedMaterial;
@property (nonatomic) float materialHeight;
@property (nonatomic) float materialWidth;
@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * droppedElements;
@property (nonatomic, strong) MaterialViewModel * currentDropTarget;

- (id) initWithModel:(MaterialModel *) materialModel;
- (void) positionNewDraggedMaterial:(MaterialViewModel *) draggedMaterial;
- (void) removeDroppedElement:(MaterialViewModel *) removedElement;

@end
