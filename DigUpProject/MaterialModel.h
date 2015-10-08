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

@property (nonatomic, strong)      NSString<Optional> * $id;
@property (nonatomic, strong)      NSString<Optional> * $type;
@property (nonatomic, strong)      NSString<Optional> * Exercise;
@property (nonatomic, strong)      NSNumber<Optional> * ExerciseId;
@property (nonatomic, strong)      NSNumber<Optional> * ParentId;
@property (nonatomic, strong)      NSString<Optional> * Parent;

@property (nonatomic, strong)      NSNumber<Optional> * DropTargetId;
@property (nonatomic, strong)      MaterialModel<Optional> * DropTarget;
@property (nonatomic, strong)      NSArray<MaterialModel, Optional> * DropElements;

@property (nonatomic, strong)      NSNumber<Optional> * BlobId;
@property (nonatomic, strong)      NSString<Optional> * Blob;
@property (nonatomic, strong)      NSNumber<Optional> * Id;
@property (nonatomic, strong)      NSString<Optional> * Name;
@property (nonatomic, strong)      NSString<Optional> * Type;
@property (nonatomic, strong)      NSNumber<Optional> * X;
@property (nonatomic, strong)      NSNumber<Optional> * Y;
@property (nonatomic, strong)      NSNumber<Optional> * Z;
@property (nonatomic, strong)      NSNumber<Optional> * Width;
@property (nonatomic, strong)      NSNumber<Optional> * Height;
@property (nonatomic, strong)      NSString<Optional> * Behavior;
@property (nonatomic, strong)      NSNumber<Optional> * Composition;
@property (nonatomic, strong)      NSNumber<Optional> * FakeTargetId;
@property (nonatomic, strong)      NSString<Optional> * Text;
@property (nonatomic, strong)      NSString<Optional> * Value;
@property (nonatomic, strong)      NSString<Optional> * Style;
@property (nonatomic, strong)      NSString<Optional> * Autoplay;
@property (nonatomic, strong)      NSString<Optional> * Show;

@property (nonatomic, strong)      NSString<Optional> * $ref;

@end


