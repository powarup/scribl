//
//  JPTextTask.m
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import "JPTextTask.h"

@interface JPTextTask ()

@property (nonatomic, weak) PKTTask* task;
@property (nonatomic, copy) NSString* parentString;
@property (nonatomic, copy) NSString* basicText;
@property (nonatomic, copy) NSDate* due;
@property (nonatomic) BOOL completed;

@end

@implementation JPTextTask

-(instancetype)initWithTask:(PKTTask *)task range:(NSRange)range parentString:(NSString *)parentString {
  self = [super init];
  if (self) {
    _task = task;
    _completed = task.status == PKTTaskStatusCompleted;
    _range = range;
    _parentString = parentString;
  }
  return self;
}

-(void)sync {
  if (self.willDelete) {
    PKTAsyncTask *deleteTask = [self.task deleteTask];
    [deleteTask onComplete:^(id result, NSError *error) {
      if (!error) {
        NSLog(@"deleted task");
      } else {
        NSLog(@"%@",error.description);
      }
    }];
  } else {
    [self decodeText];
    if (![self.basicText isEqualToString:self.task.text]) {
      self.task.text = self.basicText;
    }
    
    if (![self.due isEqualToDate:self.task.dueOn]) { //TODO: change to is same date
      self.task.dueOn = self.due;
    }
    
    BOOL changingCompletion = self.completed ^ (self.task.status == PKTTaskStatusCompleted);
    
    PKTAsyncTask *saveTask = [self.task save];
    [saveTask onComplete:^(id result, NSError *error) {
      if (changingCompletion) {
        PKTAsyncTask *completeTask = [self.task complete];
        [completeTask onComplete:^(id result, NSError *error) {
          NSLog(@"completed");
        }];
      }
    }];
  }
}

-(void)decodeText {
  NSMutableString *text = [[self.parentString substringWithRange:self.range] mutableCopy];
  self.completed = [text containsString:@"@done"];
  
  if (self.completed) {
    text = [[text stringByReplacingOccurrencesOfString:@"@done" withString:@""] mutableCopy];
  }
  
  static NSRegularExpression *todayExpression;
  NSError *error = nil;
  NSString *todayPattern = @"(due| for| by| before)? today";
  todayExpression = todayExpression ?: [NSRegularExpression regularExpressionWithPattern:todayPattern
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
  
  static NSRegularExpression *tomorrowExpression;
  NSString *tomorrowPattern = @"( due| for| by| before)? tomorrow";
  tomorrowExpression = tomorrowExpression ?: [NSRegularExpression regularExpressionWithPattern:tomorrowPattern
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
  
  static NSRegularExpression *yesterdayExpression;
  NSString *yesterdayPattern = @"( due| for| by| before)? yesterday";
  yesterdayExpression = yesterdayExpression ?: [NSRegularExpression regularExpressionWithPattern:yesterdayPattern
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
  
  static NSRegularExpression *dueExpression;
  NSString *duePattern = @"(( due| due on| due by| on| for| by| before)( next| last)? (Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|\d\d\d\d-\d\d-\d\d))";
  dueExpression = dueExpression ?: [NSRegularExpression regularExpressionWithPattern:duePattern
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
  __block BOOL foundDate = NO;
  __block NSRange foundRange;
  [todayExpression enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
    if (!foundDate) {
      self.due = [NSDate date];
      foundRange = result.range;
    foundDate = YES;
    }
  }];
  
  [tomorrowExpression enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
    if (!foundDate) {
      self.due = [[NSDate date] dateByAddingTimeInterval:24*3600];
      foundRange = result.range;
      foundDate = YES;
    }
  }];
  
  [yesterdayExpression enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
    if (!foundDate) {
      self.due = [[NSDate date] dateByAddingTimeInterval:(-24*3600)];
      foundRange = result.range;
      foundDate = YES;
    }
  }];
  
  if (foundRange.length > 0) {
    [text replaceCharactersInRange:foundRange withString:@""];
  }
  
  self.basicText = [NSString stringWithString:text];
}


@end
