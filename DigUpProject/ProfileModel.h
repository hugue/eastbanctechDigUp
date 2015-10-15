//
//  ProfileModel.h
//  DigUpProject
//
//  Created by hugues on 15/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "JSONModel.h"
#import "CourseModel.h"

@interface ProfileModel : JSONModel

@property (nonatomic, strong) NSArray<CourseModel> * courses;
@property (nonatomic, strong) NSString * userName;

@end
