//
//  ExamRunningViewModel.h
//  DigUpProject
//
//  Created by hugues on 09/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewModel.h"

@interface ExamRunningViewModel : NSObject

@property (nonatomic, strong) NSArray<MainViewModel *> * exercises;
@property (nonatomic, strong) NSTimer * countDownTimer;
@property (nonatomic) NSUInteger allowedTime;

@end
