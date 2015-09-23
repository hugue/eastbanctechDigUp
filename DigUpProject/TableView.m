//
//  TableView.m
//  DigUpProject
//
//  Created by hugues on 15/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TableView.h"
@interface TableView()
@property (nonatomic) float widthPos;
@property (nonatomic) float heightPos;

@end

@implementation TableView

@dynamic viewDisplayed;
@dynamic viewModel;



- (id) initWithViewModel:(MaterialViewModel *)materialViewModel {
    self = [super initWithViewModel:materialViewModel];
    if (self) {
        CGRect frame =  CGRectMake(self.viewModel.material.X,
                                   self.viewModel.material.Y,
                                   self.viewModel.material.Width,
                                   self.viewModel.material.Height);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDisplayed = [[UIWebView alloc] initWithFrame:frame];
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            NSString * htmlString = [NSString stringWithFormat:@"<html> %@ </html>", self.viewModel.material.Text];
            //NSString * htmlString = @"<html>hello<br>hu</html>";
            [self.viewDisplayed  loadHTMLString:htmlString baseURL: baseURL];
        });
    }
    return self;
}
/*
- (id) initWithViewModel:(MaterialViewModel *)materialViewModel {
    self = [super initWithViewModel:materialViewModel];
    if (self) {
        self.cellViewsDisplayed = [[NSMutableArray alloc] init];
        CGRect frame =  CGRectMake(self.viewModel.material.X,
                                    self.viewModel.material.Y,
                                    self.viewModel.material.Width,
                                    self.viewModel.material.Height);
        
        self.viewDisplayed = [[UIView alloc] initWithFrame:frame];
        self.viewDisplayed.backgroundColor = [UIColor colorWithRed:1 green:222.0/255.0 blue:173.0/255.0 alpha:1];;
        
        self.widthPos = 1;
        self.heightPos = 1;

        for (int i = 0; i < self.viewModel.cellsModels.count; i++) {
            CGRect newFrame = [self computeFrameForViewAtIndex:i];
            UIView * newView = [[UIView alloc] initWithFrame:newFrame];
            [self displayMaterialForCellAtIndex:i ToView:newView];
            [self.viewDisplayed addSubview:newView];
        }
    }
    return self;
}

- (void) updatePosForIndex:(NSUInteger) index ForWidth:(float) width ForHeight:(float) height{
    if (((index +1) % self.viewModel.numberOfColumns) == 0) {
        self.widthPos = 1;
        self.heightPos += height;
    }
    else {
        self.widthPos += width;
    }
}

- (CGRect) computeFrameForViewAtIndex:(NSUInteger) index {
    NSNumber * width = self.viewModel.cellsModels[index].style[@"width"];
    NSNumber * height = self.viewModel.cellsModels[index].style[@"height"];
    
    CGRect frame = CGRectMake(self.widthPos, self.heightPos, [width floatValue]-2, [height floatValue]-2);
    
    [self updatePosForIndex:index ForWidth:[width floatValue] ForHeight:[height floatValue]];
    
    return frame;
}

- (void) displayMaterialForCellAtIndex:(NSUInteger) index ToView:(UIView *) cellView{
    NSArray * materialForCell = self.viewModel.cellsModels[index].cellMaterials;

    if ([self.viewModel.cellsModels[index].rowClass isEqualToString:@"head"]) {
        cellView.backgroundColor = [UIColor colorWithRed:1 green:222.0/255.0 blue:173.0/255.0 alpha:1];
    }
    else {
         cellView.backgroundColor = [UIColor colorWithRed:1 green:248.0/255.0 blue:220.0/255.0 alpha:1];;
    }
    
    for (int i = 0; i < materialForCell.count; i++) {
        if ([materialForCell[i] isKindOfClass:[NSString class]]){
        }
    }
}
*/
@end
