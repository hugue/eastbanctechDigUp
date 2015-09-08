//
//  ViewController.m
//  DigUpProject
//
//  Created by hugues on 07/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.webSearcherController  = [[WebSearcherController alloc] init];
    self.webSearcherController.delegate = self;
    //self.currentExercise = [[ExerciceModel alloc] init];
    [HUD showUIBlockingIndicatorWithText:@"Fetching JSON"];
    [self.webSearcherController launchSession];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*Function creating the new UI objects according to the type
 propriety given by the JSON data*/

- (void) displayExercise {
    for (int i = 0; i < [self.currentExercise.materialsObject count]; i++) {
        NSString * type = self.currentExercise.materialsObject[i].Type;
        NSUInteger height = self.currentExercise.materialsObject[i].Height;
        NSUInteger width = self.currentExercise.materialsObject[i].Width;
        NSUInteger x = self.currentExercise.materialsObject[i].X;
        NSUInteger y = self.currentExercise.materialsObject[i].Y;
        NSString * name = self.currentExercise.materialsObject[i].Name;

        
        if ([type isEqualToString:@"Text"]) {
            UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
            textLabel.numberOfLines = 0;
            NSError * htmlError;
            textLabel.attributedText = [[NSAttributedString alloc]
                              initWithData: [self.currentExercise.materialsObject[i].Text dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: &htmlError];
            if(htmlError) {
                NSLog(@"Unable to parse label text: %@", htmlError);
            }
            [self.scrollView addSubview: textLabel];
        }
        else if ([type isEqualToString:@"RadioButton"]) {
            UIImage * imageButton = [UIImage imageNamed:@"RadioButton-Unselected"];
            UIImageView * radioButton = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [radioButton setImage:imageButton];
            [self.scrollView addSubview:radioButton];
        }
        else if ([type isEqualToString:@"Rectangle"]) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [self.scrollView addSubview:view];
            
        }
        else if ([type isEqualToString:@"Image"]) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            UIImage * image = [UIImage imageNamed:name];
            [imageView setImage:image];
            [self.scrollView addSubview:imageView];
            
        }
        
        //Adapt the scroll view to the new subViews
        if (width + x > self.scrollView.contentSize.width) {
            self.scrollView.contentSize = CGSizeMake(width + x, self.scrollView.frame.size.height);
        }
        if (height + y > self.scrollView.contentSize.height) {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height + y);
        }

    }
}

#pragma mark - WebSearcherControllerDelegate Methods

- (void) WebSearcherController:(WebSearcherController *)webSearcherController didReceiveData:(nullable NSData *)data withError: (nullable NSError *) error{
    NSLog(@"Received data");
    [HUD hideUIBlockingIndicator];
    if (error) {
        NSLog(@"Connection stopped with error : %@", error);
    }
    else {
        NSError * initError;
        self.currentExercise = [[ExerciceModel alloc] initWithData:data error: initError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayExercise];
        });
        
        if(error) {
            NSLog(@"Error : %@", error);
        }
    }
}
@end
