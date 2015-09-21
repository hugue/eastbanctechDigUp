//
//  TableViewModel.h
//  DigUpProject
//
//  Created by hugues on 15/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TFHpple.h"
#import "MaterialViewModel.h"
#import "RadioButtonsController.h"
#import "CellViewModel.h"

@interface TableViewModel : MaterialViewModel

@property (nonatomic) NSUInteger numberOfLines;
@property (nonatomic) NSUInteger numberOfColumns;

@property (nonatomic, strong) NSMutableDictionary<NSString *, RadioButtonsController *> * buttonsControllers;

@property (nonatomic, strong) NSMutableArray<CellViewModel *> * cellsModels;

- (id) initWithModel:(MaterialModel *)materialModel;

@end
