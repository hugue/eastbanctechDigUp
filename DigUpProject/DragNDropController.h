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

@property (nonatomic, strong) NSMutableDictionary * dragDropElements;
@property (nonatomic, strong) NSMutableArray<MaterialViewModel *> * targetElements;

- (BOOL) pointIsInTargetElement:(CGPoint) point;
- (id) init;

@end
