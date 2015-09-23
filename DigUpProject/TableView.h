//
//  TableView.h
//  DigUpProject
//
//  Created by hugues on 15/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "MaterialView.h"
#import "TableViewModel.h"
#import "CellViewModel.h"
#import <WebKit/WebKit.h>

@interface TableView : MaterialView <UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray<UIView *> * cellViewsDisplayed;
//@property (nonatomic, strong) UIView * viewDisplayed;
@property (nonatomic, strong) UIWebView * viewDisplayed;
@property (nonatomic, strong) TableViewModel * viewModel;

@end
