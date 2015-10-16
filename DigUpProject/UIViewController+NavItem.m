//
//  UIViewController+NavItem.m
//  TestBack
//
//  Created by Alexey Bromot on 16/10/15.
//  Copyright © 2015 EastBanc Technologies Russia. All rights reserved.
//

#import "UIViewController+NavItem.h"
#import <objc/runtime.h>

@implementation UIViewController (NavItem)

+ (void)load
{
    Method customViewDidLoad = class_getInstanceMethod(self, @selector(customViewDidLoad));
    Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
    method_exchangeImplementations(viewDidLoad , customViewDidLoad);
}

- (void)customViewDidLoad
{
    [self customViewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem.title = @" ";
}


@end
