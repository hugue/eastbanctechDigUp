#import <Foundation/Foundation.h>
#import "SWGObject.h"

/**
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen
 * Do not edit the class manually.
 */

#import "SWGCourse.h"


@protocol SWGUser
@end

@interface SWGUser : SWGObject

/* Login under which the user is registered in data base 
 */
@property(nonatomic) NSString* userName;
/* An array of all the courses this user has access to [optional]
 */
@property(nonatomic) NSArray<SWGCourse>* courses;

@end