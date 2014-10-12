//
//  NSDate+JPAdditions.m
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import "NSDate+JPAdditions.h"

@implementation NSDate (JPAdditions)

-(NSString*)jp_prettyString {
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
  NSDate *today = [cal dateFromComponents:components];
  components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
  NSDate *otherDate = [cal dateFromComponents:components];
  
  if([today isEqualToDate:otherDate]) {
    return @"today";
  } else return @"tomorrow";
}

@end
