//
//  MenuViewModel.h
//  DigUpProject
//
//  Created by hugues on 01/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuViewModel : NSObject

@property (nonatomic, strong) NSMutableArray * listCourses;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<NSString *> *> * detailCourses;

@property (nonatomic, strong) NSString * selectedCourse;

@end
