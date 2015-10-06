//
//  CourseModel.h
//  DigUpProject
//
//  Created by hugues on 05/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject

@property (nonatomic, strong) NSString * courseTitle;
@property (nonatomic, strong) NSArray<NSString *> * documentsTitle;

- (id)initWithTitle:(NSString *)title AndDocuments:(NSArray<NSString *> *)titleDocs;

@end
