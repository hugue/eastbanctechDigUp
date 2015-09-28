//
//  MaterialModel.h
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel/JSONModel/JSONModel.h"

/*
 All keys are optional to make it possible to tell the difference
 between a reference and a real object in JSON parsing
 
 - Possible Fix : Implement a function to check that if not a
 reference, then the important keys are not null
 */
@protocol MaterialModel
@end

@interface MaterialModel : JSONModel

@property (nonatomic, assign)      NSString<Optional> * $id;
@property (nonatomic, strong)      NSString<Optional> * $type;
@property (nonatomic, strong)      NSString<Optional> * Exercise;
@property (nonatomic)              NSNumber<Optional> * ExerciseId;
@property (nonatomic)              NSNumber<Optional> * ParentId;
@property (nonatomic, strong)      NSString<Optional> * Parent;

@property (nonatomic)              NSNumber<Optional> * DropTargetId;
@property (nonatomic, strong)      MaterialModel<Optional> * DropTarget;
@property (nonatomic, strong)      NSArray<MaterialModel, Optional> * DropElements;

@property (nonatomic)              NSNumber<Optional> * BlobId;
@property (nonatomic, strong)      NSString<Optional> * Blob;
@property (nonatomic, strong)      NSNumber<Optional> * Id;
@property (nonatomic, strong)      NSString<Optional> * Name;
@property (nonatomic, strong)      NSString<Optional> * Type;
@property (nonatomic)              NSNumber<Optional> * X;
@property (nonatomic)              NSNumber<Optional> * Y;
@property (nonatomic)              NSNumber<Optional> * Z;
@property (nonatomic)              NSNumber<Optional> * Width;
@property (nonatomic)              NSNumber<Optional> * Height;
@property (nonatomic, strong)      NSString<Optional> * Behavior;
@property (nonatomic)              NSNumber<Optional> * Composition;
@property (nonatomic)              NSNumber<Optional> * FakeTargetId;
@property (nonatomic, strong)      NSString<Optional> * Text;
@property (nonatomic, strong)      NSString<Optional> * Value;
@property (nonatomic, strong)      NSString<Optional> * Style;
@property (nonatomic)              NSString<Optional> * AutoPlay;
@property (nonatomic)              NSString<Optional> * Show;

@property (nonatomic, strong)      NSString<Optional> * $ref;

@end


