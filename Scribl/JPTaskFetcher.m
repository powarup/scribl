//
//  JPTaskFetcher.m
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import "JPTaskFetcher.h"
#import <PodioKit/PodioKit.h>

@interface JPTaskFetcher ()

@property (nonatomic, copy) NSArray *tasks;

@end

@implementation JPTaskFetcher

+(instancetype)defaultTaskFetcher {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

-(instancetype)init {
  self = [super init];
  if (self) {
    [self restoreSavedSessionIfNeeded];
    [self updateTasks];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAuthenticationNotification:) name:PKTClientAuthenticationStateDidChangeNotification object:nil];
    
  }
  return self;
}

-(void)restoreSavedSessionIfNeeded {
  if (![PodioKit isAuthenticated]) {
    PKTAsyncTask *authTask = [PodioKit authenticateAsUserWithEmail:@"lefthand@powarup.com" password:@"facepunch1"];
    
    [authTask onComplete:^(PKTResponse *response, NSError *error) {
      if (!error) {
        NSLog(@"successfully authenticated");
      } else {
        NSLog(@"failed to authenticate\n%@",error);
      }
    }];
  }
}

-(void)receiveAuthenticationNotification:(NSNotification*)notification {
  if ([PodioKit isAuthenticated]) {
    [self updateTasks];
  }
}

-(void)updateTasks {
  NSDate *past = [NSDate distantPast];
  NSDate *future = [NSDate distantFuture];
  
  PKTTaskRequestParameters *todayParameters = [PKTTaskRequestParameters parameters];
  todayParameters.dueDateRange = [[PKTDateRange alloc] initWithStartDate:past endDate:future];
  todayParameters.responsibleUserID = [[PKTClient defaultClient].oauthToken.refData[@"id"] intValue];
  
  PKTAsyncTask *fetchedTasks = [PKTTask fetchWithParameters:todayParameters offset:0 limit:0];
  [fetchedTasks onComplete:^(id result, NSError *error) {
    if (!error) {
      for (PKTTask *task in result) {
        NSLog(@"task fetched");
      }
    } else {
      NSLog(@"today fetch returned error: %@",error.description);
    }
  }];
  

}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
