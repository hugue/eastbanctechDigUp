//
//  CourseViewController.h
//  DigUpProject
//
//  Created by hugues on 02/10/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CourseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView * documentView;
@property (nonatomic, strong) NSString * courseToDisplay;

- (IBAction)doTestButton:(id)sender;

@end
