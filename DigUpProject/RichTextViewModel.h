//
//  RichTextViewModel.h
//  DigUpProject
//
//  Created by hugues on 17/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TFHpple.h"
#import "MaterialViewModel.h"

@interface RichTextViewModel : MaterialViewModel

@property (nonatomic, strong) NSArray<NSMutableAttributedString *> * materialForLabels;

- (id) initWithModel:(MaterialModel *)materialModel;
@end
