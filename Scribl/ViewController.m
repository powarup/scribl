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

@interface ViewController ()

@property (nonatomic, strong) JPTaskTextStorage *textStorage;
@property BOOL showingCompleted;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [JPTaskFetcher defaultTaskFetcher];
  
  //setup buttons
  
  [self.sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  [self.helpButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  [self.completedButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  
  //setup text view
  
  self.textStorage = [JPTaskTextStorage new];
  
  CGRect textViewRect = self.textView.bounds;
  
  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
  
  CGSize containerSize = CGSizeMake(textViewRect.size.width,  CGFLOAT_MAX);
  NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
  container.widthTracksTextView = YES;
  [layoutManager addTextContainer:container];
  [self.textStorage addLayoutManager:layoutManager];
  
  UITextView *smartTextView = [[UITextView alloc] initWithFrame:textViewRect textContainer:container];
  
  self.textView = smartTextView;
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
