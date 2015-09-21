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

- (id) initWithModel:(MaterialModel *) materialModel;

@end
