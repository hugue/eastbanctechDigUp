//
//  CellViewModel.h
//  DigUpProject
//
//  Created by hugues on 16/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialViewModel.h"

@interface CellViewModel : NSObject

@property (nonatomic, strong) NSString * rowClass;
@property (nonatomic, strong) NSString * cellClass;
@property (nonatomic, strong) NSMutableDictionary * style;
@property (nonatomic) BOOL contentEditable;

@property (nonatomic, strong) NSMutableArray * cellMaterials;

- (id) init;

@end
