//
//  DragElementRecognizer.h
//  DigUpProject
//
//  Created by hugues on 18/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialView.h"

@interface DragElementRecognizer : UIPanGestureRecognizer

@property (nonatomic, strong) MaterialView * draggedMaterial;

@end
