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


typedef NS_ENUM(NSInteger, MaterialDisplayState) {
    MaterialDisplayStateIsNormal,
    MaterialDisplayStateIsCorrect,
    MaterialDisplayStateIsAlternative,
    MaterialDisplayStateIsNotCorrect
};

typedef NS_ENUM(NSInteger, MaterialCurrentState) {
    MaterialCurrentStateGoingOn,
    MaterialCurrentStateStopped
};

typedef NS_ENUM(NSInteger, MaterialAnswerState) {
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

@property (nonatomic) enum MaterialDisplayState displayState;
@property (nonatomic) enum MaterialCurrentState materialState;

@property (nonatomic, weak) MaterialViewModel * currentDropTarget;
@property (nonatomic, strong) NSNumber  * correctDropTargetID;

- (id)initWithModel:(MaterialModel *)materialModel;
- (void)positionNewDraggedMaterial:(MaterialViewModel *)draggedMaterial;
- (void)resetPosition;

- (MaterialAnswerState)correctionAskedWithDisplay:(BOOL)displayEnabled;

- (void)solutionAsked;
- (void)restartAsked;

- (void)applyDataToMaterial:(NSData *)data;
- (NSString *)makeDownloadURLFormURL:(NSString *)url;

@end

