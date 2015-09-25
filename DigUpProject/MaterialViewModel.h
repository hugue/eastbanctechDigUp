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


enum MaterialAnswerMode : NSUInteger {
    isUndefined = 0,
    isCorrect = 1,
    isNotCorrect = 2
};

@interface MaterialViewModel : NSObject

@property (nonatomic, strong) MaterialModel * material;
@property (nonatomic) NSNumber * materialID;

@property (nonatomic) CGPoint position;
@property (nonatomic) NSUInteger zPosition;
@property (nonatomic) float materialHeight;
@property (nonatomic) float materialWidth;
@property (nonatomic) CGPoint posForDraggedMaterial;
@property (nonatomic) enum MaterialAnswerMode answerMode;
@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * droppedElements;
@property (nonatomic, strong) MaterialViewModel * currentDropTarget;

- (id)initWithModel:(MaterialModel *)materialModel;
- (void)positionNewDraggedMaterial:(MaterialViewModel *)draggedMaterial;
- (void)removeDroppedElement:(MaterialViewModel *)removedElement;

@end

