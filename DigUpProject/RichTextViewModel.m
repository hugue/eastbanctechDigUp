//
//  RichTextViewModel.m
//  DigUpProject
//
//  Created by hugues on 17/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "RichTextViewModel.h"

@implementation RichTextViewModel

- (id)initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (void) initialize {
    NSData * data = [self.material.Text dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple * tableParser = [TFHpple hppleWithHTMLData:data];
    NSString * xPath = @"//p | //h1 | //div";
    NSArray<TFHppleElement *> * labelLines = [tableParser searchWithXPathQuery:xPath];
    
    NSLog(@"%@", labelLines);
    NSLog(@"%lu", labelLines.count);
    
    for (TFHppleElement * element in labelLines) {
        [self parseRichTextForElement:element];
    }
}

- (void) parseRichTextForElement: (TFHppleElement *) richElement {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] init];
    if (richElement.isTextNode) {
        
    }
    if([richElement.tagName isEqualToString:@"p"]) {
        NSLog(@"he is a text node : %d",richElement.isTextNode);
    }
    else if([richElement.tagName isEqualToString:@"h1"]) {
        
    }
    else if([richElement.tagName isEqualToString:@"div"]){
        
    }
    else if([richElement.tagName isEqualToString:@"s"]) {
        
    }
    else {
        NSLog(@"he is a text node ici: %d",richElement.isTextNode);
        NSLog(@"Error: Unknown tag for creating richText");
    }
    
}

@end
