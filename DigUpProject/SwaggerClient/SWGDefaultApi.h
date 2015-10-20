#import <Foundation/Foundation.h>
#import "SWGUser.h"
#import "SWGObject.h"
#import "SWGApiClient.h"


/**
 * NOTE: This class is auto generated by the swagger code generator program. 
 * https://github.com/swagger-api/swagger-codegen 
 * Do not edit the class manually.
 */

@interface SWGDefaultApi: NSObject

@property(nonatomic, assign)SWGApiClient *apiClient;

-(instancetype) initWithApiClient:(SWGApiClient *)apiClient;
-(void) addHeader:(NSString*)value forKey:(NSString*)key;
-(unsigned long) requestQueueSize;
+(SWGDefaultApi*) apiWithHeader:(NSString*)headerValue key:(NSString*)key;
+(SWGDefaultApi*) sharedAPI;
///
///
/// 
/// Get the user s profile in JSON format
///
/// 
///
/// @return SWGUser*
-(NSNumber*) profileGetWithCompletionBlock :
    (void (^)(SWGUser* output, NSError* error))completionBlock;
    


///
///
/// 
/// Testing how to post data on mockable
///
/// 
///
/// @return NSString*
-(NSNumber*) testPostPostWithCompletionBlock :
    (void (^)(NSString* output, NSError* error))completionBlock;
    



@end
