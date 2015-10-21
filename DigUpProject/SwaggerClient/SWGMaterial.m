#import "SWGMaterial.h"

@implementation SWGMaterial

/**
 * Maps json key to property name.
 * This method is used by `JSONModel`.
 */
+ (JSONKeyMapper *)keyMapper
{
  return [[JSONKeyMapper alloc] initWithDictionary:@{ @"$id": @"id", @"$type": @"seqType", @"Exercise": @"exercise", @"ExerciseId": @"exerciseId", @"Parent": @"parent", @"DropTargetId": @"dropTargetId", @"DropTarget": @"dropTarget", @"DropElements": @"dropElements", @"BlobId": @"blobId", @"Blob": @"blob", @"Id": @"handlingId", @"Name": @"name", @"Type": @"type", @"X": @"X", @"Y": @"Y", @"Z": @"Z", @"Width": @"width", @"Height": @"height", @"Behavior": @"behavior", @"Composition": @"composition", @"FakeTargetId": @"fakeTargetId", @"Text": @"text", @"Value": @"value", @"Style": @"style", @"Autoplay": @"autoplay", @"Show": @"show", @"$ref": @"ref" }];
}

/**
 * Indicates whether the property with the given name is optional.
 * If `propertyName` is optional, then return `YES`, otherwise return `NO`.
 * This method is used by `JSONModel`.
 */
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
  NSArray *optionalProperties = @[@"id", @"seqType", @"exercise", @"exerciseId", @"parent", @"dropTargetId", @"dropTarget", @"dropElements", @"blobId", @"blob", @"handlingId", @"name", @"type", @"X", @"Y", @"Z", @"width", @"height", @"behavior", @"composition", @"fakeTargetId", @"text", @"value", @"style", @"autoplay", @"show", @"ref"];

  if ([optionalProperties containsObject:propertyName]) {
    return YES;
  }
  else {
    return NO;
  }
}

/**
 * Gets the string presentation of the object.
 * This method will be called when logging model object using `NSLog`.
 */
- (NSString *)description {
    return [[self toDictionary] description];
}

@end
