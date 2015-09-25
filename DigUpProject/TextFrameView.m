//
//  TextFrameView.m
//  DigUpProject
//
//  Created by hugues on 10/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TextFrameView.h"

@interface TextFrameView ()
@property (nonatomic, strong) NSString * textStyle;

@end

@implementation TextFrameView

@dynamic viewDisplayed;

- (id)initWithViewModel:(MaterialViewModel *)materialViewModel; {
    self = [super initWithViewModel: materialViewModel];
    if (self) {
        self.textStyle = self.viewModel.material.Style;
        
       CGRect  frame =  CGRectMake( self.viewModel.position.x,
                                    self.viewModel.position.y,
                                    self.viewModel.materialWidth,
                                    self.viewModel.materialHeight);
        self.viewDisplayed = [[UILabel alloc] initWithFrame:frame];
        self.viewDisplayed.numberOfLines = 0;
        
        
        NSError * htmlError;
        self.viewDisplayed.attributedText = [[NSAttributedString alloc]
                               initWithData: [materialViewModel.material.Text dataUsingEncoding:NSUTF8StringEncoding]
                               options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                               documentAttributes: nil
                               error: &htmlError];
        if(htmlError) {
            NSLog(@"Unable to parse label text: %@", htmlError);
        }
        [self configureText];
    }
    return self;
}

- (void)configureText {
    //Analyse text style
    if ([self.textStyle isEqualToString:@"text-u1"]) {
        [self.viewDisplayed setFont:[UIFont fontWithName:@"ForwardSans-Bold" size:18]];
        self.viewDisplayed.textColor = [UIColor blueColor];
    }
    else if([self.textStyle isEqualToString:@"text-number_big"]) {
        [self.viewDisplayed setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:50]];
        //self.viewDisplayed.textColor = [UIColor blueColor];
    }
    else if([self.textStyle isEqualToString:@""]) {
        [self.viewDisplayed setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:18]];
    }
}
@end
