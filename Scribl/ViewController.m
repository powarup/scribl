//
//  ViewController.m
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import "ViewController.h"
#import "JPTaskFetcher.h"
#import "JPTaskTextStorage.h"
#import "JPTextTask.h"

@interface ViewController ()

@property (nonatomic, strong) JPTaskTextStorage *textStorage;
@property BOOL showingCompleted;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //setup buttons
  
  [self.syncButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  [self.helpButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  [self.completedButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  
  //setup text view
  
  self.textStorage = [JPTaskTextStorage new];
  [[JPTaskFetcher defaultTaskFetcher] setTextStorage:self.textStorage];
  
  CGRect textViewRect = self.textView.bounds;
  
  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
  
  CGSize containerSize = CGSizeMake(textViewRect.size.width,  CGFLOAT_MAX);
  NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
  container.widthTracksTextView = YES;
  [layoutManager addTextContainer:container];
  [self.textStorage addLayoutManager:layoutManager];
  
  UITextView *smartTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.textViewContainer.frame.size.width, self.textViewContainer.frame.size.height) textContainer:container];
  smartTextView.font = [UIFont fontWithName:@"Archer-Bold" size:20];
  smartTextView.backgroundColor = [UIColor clearColor];
  
  self.textView = smartTextView;
  [self.textViewContainer addSubview:smartTextView];
  self.textView.delegate = self;
  
  
}

-(void)completePressed:(id)sender {
  
  if (self.showingCompleted) {
    NSString *newText = @"show completed";
    
    [UIView transitionWithView:self.completedButton duration:0.3 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
      [self.completedButton setTitle:newText forState:UIControlStateNormal];
      
    } completion:nil];
    self.showingCompleted = NO;
  } else {
    NSString *newText = @"hide completed";
    
    [UIView transitionWithView:self.completedButton duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
      [self.completedButton setTitle:newText forState:UIControlStateNormal];
      
    } completion:nil];
    self.showingCompleted = YES;
  }
}

-(void)syncPressed:(id)sender {
  for (JPTextTask *task in self.textStorage.textTasks) {
    [task sync];
  } 
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
