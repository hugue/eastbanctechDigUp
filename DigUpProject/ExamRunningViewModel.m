//
//  ExamRunningViewModel.m
//  DigUpProject
//
//  Created by hugues on 09/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ExamRunningViewModel.h"

@implementation ExamRunningViewModel

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
   
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRemantTime:) userInfo:nil repeats:YES];
}


@end
