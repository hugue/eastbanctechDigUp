#import <Foundation/Foundation.h>
#import "SWGObject.h"

/**
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen
 * Do not edit the class manually.
 */

#import "SWGSubcourse.h"
#import "SWGExam.h"


@protocol SWGCourse
@end

@interface SWGCourse : SWGObject


@property(nonatomic) NSString* name;

@property(nonatomic) NSArray<SWGSubcourse>* subcourses;

@property(nonatomic) SWGExam* exam;

@end