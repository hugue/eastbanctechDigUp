//
//  MaterialViewModel.h
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "MaterialModel.h"
#import "DataControllerProtocol.h"


typedef NS_ENUM(NSInteger, MaterialAnswerState) {
    MaterialAnswerStateIsTesting,
    MaterialAnswerStateIsUndefined,
    MaterialAnswerStateIsCorrect,
    MaterialAnswerStateIsAlternative,
    MaterialAnswerStateIsNotCorrect
};

@interface MaterialViewModel : NSObject <DataControllerProtocol>

@property (nonatomic, strong) MaterialModel * material;
@property (nonatomic) NSNumber * materialID;

@property (nonatomic) CGPoint position;
@property (nonatomic) NSUInteger zPosition;
@property (nonatomic) float materialHeight;
@property (nonatomic) float materialWidth;
@property (nonatomic) CGPoint posForDraggedMaterial;

@property (nonatomic) enum MaterialAnswerState answerState;
@property (nonatomic, weak) MaterialViewModel * currentDropTarget;
@property (nonatomic, strong) NSNumber  * correctDropTargetID;

- (id)initWithModel:(MaterialModel *)materialModel;
- (void)positionNewDraggedMaterial:(MaterialViewModel *)draggedMaterial;
- (void)resetPosition;
- (void)correctionAsked;
- (void)solutionAsked;
- (void)restartAsked;

- (void)applyDataToMaterial:(NSData *)data;
- (NSString *)makeDownloadURLFormURL:(NSString *)url;

@end

