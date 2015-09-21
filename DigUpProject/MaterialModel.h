//
//  MaterialModel.h
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel/JSONModel/JSONModel.h"

@interface MaterialModel : JSONModel

@property (nonatomic, strong)      NSString * $id;
@property (nonatomic, strong)      NSString * $type;
@property (nonatomic, strong)      NSString<Optional> * Exercise;
@property (nonatomic)              NSNumber<Optional> * ExerciseId;
@property (nonatomic)              NSNumber<Optional> * ParentId;
@property (nonatomic, strong)      NSString<Optional> * Parent;
@property (nonatomic)              NSNumber<Optional> * DropTargetId;
@property (nonatomic, strong)      NSString<Optional> * DropTarget;
@property (nonatomic)              NSNumber<Optional> * BlobId;
@property (nonatomic, strong)      NSString<Optional> * Blob;
@property (nonatomic)              NSNumber<Optional> * Id;
@property (nonatomic, strong)      NSString * Name;
@property (nonatomic, strong)      NSString * Type;
@property (nonatomic)              NSUInteger X;
@property (nonatomic)              NSUInteger Y;
@property (nonatomic)              NSUInteger Z;
@property (nonatomic)              NSUInteger Width;
@property (nonatomic)              NSUInteger Height;
@property (nonatomic, strong)      NSString * Behavior;
@property (nonatomic)              BOOL       Composition;
@property (nonatomic)              NSUInteger FakeTargetId;
@property (nonatomic, strong)      NSString<Optional> * Text;
@property (nonatomic, strong)      NSString<Optional> * Value;
@property (nonatomic, strong)      NSString<Optional> * Style;
@property (nonatomic, strong)      NSString<Optional> * Reply;
@property (nonatomic)              NSString<Optional> * AutoPlay;
@property (nonatomic)              NSString<Optional> * Show;

@end

@protocol MaterialModel
@end
