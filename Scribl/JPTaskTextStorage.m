//
//  JPTaskTextStorage.m
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import "JPTaskTextStorage.h"
#import <PodioKit/PodioKit.h>
#import "NSDate+JPAdditions.h"
#import "JPTextTask.h"

@interface JPTaskTextStorage ()

@property (nonatomic, strong) NSMutableAttributedString *backingString;

@end

@implementation JPTaskTextStorage

- (id)init
{
  self = [super init];
  if (self) {
    _backingString = [NSMutableAttributedString new];
  }
  return self;
}

- (void)setTasks:(NSArray*)tasksArray {
  NSUInteger originalLength = self.backingString.length;
  _backingString = [NSMutableAttributedString new];
  _textTasks = [NSMutableArray new];
  for (PKTTask* task in tasksArray) {
    NSMutableString *taskString = [task.text mutableCopy];
    if (task.dueOn) {
      [taskString appendString:@" due "];
      [taskString appendString:[task.dueOn jp_prettyString]];
    }
    if (task.status == PKTTaskStatusCompleted) {
      [taskString appendString:@" @done"];
    }
    [taskString appendString:@"\n"];
    [self.textTasks addObject:[[JPTextTask alloc] initWithTask:task range:NSMakeRange(self.backingString.length,taskString.length) parentString:self.backingString.string]];
    [self.backingString appendAttributedString:[[NSAttributedString alloc] initWithString:taskString]];
  }
  
  [self edited:(NSTextStorageEditedCharacters|NSTextStorageEditedAttributes) range:NSMakeRange(0, originalLength) changeInLength:self.backingString.length - originalLength];
}

- (NSString *)string {
  return self.backingString.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range {
  return [self.backingString attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
  if (range.length <=1) {
    NSString *replacedSubstring = [self.backingString.string substringWithRange:range];
    if ([replacedSubstring isEqualToString:@"\n"]) {
      for (JPTextTask *task in self.textTasks) {
        if (range.location >= task.range.location && range.location < task.range.location + task.range.length) {
          task.willDelete = YES;
        }
      }
    }
    
    for (JPTextTask *task in self.textTasks) {
      if (task.range.location > range.location) {
        task.range = NSMakeRange(task.range.location + 1, task.range.length);
      } else if (range.location < task.range.location + task.range.length) {
        task.range = NSMakeRange(task.range.location, task.range.length + str.length - range.length);
      }
    }
    
    [self.backingString replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
  }
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
  [self.backingString setAttributes:attrs range:range];
  [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

-(NSRange)rangeOfLineAtIndex:(NSUInteger)index {
  NSUInteger start = index;
  NSUInteger end = index;
  while (start > 0 && ![[self.backingString.string substringFromIndex:start-1] hasPrefix:@"\n"]) {
    start--;
  }
  while (end < self.backingString.length && ![[self.backingString.string substringToIndex:end] hasSuffix:@"\n"]) {
    end++;
  }
  
  return NSMakeRange(start, end-start);
}

-(void)processEditing {
  [super processEditing];
  
  NSRange wholeStringRange = NSMakeRange(0, self.backingString.length);
  
  [self addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Archer-Book" size:20] range:wholeStringRange];
  [self addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:wholeStringRange];
  [self edited:(NSTextStorageEditedAttributes|NSTextStorageEditedCharacters) range:wholeStringRange changeInLength:0];
  
  static NSRegularExpression *dueExpression;
  NSString *duePattern = @"((due|for|by|before)? (today|tomorrow|yesterday))|((due|due on|due by|on|for|by|before) (next|last)? (Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|\d\d\d\d-\d\d-\d\d))";
  dueExpression = dueExpression ?: [NSRegularExpression regularExpressionWithPattern:duePattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:NULL];
  
  [dueExpression enumerateMatchesInString:self.backingString.string options:0 range:wholeStringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
    [self addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3 green:0.00 blue:0.4 alpha:1.0] range:result.range];
  }];
  
  static NSRegularExpression *doneExpression;
  NSString *pattern = @"@done";
  doneExpression = doneExpression ?: [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:0
                                                                                 error:NULL];
  
  [doneExpression enumerateMatchesInString:self.backingString.string options:0 range:wholeStringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
    [self addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[self rangeOfLineAtIndex:result.range.location]];
  }];
  
  
}

@end
