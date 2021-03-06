//
//  ViewController.h
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *textViewContainer;
@property (nonatomic, strong) IBOutlet UIButton *syncButton;
@property (nonatomic, strong) IBOutlet UIButton *helpButton;
@property (nonatomic, strong) IBOutlet UIButton *completedButton;

-(IBAction)syncPressed:(id)sender;
-(IBAction)completePressed:(id)sender;

@end

