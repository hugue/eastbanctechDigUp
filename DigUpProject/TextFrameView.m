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
        self.textStyle = self.viewModel.material.style;
        
       CGRect  frame =  CGRectMake( self.viewModel.position.x,
                                    self.viewModel.position.y,
                                    self.viewModel.materialWidth,
                                    self.viewModel.materialHeight);
        self.viewDisplayed = [[UILabel alloc] initWithFrame:frame];
        self.viewDisplayed.numberOfLines = 0;
        
        
        NSError * htmlError;
        NSAttributedString * displayedText = [[NSAttributedString alloc]
                                             initWithData: [materialViewModel.material.text dataUsingEncoding:NSUTF8StringEncoding]
                                             options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                             documentAttributes: nil
                                             error: &htmlError];
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.viewDisplayed.attributedText = displayedText;
            self.viewDisplayed.text = materialViewModel.material.text;
        });
        
        if(htmlError) {
            NSLog(@"Unable to parse label text: %@", htmlError);
        }
        [self applyStyle:self.textStyle toLabel:self.viewDisplayed];
    }
    return self;
}

-(void)applyStyle:(NSString *)style toLabel:(UILabel *)label {
    if ([style isEqualToString:@"text-u1"]) {
        [label setFont:[UIFont fontWithName:@"ForwardSans-Bold" size:14]];
        label.textColor = [UIColor blueColor];
    }
    else if([style isEqualToString:@"text-number_big"]) {
        [label setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:50]];
        //label.textColor = [UIColor blueColor];
    }
    else if([style isEqualToString:@""]) {
        [label setFont:[UIFont fontWithName:@"ForwardSans-Regular" size:14]];
    }

}

@end
